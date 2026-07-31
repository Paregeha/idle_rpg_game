import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/features/upgrades/upgrades_screen.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';
import 'package:idle_rpg/widgets/resource_bar.dart';

/// The two things the forge does.
enum ForgeTab {
  upgrades('INCOME', Icons.trending_up),
  craft('CRAFT', Icons.hardware);

  const ForgeTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Where money is turned into income, and materials into gear.
///
/// Both belong to the forge and neither belongs in the shop: nothing here is
/// bought from anyone. Splitting them into counters keeps the income list from
/// burying a recipe the player has been saving for.
class ForgeScreen extends ConsumerStatefulWidget {
  const ForgeScreen({super.key});

  @override
  ConsumerState<ForgeScreen> createState() => _ForgeScreenState();
}

class _ForgeScreenState extends ConsumerState<ForgeScreen> {
  ForgeTab _tab = ForgeTab.upgrades;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    return Column(
      children: [
        _Tabs(selected: _tab, onSelected: (tab) => setState(() => _tab = tab)),
        Expanded(
          child: switch (_tab) {
            ForgeTab.upgrades => const UpgradesScreen(),
            ForgeTab.craft => _CraftList(config: config, state: state),
          },
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onSelected});

  final ForgeTab selected;
  final ValueChanged<ForgeTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GamePalette.forgeSurface,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        children: [
          const ResourceOverlayForForge(),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final tab in ForgeTab.values)
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

/// Currencies plus the materials, because a recipe is priced in both.
class ResourceOverlayForForge extends ConsumerWidget {
  const ResourceOverlayForForge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    if (config == null) return const SizedBox.shrink();

    final keys = [...config.displayedResources, ...config.materialResources];

    return SizedBox(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          for (final key in keys)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Pill(resourceKey: key),
            ),
        ],
      ),
    );
  }
}

class _Pill extends ConsumerWidget {
  const _Pill({required this.resourceKey});

  final String resourceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(resourceProvider(resourceKey));
    final colour = currencyColour(resourceKey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GamePalette.forgeDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(value.format(), style: counterStyle(context, fontSize: 12)),
        ],
      ),
    );
  }
}

/// Every recipe, locked ones included.
///
/// A recipe shown while it is still out of reach is a goal. One hidden until
/// it is available is a surprise, and a player cannot save towards a surprise.
class _CraftList extends StatelessWidget {
  const _CraftList({required this.config, required this.state});

  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final ids = config.recipes.keys.toList()
      ..sort((a, b) {
        final byLevel = config.recipes[a]!.unlockAtHeroLevel.compareTo(
          config.recipes[b]!.unlockAtHeroLevel,
        );
        return byLevel != 0 ? byLevel : a.compareTo(b);
      });

    if (ids.isEmpty) {
      return Center(
        child: Text(
          'The forge has no recipes yet.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      children: [
        for (final id in ids)
          _RecipeCard(recipeId: id, config: config, state: state),
      ],
    );
  }
}

class _RecipeCard extends ConsumerWidget {
  const _RecipeCard({
    required this.recipeId,
    required this.config,
    required this.state,
  });

  final String recipeId;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = config.recipes[recipeId]!;
    final item = config.items[recipe.produces];
    final rank = config.rarities[item?.rarity]?.rank ?? 0;
    final colour = rarityColour(rank);

    // The craft itself decides whether it would go through, so the button
    // cannot promise something the rules refuse.
    final refusal = craft(state, recipeId, config).refusal;
    final made = state.inventory.values
        .where((owned) => owned.configId == recipe.produces)
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colour.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: colour),
                  gradient: LinearGradient(
                    colors: [
                      colour.withValues(alpha: 0.3),
                      GamePalette.forgeDark,
                    ],
                  ),
                ),
                child: Icon(
                  itemKindIcon(item?.slot ?? ''),
                  size: 22,
                  color: colour,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortName(recipe.produces),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colour,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(item?.rarity ?? '').toUpperCase()} · '
                      '${(item?.slot ?? '').toUpperCase()}'
                      '${made > 0 ? '  ·  $made MADE' : ''}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final cost in recipe.costs.entries)
            _CostRow(resourceKey: cost.key, needed: cost.value),
          const SizedBox(height: 12),
          _CraftButton(
            refusal: refusal,
            unlockAtHeroLevel: recipe.unlockAtHeroLevel,
            onPressed: () =>
                ref.read(gameControllerProvider.notifier).craft(recipeId),
          ),
        ],
      ),
    );
  }
}

class _CostRow extends ConsumerWidget {
  const _CostRow({required this.resourceKey, required this.needed});

  final String resourceKey;
  final BigNum needed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final held = ref.watch(resourceProvider(resourceKey));
    final enough = held >= needed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: currencyColour(resourceKey),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              resourceKey.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          // Held against needed, not just the price: "you need 120" is a
          // number, "you have 48 of 120" is a plan.
          Text(
            '${held.format()} / ${needed.format()}',
            style: counterStyle(
              context,
              fontSize: 12,
              color: enough ? GamePalette.bone : GamePalette.ash,
            ),
          ),
        ],
      ),
    );
  }
}

class _CraftButton extends StatelessWidget {
  const _CraftButton({
    required this.refusal,
    required this.unlockAtHeroLevel,
    required this.onPressed,
  });

  final CraftRefusal? refusal;
  final int unlockAtHeroLevel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = switch (refusal) {
      null => 'FORGE IT',
      CraftRefusal.cannotAfford => 'NOT ENOUGH MATERIALS',
      CraftRefusal.lockedByLevel => 'HERO LV $unlockAtHeroLevel',
      CraftRefusal.unknownRecipe => 'UNAVAILABLE',
      CraftRefusal.unknownItem => 'UNAVAILABLE',
    };
    final ready = refusal == null;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
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
              borderRadius: BorderRadius.circular(22),
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
