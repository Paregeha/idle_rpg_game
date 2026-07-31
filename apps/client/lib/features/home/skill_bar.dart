import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/features/skills/skill_card.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The skill row: what casts during a fight, and the pack that fills it.
///
/// Every skill the config knows about gets a slot, learned or not. A locked
/// slot says the hero level it opens at rather than showing a bare padlock —
/// "come back at 12" is a goal, "locked" is a wall.
class SkillBar extends ConsumerWidget {
  const SkillBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    // Ordered by when they open, so the row reads as a path rather than a pile.
    final ids = config.skills.keys.toList()
      ..sort((a, b) {
        final byLevel = config.skills[a]!.unlockAtLevel.compareTo(
          config.skills[b]!.unlockAtLevel,
        );
        return byLevel != 0 ? byLevel : a.compareTo(b);
      });

    return Container(
      height: 54,
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 4),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Row(
        children: [
          _AutoToggle(on: state.autoCast),
          for (final id in ids)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _Slot(skillId: id, config: config, state: state),
              ),
            ),
          _PackButton(config: config, state: state),
        ],
      ),
    );
  }
}

/// Turns auto-casting on and off, and looks like whichever it is.
///
/// Lit means skills fire. Unlit means the hero swings on gear alone — the
/// fight is resolved in one pass before it is drawn, so there is no moment
/// during it at which a tap could land.
class _AutoToggle extends ConsumerWidget {
  const _AutoToggle({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(gameControllerProvider.notifier).toggleAutoCast(),
      child: Container(
        width: 42,
        height: 38,
        decoration: BoxDecoration(
          color: on ? GamePalette.emberDim : GamePalette.forgeDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: on ? GamePalette.emberBright : GamePalette.forgeRaised,
          ),
          boxShadow: on
              ? [
                  BoxShadow(
                    color: GamePalette.emberBright.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          'AUTO',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w700,
            color: on ? GamePalette.bone : GamePalette.ash,
          ),
        ),
      ),
    );
  }
}

class _Slot extends ConsumerWidget {
  const _Slot({
    required this.skillId,
    required this.config,
    required this.state,
  });

  final String skillId;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skill = config.skills[skillId]!;
    final rank = config.rarities[skill.rarity]?.rank ?? 0;
    final level = state.skills[skillId] ?? 0;
    final learned = level > 0;
    final tooLow = state.heroLevel < skill.unlockAtLevel;
    // Auto-cast off means nothing goes off, so nothing may look like it is
    // about to: a ring still charging beside a dark AUTO is a lie.
    final firing = learned && !tooLow && state.autoCast;
    final colour = firing ? rarityColour(rank) : GamePalette.ash;
    final icon = !learned
        ? Icons.lock_outline
        : (skill.hitsEveryone ? Icons.blur_on : Icons.bolt);

    return GestureDetector(
      onTap: () => SkillCard.show(context, skillId: skillId),
      // Sized square rather than left to the row: a circle drawn inside a wide
      // box puts its badges at the edge of the box, not of the circle.
      child: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: GamePalette.forgeDark,
            shape: BoxShape.circle,
            border: Border.all(
              color: firing ? rarityColour(rank) : GamePalette.forgeRaised,
              width: firing ? 1.5 : 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (firing)
                _Cooldown(
                  clock: ref.watch(fightClockProvider),
                  cooldownMs: skill.cooldownMs,
                  colour: rarityColour(rank),
                ),
              Icon(icon, size: 15, color: colour),
              if (firing)
                Positioned(
                  right: 2,
                  bottom: 1,
                  child: Text(
                    '$level',
                    style: counterStyle(
                      context,
                      fontSize: 9,
                      color: GamePalette.gold,
                    ),
                  ),
                )
              else if (tooLow)
                // The level it opens at, not a padlock: a goal beats a wall.
                Positioned(
                  right: 2,
                  bottom: 1,
                  child: Text(
                    '${skill.unlockAtLevel}',
                    style: counterStyle(
                      context,
                      fontSize: 9,
                      color: GamePalette.ash,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// How long until this skill fires again.
///
/// Read straight off the fight's own clock rather than a timer of its own: the
/// resolver casts at whole multiples of the cooldown from the start of the
/// fight, so the same arithmetic here cannot drift away from what the player
/// is watching.
class _Cooldown extends StatelessWidget {
  const _Cooldown({
    required this.clock,
    required this.cooldownMs,
    required this.colour,
  });

  final ValueNotifier<double> clock;
  final int cooldownMs;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: clock,
      builder: (context, elapsedMs, _) {
        if (cooldownMs <= 0) return const SizedBox.shrink();
        final charge = (elapsedMs % cooldownMs) / cooldownMs;

        return SizedBox.expand(
          child: CircularProgressIndicator(
            value: charge,
            strokeWidth: 2.5,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(colour.withValues(alpha: 0.85)),
          ),
        );
      },
    );
  }
}

/// Buys one skill pack, priced where the player can see it.
class _PackButton extends ConsumerWidget {
  const _PackButton({required this.config, required this.state});

  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = config.skillPack;
    final price = BigNum.fromDouble(pack.costAmount);
    final affordable =
        (state.resources[pack.costResource] ?? BigNum.zero) >= price;

    return GestureDetector(
      onTap: affordable
          ? () => ref.read(gameControllerProvider.notifier).openSkillPack()
          : null,
      child: Container(
        width: 46,
        height: 38,
        margin: const EdgeInsets.only(left: 3),
        decoration: BoxDecoration(
          color: affordable ? GamePalette.forgeRaised : GamePalette.forgeDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: affordable ? GamePalette.patina : GamePalette.forgeRaised,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_motion,
              size: 14,
              color: affordable ? GamePalette.patina : GamePalette.ash,
            ),
            const SizedBox(height: 1),
            Text(
              price.format(),
              style: counterStyle(
                context,
                fontSize: 8,
                color: affordable ? GamePalette.bone : GamePalette.ash,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
