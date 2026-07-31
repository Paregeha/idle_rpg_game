import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:game_core/game_core.dart' as core;
import 'package:idle_rpg/data/save_providers.dart';
import 'package:idle_rpg/data/save_repository.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// How often the local view of the state is advanced.
///
/// 30 Hz is smooth enough for counters and cheap enough to run continuously.
/// It is a *display* rate, not a simulation rate: `simulate` pays progress in
/// whole seconds and carries the remainder, so ticking faster or slower cannot
/// change how much the player earns (ADR-007).
const Duration tickInterval = Duration(milliseconds: 33);

/// Owns the player's state while the app is in the foreground.
///
/// The client simulates locally only so the numbers move smoothly. The server
/// remains the authority and will overwrite this on every sync (ADR-001) — no
/// gameplay decision may be made from this state alone.
class GameController extends Notifier<PlayerState?> {
  Timer? _ticker;
  Timer? _autosave;
  int _lastTickMs = 0;

  @override
  PlayerState? build() {
    // Riverpod disposes the notifier when nothing listens; a timer left running
    // would keep a dead state advancing and hold the object alive.
    ref.onDispose(() {
      stopTicking();
      _autosave?.cancel();
    });
    return null;
  }

  BalanceConfig? get _config => ref.read(balanceConfigProvider).value;

  Clock get _clock => ref.read(clockProvider);

  SaveRepository get _saves => ref.read(saveRepositoryProvider);

  /// Restores the local save, or starts a fresh game if there is none.
  ///
  /// A save that cannot be read is treated as no save: the player restarts,
  /// which is bad, but refusing to launch would be worse and is not something
  /// they can act on.
  Future<OfflineReport?> restore() async {
    final config = _config;
    if (config == null) return null;

    await _saves.initialise();
    final record = await _saves.load();
    final nowMs = _clock.nowMs;

    if (record == null) {
      state = newGame(nowMs: nowMs, rngSeed: nowMs, config: config);
      _lastTickMs = nowMs;
      return null;
    }

    // Time passed while the app was not running: credit it through the offline
    // path so the cap applies.
    final report = applyOfflineProgress(
      record.state,
      nowMs: nowMs,
      config: config,
    );
    state = report.state;
    _lastTickMs = nowMs;
    return report;
  }

  /// Starts a fresh game without touching disk. Used by tests and by a reset.
  void load({PlayerState? saved}) {
    final config = _config;
    if (config == null) return;

    final nowMs = _clock.nowMs;

    if (saved == null) {
      state = newGame(nowMs: nowMs, rngSeed: nowMs, config: config);
    } else {
      state = applyOfflineProgress(saved, nowMs: nowMs, config: config).state;
    }

    _lastTickMs = nowMs;
  }

  /// Writes the current state to disk. Safe to call when there is nothing yet.
  Future<void> saveNow() async {
    final current = state;
    if (current == null) return;
    await _saves.save(current, nowMs: _clock.nowMs);
  }

  void startAutosave() {
    _autosave ??= Timer.periodic(autosaveInterval, (_) => saveNow());
  }

  void stopAutosave() {
    _autosave?.cancel();
    _autosave = null;
  }

  bool get isAutosaving => _autosave != null;

  void startTicking() {
    if (_ticker != null) return;
    _lastTickMs = _clock.nowMs;
    _ticker = Timer.periodic(tickInterval, (_) => tick());
  }

  void stopTicking() {
    _ticker?.cancel();
    _ticker = null;
  }

  bool get isTicking => _ticker != null;

  /// Advances by however long actually passed, not by the nominal interval.
  ///
  /// A dropped frame or a busy main thread makes a timer fire late; crediting a
  /// flat 33 ms per tick would quietly lose that time, and the client would
  /// drift behind the server over a session.
  void tick() {
    final current = state;
    final config = _config;
    if (current == null || config == null) return;

    final nowMs = _clock.nowMs;
    final elapsed = nowMs - _lastTickMs;
    if (elapsed <= 0) return;

    _lastTickMs = nowMs;
    state = simulate(current, Duration(milliseconds: elapsed), config).state;
  }

