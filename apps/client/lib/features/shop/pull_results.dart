import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';

/// What just came out of the pack.
///
/// The whole point of a pull is the moment it is revealed, so it gets the
/// screen: everything else dims and the draw is the only thing lit. A result
/// that scrolled past in a corner would make the pack feel like a transaction.
class PullResults extends StatefulWidget {
  const PullResults({required this.draws, required this.config, super.key});

  /// One entry per pack opened, in the order they were drawn.
  final List<SkillPackResult> draws;

  final BalanceConfig config;

  static Future<void> show(
    BuildContext context, {
    required List<SkillPackResult> draws,
    required BalanceConfig config,
  }) {
    if (draws.isEmpty) return Future.value();

    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.93),
      builder: (context) => PullResults(draws: draws, config: config),
    );
  }

  @override
  State<PullResults> createState() => _PullResultsState();
}

class _PullResultsState extends State<PullResults>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 260 + widget.draws.length * 70),
  )..forward();

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final single = widget.draws.length == 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            single ? 'ONE PULL' : '${widget.draws.length} PULLS',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 18),
          if (single)
            _Single(
              draw: widget.draws.single,
              config: widget.config,
              reveal: _reveal,
            )
          else
            _Honeycomb(
              draws: widget.draws,
              config: widget.config,
              reveal: _reveal,
            ),
          const SizedBox(height: 22),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: GamePalette.bone),
            child: const Text('TAKE THEM'),
          ),
        ],
      ),
    );
  }
}

/// One draw, alone in the middle, at the size it deserves.
class _Single extends StatelessWidget {
  const _Single({
    required this.draw,
    required this.config,
    required this.reveal,
  });

  final SkillPackResult draw;
  final BalanceConfig config;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    final skill = config.skills[draw.skillId];
    final rank = config.rarities[skill?.rarity]?.rank ?? 0;
    final colour = rarityColour(rank);

    return _Revealed(
      reveal: reveal,
      index: 0,
      total: 1,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colour, width: 2),
          boxShadow: [
            BoxShadow(
              color: colour.withValues(alpha: 0.35),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Glyph(
              colour: colour,
              wide: skill?.hitsEveryone ?? false,
              size: 78,
            ),
            const SizedBox(height: 16),
            Text(
              shortName(draw.skillId ?? ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colour,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              (skill?.rarity ?? '').toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 12),
            _Tag(learned: draw.learned, pity: draw.wasPity, colour: colour),
          ],
        ),
      ),
    );
  }
}

/// Ten draws as a honeycomb: three, four, three.
///
/// Not a grid. A ten-pull is the loudest thing the shop does, and a rectangle
/// of identical squares reads like a spreadsheet of what you bought. The
/// staggered rows put the widest row — and the best odds of something good
/// being in it — across the middle of the screen.
class _Honeycomb extends StatelessWidget {
  const _Honeycomb({
    required this.draws,
    required this.config,
    required this.reveal,
  });

  final List<SkillPackResult> draws;
  final BalanceConfig config;
  final Animation<double> reveal;

  /// Rows are sized so the total is ten and the middle one is widest.
  static const _rows = [3, 4, 3];

  @override
  Widget build(BuildContext context) {
    final rows = <List<int>>[];
    var taken = 0;
    for (final size in _rows) {
      if (taken >= draws.length) break;
      final end = (taken + size).clamp(0, draws.length);
      rows.add([for (var i = taken; i < end; i++) i]);
      taken = end;
    }
    // Anything the fixed rows did not cover goes on the end rather than
    // vanishing: a pull the player paid for must appear.
    if (taken < draws.length) {
      rows.add([for (var i = taken; i < draws.length; i++) i]);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final widest = rows.fold<int>(1, (m, r) => r.length > m ? r.length : m);
        final cell = ((constraints.maxWidth - 40) / widest).clamp(46.0, 68.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in rows)
              Padding(
                // Overlap the rows slightly, the way cells in a comb sit.
                padding: EdgeInsets.only(top: rows.first == row ? 0 : 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final index in row)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _Cell(
                          draw: draws[index],
                          config: config,
                          reveal: reveal,
                          index: index,
                          total: draws.length,
                          size: cell,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.draw,
    required this.config,
    required this.reveal,
    required this.index,
    required this.total,
    required this.size,
  });

  final SkillPackResult draw;
  final BalanceConfig config;
  final Animation<double> reveal;
  final int index;
  final int total;
  final double size;

  @override
  Widget build(BuildContext context) {
    final skill = config.skills[draw.skillId];
    final rank = config.rarities[skill?.rarity]?.rank ?? 0;
    final colour = rarityColour(rank);

    return _Revealed(
      reveal: reveal,
      index: index,
      total: total,
      child: SizedBox(
        width: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                _Glyph(
                  colour: colour,
                  wide: skill?.hitsEveryone ?? false,
                  size: size,
                ),
                if (draw.learned)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: GamePalette.gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: GamePalette.forgeDark,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              shortName(draw.skillId ?? ''),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9, color: colour),
            ),
          ],
        ),
      ),
    );
  }
}

/// The six-sided cell everything is drawn in.
class _Glyph extends StatelessWidget {
  const _Glyph({required this.colour, required this.wide, required this.size});

  final Color colour;
  final bool wide;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _HexClipper(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colour.withValues(alpha: 0.42), GamePalette.forgeDark],
          ),
        ),
        child: Icon(
          wide ? Icons.blur_on : Icons.bolt,
          size: size * 0.4,
          color: colour,
        ),
      ),
    );
  }
}

/// A flat-topped hexagon.
class _HexClipper extends CustomClipper<Path> {
  const _HexClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    return Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Whether a draw taught the skill or added to the pile.
class _Tag extends StatelessWidget {
  const _Tag({required this.learned, required this.pity, required this.colour});

  final bool learned;
  final bool pity;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final label = learned
        ? 'NEW SKILL'
        : (pity ? 'GUARANTEED · +1 COPY' : '+1 COPY');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colour.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
          color: colour,
        ),
      ),
    );
  }
}

/// Reveals its child in turn rather than all at once.
///
/// A pull that appears complete the instant it is paid for is a receipt. The
/// stagger is short enough not to be in the way of a player opening ten packs
/// in a row.
class _Revealed extends StatelessWidget {
  const _Revealed({
    required this.reveal,
    required this.index,
    required this.total,
    required this.child,
  });

  final Animation<double> reveal;
  final int index;
  final int total;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final step = total <= 1 ? 0.0 : (index / total) * 0.6;
    final curved = CurvedAnimation(
      parent: reveal,
      curve: Interval(
        step,
        (step + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOut,
      ),
    );

    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.7, end: 1).animate(curved),
        child: child,
      ),
    );
  }
}
