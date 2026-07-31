/// How gear looks, wherever it is drawn.
///
/// The slot grid, the bag and the item card all show the same item, so the
/// colour, the name and the icon come from here rather than from three
/// places that agree only by accident.
library;

import 'package:flutter/material.dart';
import 'package:idle_rpg/app/theme.dart';

/// Colour for a rarity rank. Rank rather than name, so a config that adds a
/// tier does not need a new case here.
Color rarityColour(int rank) => switch (rank) {
  >= 3 => GamePalette.emberBright,
  2 => const Color(0xFFB07BD8),
  1 => GamePalette.patina,
  _ => GamePalette.ash,
};

/// A stand-in for the art a slot will eventually have.
///
/// Keyed by kind rather than by item, so a config that adds a fifth sword does
/// not need a new icon. Unknown kinds fall back rather than crash: balance is
/// data, and data can name a kind this build has never heard of.
IconData itemKindIcon(String kind) => switch (kind) {
  'weapon' => Icons.hardware,
  'armour' => Icons.shield,
  'helm' => Icons.sports_motorsports,
  'gloves' => Icons.back_hand,
  'boots' => Icons.hiking,
  'pants' => Icons.airline_seat_legroom_normal,
  'necklace' => Icons.diamond,
  'ring' => Icons.circle_outlined,
  'wings' => Icons.flight,
  'skin' => Icons.person,
  'rune' => Icons.auto_awesome,
  'mount' => Icons.pets,
  _ => Icons.category,
};

/// "ember_brand" -> "Ember brand".
String shortName(String configId) {
  final words = configId.replaceAll('_', ' ');
  return words.substring(0, 1).toUpperCase() + words.substring(1);
}
