import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// One skill, in the same language as the item card.
///
/// A skill is bought in copies and spent in copies, so the card leads with how
/// many are banked and how many the next level takes. Everything else on it is
/// what the cast actually does, at this level and at the next.
class SkillCard extends ConsumerWidget {
  const SkillCard({required this.skillId, super.key});

  final String skillId;

  static Future<void> show(BuildContext context, {required String skillId}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (context) => SkillCard(skillId: skillId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final skill = config.skills[skillId];
    final rarity = skill == null ? null : config.rarities[skill.rarity];
    if (skill == null || rarity == null) return const SizedBox.shrink();

    final level = state.skills[skillId] ?? 0;
    final learned = level > 0;
    final copies = state.skillCopies[skillId] ?? 0;
    final maxed = level >= skill.maxLevel;
    final locked = state.heroLevel < skill.unlockAtLevel;
    final colour = rarityColour(rarity.rank);

    // The upgrade itself decides whether it would go through, so the button
    // cannot promise something the rules refuse.
    final refusal = upgradeSkill(state, skillId, config).refusal;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: GamePalette.forgeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colour.withValues(alpha: 0.55), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Head(
                skillId: skillId,
                skill: skill,
                rank: rarity.rank,
                rarityCount: config.rarities.length,
                level: level,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    _Line(
                      label: 'DAMAGE',
                      now: learned
                          ? '×${skill.damageAt(level).toStringAsFixed(2)}'
                          : '—',
                      next: maxed || !learned
                          ? null
                          : '×${skill.damageAt(level + 1).toStringAsFixed(2)}',
                    ),
                    _Line(
                      label: 'COOLDOWN',
                      now: '${skill.cooldownSeconds.toStringAsFixed(0)}s',
                    ),
                    _Line(
                      label: 'TARGETS',
                      now: skill.hitsEveryone ? 'EVERY' : '${skill.targets}',
                    ),
                    if (locked)
                      _Line(
                        label: 'NEEDS HERO',
                        now: 'LV ${skill.unlockAtLevel}',
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    if (!maxed)
                      _Copies(
                        held: copies,
                        needed: learned ? skill.copiesFor(level) : 1,
                        learned: learned,
                      ),
                    const SizedBox(height: 12),
                    _UpgradeButton(
                      level: level,
                      learned: learned,
                      maxed: maxed,
                      refusal: refusal,
                      onPressed: () => ref
                          .read(gameControllerProvider.notifier)
                          .upgradeSkillById(skillId),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: GamePalette.ash,
                        ),
                        child: const Text('CLOSE'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head({
    required this.skillId,
    required this.skill,
    required this.rank,
    required this.rarityCount,
    required this.level,
  });

  final String skillId;
  final SkillConfig skill;
  final int rank;
  final int rarityCount;
  final int level;

  @override
  Widget build(BuildContext context) {
    final colour = rarityColour(rank);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colour, width: 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colour.withValues(alpha: 0.28), GamePalette.forgeDark],
              ),
            ),
            child: Icon(
              skill.hitsEveryone ? Icons.blur_on : Icons.bolt,
              size: 32,
              color: colour,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortName(skillId),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colour,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${skill.rarity.toUpperCase()} · SKILL',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (var i = 0; i < rarityCount; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          i <= rank ? Icons.star : Icons.star_border,
                          size: 13,
                          color: i <= rank
                              ? GamePalette.gold
                              : GamePalette.forgeRaised,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: level / skill.maxLevel,
                          minHeight: 4,
                          backgroundColor: GamePalette.forgeRaised,
                          valueColor: const AlwaysStoppedAnimation(
                            GamePalette.gold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$level/${skill.maxLevel}',
                      style: counterStyle(
                        context,
                        fontSize: 11,
                        color: GamePalette.ash,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.now, this.next});

  final String label;
  final String now;
  final String? next;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.labelSmall),
          ),
          Text(now, style: counterStyle(context, fontSize: 14)),
          if (next != null && next != now) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_right_alt,
                size: 15,
                color: GamePalette.ash,
              ),
            ),
            Text(
              next!,
              style: counterStyle(
                context,
                fontSize: 14,
                color: GamePalette.patina,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Copies banked against copies needed — the whole price of a skill level.
class _Copies extends StatelessWidget {
  const _Copies({
    required this.held,
    required this.needed,
    required this.learned,
  });

  final int held;
  final int needed;
  final bool learned;

  @override
  Widget build(BuildContext context) {
    // Beyond a handful, pips stop being countable and the number does the job.
    final showPips = needed <= 8;

    return Row(
      children: [
        Text(
          learned ? 'COPIES' : 'TO LEARN',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(width: 10),
        if (showPips)
          for (var i = 0; i < needed; i++)
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Icon(
                i < held ? Icons.circle : Icons.circle_outlined,
                size: 10,
                color: i < held ? GamePalette.patina : GamePalette.forgeRaised,
              ),
            ),
        const Spacer(),
        Text(
          '$held/$needed',
          style: counterStyle(
            context,
            fontSize: 13,
            color: held >= needed ? GamePalette.bone : GamePalette.ash,
          ),
        ),
      ],
    );
  }
}

class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton({
    required this.level,
    required this.learned,
    required this.maxed,
    required this.refusal,
    required this.onPressed,
  });

  final int level;
  final bool learned;
  final bool maxed;
  final SkillRefusal? refusal;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = switch (refusal) {
      null => 'UPGRADE  →  LV ${level + 1}',
      SkillRefusal.notLearned => 'NOT LEARNED YET',
      SkillRefusal.alreadyMaxLevel => 'FULLY LEARNED',
      SkillRefusal.notEnoughCopies => 'NEEDS MORE COPIES',
      SkillRefusal.unknownSkill => 'UNAVAILABLE',
    };
    final ready = refusal == null && learned && !maxed;

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: ready
              ? const LinearGradient(
                  colors: [GamePalette.emberBright, GamePalette.emberDim],
                )
              : null,
          color: ready ? null : GamePalette.forgeRaised,
        ),
        child: TextButton(
          onPressed: ready ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: GamePalette.bone,
            disabledForegroundColor: GamePalette.ash,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
