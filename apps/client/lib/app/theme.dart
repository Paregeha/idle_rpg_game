import 'package:flutter/material.dart';

/// The game's palette, taken from its own subject matter.
///
/// The balance config describes an apprentice, a mine, a forge, a vault and a
/// shrine, fighting slimes, wolves, golems and wyrms. That is a world of soot,
/// hot iron and old metal — so the dark theme is warm smoke rather than the
/// neutral near-black a dashboard would use, and the accent is the orange of
/// iron at working heat rather than a neon.
abstract final class GamePalette {
  /// Soot on stone. Warm, so the screen does not read as an office tool.
  static const forgeDark = Color(0xFF16120F);
  static const forgeSurface = Color(0xFF221C17);
  static const forgeRaised = Color(0xFF2E2620);

  /// Iron at working heat. The single loud colour in the app.
  static const emberBright = Color(0xFFE8622A);
  static const emberDim = Color(0xFF8A3416);

  /// Patina on old copper — the secondary currency reads as something aged.
  static const patina = Color(0xFF4FB3A0);

  /// The gold the whole economy is denominated in.
  static const gold = Color(0xFFD4A24C);

  /// Bone and ash, for text.
  static const bone = Color(0xFFEFE6DA);
  static const ash = Color(0xFF9C8F83);
}

/// Numbers in an idle game change several times a second.
///
/// Without tabular figures every digit has its own width, so a counter jitters
/// sideways as it counts — which reads as a broken layout rather than a live
/// one. This is the difference between a game and a spreadsheet in practice,
/// not in decoration.
const List<FontFeature> _tabularNumerals = [
  FontFeature.tabularFigures(),
  FontFeature.slashedZero(),
];

ThemeData buildGameTheme() {
  const scheme = ColorScheme.dark(
    primary: GamePalette.emberBright,
    onPrimary: GamePalette.forgeDark,
    secondary: GamePalette.patina,
    onSecondary: GamePalette.forgeDark,
    surface: GamePalette.forgeSurface,
    onSurface: GamePalette.bone,
    surfaceContainerHighest: GamePalette.forgeRaised,
    outline: GamePalette.emberDim,
    error: Color(0xFFCF5C4A),
  );

  final base = ThemeData(colorScheme: scheme, useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: GamePalette.forgeDark,
    textTheme: base.textTheme
        .apply(bodyColor: GamePalette.bone, displayColor: GamePalette.bone)
        .copyWith(
          // Section labels are set small, heavy and widely tracked, so the
          // hierarchy comes from letterspacing rather than from more colours.
          labelSmall: base.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.6,
            fontWeight: FontWeight.w700,
            color: GamePalette.ash,
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: GamePalette.forgeSurface,
      indicatorColor: GamePalette.emberDim.withValues(alpha: 0.45),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          letterSpacing: 1.2,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? GamePalette.bone : GamePalette.ash,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? GamePalette.emberBright : GamePalette.ash,
        );
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: GamePalette.forgeRaised,
      thickness: 1,
      space: 1,
    ),
  );
}

/// Text style for any number the player watches change.
TextStyle counterStyle(
  BuildContext context, {
  Color? color,
  double? fontSize,
  FontWeight weight = FontWeight.w700,
}) {
  return TextStyle(
    fontSize: fontSize ?? 20,
    fontWeight: weight,
    color: color ?? GamePalette.bone,
    fontFeatures: _tabularNumerals,
    letterSpacing: 0.2,
  );
}
