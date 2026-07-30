import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/data/save_database.dart';
import 'package:idle_rpg/data/save_repository.dart';

/// How often the game writes itself to disk while being played.
///
/// Ten seconds is a deliberate trade: often enough that a crash costs a player
/// almost nothing, rare enough that the write does not compete with the 30 Hz
/// loop for the main thread.
const Duration autosaveInterval = Duration(seconds: 10);

/// Overridden in tests with an in-memory database.
final saveDatabaseProvider = Provider<SaveDatabase>((ref) {
  final db = SaveDatabase(driftDatabase(name: 'idle_rpg_save'));
  ref.onDispose(db.close);
  return db;
});

final saveRepositoryProvider = Provider<SaveRepository>((ref) {
  return SaveRepository(ref.watch(saveDatabaseProvider));
});
