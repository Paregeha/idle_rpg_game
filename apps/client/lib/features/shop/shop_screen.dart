import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/features/skills/skill_card.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';
import 'package:idle_rpg/widgets/resource_bar.dart';
import 'package:idle_rpg/widgets/resource_overlay.dart';

/// What the shop sells, one counter per tab.
///
/// One entry today. It is still a tab row rather than a bare page, because the
/// shop is where skins, the unique set and the gem bundles all land — and a
/// navigation bar that appears the day the second thing ships teaches the
/// player the game moved under them.
enum ShopTab {
  skills('SKILLS', Icons.bolt);

  const ShopTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Where currency is turned into things.
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  ShopTab _tab = ShopTab.skills;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    return Column(
      children: [
        _Header(
          selected: _tab,
          onSelected: (tab) => setState(() => _tab = tab),
        ),
        Expanded(
          child: switch (_tab) {
            ShopTab.skills => _SkillsCounter(config: config, state: state),
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.selected, required this.onSelected});

  final ShopTab selected;
  final ValueChanged<ShopTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GamePalette.forgeSurface,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        children: [
          // A shop that does not show the wallet makes the player leave to
          // check whether they can afford what they are looking at.
          const ResourceOverlay(),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final tab in ShopTab.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => onSelected(tab),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: tab == selected
                              ? GamePalette.emberDim
                              : GamePalette.forgeDark,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: tab == selected
                                ? GamePalette.emberBright
                                : GamePalette.forgeRaised,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tab.icon,
                              size: 15,
                              color: tab == selected
                                  ? GamePalette.bone
                                  : GamePalette.ash,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: tab == selected
                                    ? GamePalette.bone
                                    : GamePalette.ash,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The skill pack, and what is in the pool it draws from.
class _SkillsCounter extends ConsumerWidget {
  const _SkillsCounter({required this.config, required this.state});

  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = config.skills.keys.toList()
      ..sort((a, b) {
        final byRank = _rank(b).compareTo(_rank(a));
        return byRank != 0 ? byRank : a.compareTo(b);
      });

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      children: [
        _PackCard(config: config, state: state),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'IN THE POOL',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        // Every skill the pack can draw, whether owned or not. A pool the
        // player cannot see is a pool they have no reason to pull from.
        for (final id in ids)
          _PoolRow(
            skillId: id,
            skill: config.skills[id]!,
            rank: _rank(id),
            level: state.skills[id] ?? 0,
            copies: state.skillCopies[id] ?? 0,
          ),
      ],
    );
  }

  int _rank(String id) => config.rarities[config.skills[id]?.rarity]?.rank ?? 0;
}

class _PackCard extends ConsumerWidget {
  const _PackCard({required this.config, required this.state});

  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = config.skillPack;
    final price = BigNum.fromDouble(pack.costAmount);
    final balance = ref.watch(resourceProvider(pack.costResource));
    final affordable = balance >= price;

    final odds = pack.weights.entries.toList()
      ..sort((a, b) {
        final rankA = config.rarities[a.key]?.rank ?? 0;
        final rankB = config.rarities[b.key]?.rank ?? 0;
        return rankB.compareTo(rankA);
      });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GamePalette.patina),
                  gradient: const LinearGradient(
                    colors: [Color(0x334FB3A0), GamePalette.forgeDark],
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_motion,
                  size: 24,
                  color: GamePalette.patina,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Skill pack',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: GamePalette.bone,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'ONE COPY, DRAWN BY RARITY',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // The odds are published rather than hidden. A player who cannot see
          // them assumes the worst, and they are usually right to.
          for (final entry in odds)
            _OddsRow(
              rarity: entry.key,
              rank: config.rarities[entry.key]?.rank ?? 0,
              chance: pack.totalWeight <= 0
                  ? 0
                  : entry.value / pack.totalWeight,
            ),
          if (pack.hasPity) ...[
            const SizedBox(height: 12),
            _Pity(
              done: state.skillPity,
              threshold: pack.pityThreshold,
              rarity: pack.pityRarity,
              rank: config.rarities[pack.pityRarity]?.rank ?? 0,
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: affordable
                    ? const LinearGradient(
                        colors: [GamePalette.emberBright, GamePalette.emberDim],
                      )
                    : null,
                color: affordable ? null : GamePalette.forgeRaised,
              ),
              child: TextButton(
                onPressed: affordable
                    ? () => ref
                          .read(gameControllerProvider.notifier)
                          .openSkillPack()
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: GamePalette.bone,
                  disabledForegroundColor: GamePalette.ash,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      affordable ? 'OPEN' : 'NOT ENOUGH',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: currencyColour(pack.costResource),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      price.format(),
                      style: counterStyle(context, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OddsRow extends StatelessWidget {
  const _OddsRow({
    required this.rarity,
    required this.rank,
    required this.chance,
  });

  final String rarity;
  final int rank;
  final double chance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: rarityColour(rank),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rarity.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Text(
            '${(chance * 100).toStringAsFixed(chance < 0.01 ? 2 : 1)}%',
            style: counterStyle(context, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// How close the guarantee is.
///
/// Shown because a guarantee the player never sees is a guarantee they do not
/// believe exists — and the run of bad luck it exists to bound is the most
/// common reason people quit a gacha.
class _Pity extends StatelessWidget {
  const _Pity({
    required this.done,
    required this.threshold,
    required this.rarity,
    required this.rank,
  });

  final int done;
  final int threshold;
  final String rarity;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final left = (threshold - done).clamp(0, threshold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$left MORE FOR A GUARANTEED ${rarity.toUpperCase()}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            Text(
              '$done/$threshold',
              style: counterStyle(context, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: threshold == 0 ? 0 : done / threshold,
            minHeight: 4,
            backgroundColor: GamePalette.forgeRaised,
            valueColor: AlwaysStoppedAnimation(rarityColour(rank)),
          ),
        ),
      ],
    );
  }
}

/// One skill in the pool, with what the player already has of it.
class _PoolRow extends StatelessWidget {
  const _PoolRow({
    required this.skillId,
    required this.skill,
    required this.rank,
    required this.level,
    required this.copies,
  });

  final String skillId;
  final SkillConfig skill;
  final int rank;
  final int level;
  final int copies;

  @override
  Widget build(BuildContext context) {
    final colour = rarityColour(rank);
    final owned = level > 0;

    return GestureDetector(
      onTap: () => SkillCard.show(context, skillId: skillId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: colour, width: 3)),
        ),
        child: Row(
          children: [
            Icon(
              skill.hitsEveryone ? Icons.blur_on : Icons.bolt,
              size: 18,
              color: owned ? colour : GamePalette.ash,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shortName(skillId),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: owned ? colour : GamePalette.ash,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    owned
                        ? 'LV $level  ·  $copies SPARE'
                        : 'HERO LV ${skill.unlockAtLevel} TO USE',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Icon(
              owned ? Icons.chevron_right : Icons.help_outline,
              size: 18,
              color: GamePalette.ash,
            ),
          ],
        ),
      ),
    );
  }
}