  /// Buys [count] units of a generator, if the player can afford it.
  ///
  /// Returns whether it went through. This is the shape every player action
  /// takes: the UI asks for an intent and the rules answer. In `T-032` the same
  /// call goes to the server, which runs the same function against its own
  /// state and may disagree — so nothing here may assume success.
  bool buyGenerator(String generatorId, {int count = 1}) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return false;

    final result = core.buyGenerator(
      current,
      generatorId,
      config,
      count: count,
    );
    if (!result.succeeded) return false;

    state = result.state;
    // Save immediately: a purchase is the one action a player would be
    // genuinely annoyed to lose, and the autosave may be nine seconds away.
    unawaited(saveNow());
    return true;
  }

  /// How many units of [generatorId] the player can afford right now.
  int affordable(String generatorId) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return 0;
    return maxAffordable(current, generatorId, config);
  }

  /// Puts an item on. Returns what came off, if anything.
  String? equip(String itemId, {String? intoSlot}) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.equipItem(current, itemId, config, intoSlot: intoSlot);
    if (!result.equipped) return null;

    state = result.state;
    unawaited(saveNow());
    return result.replaced;
  }

  void unequip(String slot) {
    final current = state;
    if (current == null) return;

    state = core.unequipSlot(current, slot);
    unawaited(saveNow());
  }

  /// Equips the strongest available item in every empty or weaker slot.
  ///
  /// "Strongest" is by the attack and health the item actually contributes,
  /// not by rarity: an upgraded common can beat a fresh epic, and sorting by
  /// rarity would quietly hand the player the worse item.
  int equipBest() {
    final config = _config;
    final start = state;
    if (start == null || config == null) return 0;

    var current = start;
    var changed = 0;
    for (final slot in config.slots) {
      final candidates = current.inventory.values.where((owned) {
        final item = config.items[owned.configId];
        return item != null && item.slot == slot.itemKind;
      }).toList();
      if (candidates.isEmpty) continue;

      candidates.sort(
        (a, b) => itemWorth(b, config).compareTo(itemWorth(a, config)),
      );
      final best = candidates.first;
      if (current.equipped[slot.id] == best.id) continue;

      final result = core.equipAndSell(
        current,
        best.id,
        config,
        intoSlot: slot.id,
      );
      if (result.state != current) {
        current = result.state;
        changed++;
      }
    }

    if (changed > 0) {
      state = current;
      unawaited(saveNow());
    }
    return changed;
  }

  /// Opens the lamp once.
  LampResult? openTheLamp() {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.openLamp(current, config);
    if (result.opened) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Raises an item one level.
  UpgradeResult? upgrade(String itemId) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.upgradeItem(current, itemId, config);
    if (result.upgraded) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Raises every gear item a level at a time while the player can pay.
  UpgradeAllResult? upgradeEverything() {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.upgradeAll(current, config);
    if (result.levels > 0) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Raises a skill one level, paying in duplicate copies.
  SkillUpgradeResult? upgradeSkillById(String skillId) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.upgradeSkill(current, skillId, config);
    if (result.upgraded) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Makes one of whatever a recipe produces.
  CraftResult? craft(String recipeId) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.craft(current, recipeId, config);
    if (result.crafted) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Breaks one item down.
  SalvageResult? salvage(String itemId) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.salvageItem(current, itemId, config);
    if (result.salvaged) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Breaks down everything unequipped at or below [maxRank].
  SalvageResult? salvageJunkUpTo(int maxRank) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final result = core.salvageJunk(current, config, maxRank: maxRank);
    if (result.salvaged) {
      state = result.state;
      unawaited(saveNow());
    }
    return result;
  }

  /// Wears [itemId] and sells whatever came off.
  ///
  /// One of each kind, always: the replaced item cannot go back to a bag that
  /// does not hold gear. Equipping and selling are one call because they have
  /// to happen together — if only the first landed, the old item would sit in
  /// the bag having been promised as sold.
  void equipReplacing(String itemId, {String? slotId}) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return;

    final result = core.equipAndSell(current, itemId, config, intoSlot: slotId);
    if (result.state == current) return;

    state = result.state;
    unawaited(saveNow());
  }

  /// Turns auto-casting on or off.
  void toggleAutoCast() {
    final current = state;
    if (current == null) return;

    state = current.copyWith(autoCast: !current.autoCast);
    unawaited(saveNow());
  }

  /// Opens [count] skill packs.
  ///
  /// Stops at the first refusal rather than opening what it can afford: a
  /// ten-pull that quietly became a four-pull is the kind of thing a player
  /// counts and does not forgive.
  SkillPackBatch? openSkillPacks({int count = 1}) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final batch = core.openSkillPacks(current, config, count: count);
    if (batch.opened) {
      state = batch.state;
      unawaited(saveNow());
    }
    return batch;
  }

  /// Records the outcome of a fight and moves the player on.
  ///
  /// Progression lives here rather than in the battle screen: the server will
  /// run the same rules in `T-032`, and a screen that decided where the player
  /// stands would be a second source of truth.
  void resolveFight({required bool won}) {
    final current = state;
    final config = _config;
    if (current == null || config == null) return;

    if (!won) {
      state = afterLoss(current, config);
      return;
    }

    final encounter = encounterFor(current, config);
    final advanced = advanceAfterWin(current, config);

    // The kill reward is paid on the way past, not by the battle scene: the
    // scene is a recording and must not hand out anything.
    final resources = Map<String, BigNum>.of(advanced.resources);
    final earned = Map<String, BigNum>.of(advanced.earnedThisRun);
    if (encounter != null) {
      resources['gold'] = (resources['gold'] ?? BigNum.zero) + encounter.reward;
      earned['gold'] = (earned['gold'] ?? BigNum.zero) + encounter.reward;
    }

    final paid = advanced.copyWith(resources: resources, earnedThisRun: earned);

    var next = encounter == null
        ? paid
        : grantExperience(paid, encounter.experience, config).state;

    // Loot is rolled here for the same reason the reward is: the scene is a
    // recording. Once per monster in the wave, because that is what "a monster
    // drops" means — the group size is already a balance lever.
    //
    // Lamps first, then skills, in a fixed order: the server replays these
    // draws from the same save, and swapping them would produce a different
    // fight's worth of loot from the same seed.
    if (encounter != null) {
      final monster = config.monsters[encounter.monsterId];
      for (var i = 0; i < encounter.monsters.length; i++) {
        if (monster != null) {
          next = rollDrop(next, monster, config).state;
        }
        next = rollSkillDrop(next, config, fromBoss: encounter.isBoss).state;
      }
    }

    state = next;
    unawaited(saveNow());
  }

  /// Called when the app goes to the background.
  ///
  /// Stopping the timer is the whole battery story: a 30 Hz timer that keeps
  /// running behind a locked screen burns power for a screen nobody is looking
  /// at, and earns the player nothing that the offline calculation would not
  /// give them anyway.
  Future<void> onPaused() async {
    stopTicking();
    stopAutosave();
    // Save on the way out, not only on the timer: the app may be killed while
    // backgrounded and never get another chance.
    await saveNow();
  }

  /// Called when the app comes back.
  ///
  /// Credits the gap through the offline path rather than by ticking, so the
  /// cap applies. Ticking through hours of absence would both take a while and
  /// hand out uncapped progress.
  OfflineReport? onResumed() {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final report = applyOfflineProgress(
      current,
      nowMs: _clock.nowMs,
      config: config,
    );

    state = report.state;
    _lastTickMs = _clock.nowMs;
    startTicking();
    startAutosave();
    return report;
  }
}

final gameControllerProvider = NotifierProvider<GameController, PlayerState?>(
  GameController.new,
);

/// A single resource, so a counter rebuilds only when its own number changes.
///
/// Watching the whole state from the resource bar would rebuild it 30 times a
/// second even when nothing it displays has moved.
final resourceProvider = Provider.family<BigNum, String>((ref, key) {
  final state = ref.watch(gameControllerProvider);
  return state?.resources[key] ?? BigNum.zero;
});
