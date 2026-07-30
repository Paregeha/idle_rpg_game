import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';

/// What the player earned while away.
///
/// Shows how long they were gone as well as what was credited, rather than only
/// the credited figure. A player away for three days who is handed eight hours
/// of income can do that arithmetic; hiding the cap reads as a bug, naming it
/// reads as a rule.
class OfflineReportSheet extends StatelessWidget {
  const OfflineReportSheet({required this.report, super.key});

  final OfflineReport report;

  static Future<void> show(BuildContext context, OfflineReport report) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: GamePalette.forgeSurface,
      builder: (context) => OfflineReportSheet(report: report),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('WHILE YOU WERE AWAY', style: text.labelSmall),
            const SizedBox(height: 14),
            for (final gain in report.gains.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gain.key,
                      style: text.bodyMedium?.copyWith(color: GamePalette.ash),
                    ),
                    Text(
                      '+${gain.value.format()}',
                      style: counterStyle(context, color: GamePalette.gold),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            Text(
              report.wasCapped
                  ? 'Away ${formatWait(report.awayFor)}, credited '
                        '${formatWait(report.creditedFor)} — the offline cap.'
                  : 'Away ${formatWait(report.awayFor)}.',
              style: text.bodySmall?.copyWith(color: GamePalette.ash),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: GamePalette.emberDim,
                  foregroundColor: GamePalette.bone,
                ),
                child: const Text('COLLECT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
