import 'dart:convert';

import 'package:game_core/game_core.dart';
import 'package:idle_rpg/data/save_database.dart';

/// A save read back from disk.
class SaveRecord {
  const SaveRecord({required this.state, required this.savedAtMs});

  final PlayerState state;
  final int savedAtMs;
}

/// Reads and writes the player's state locally.
///
/// A local save is a cache, never an authority: the server recomputes progress
/// from its own copy and overwrites this on sync (ADR-001). Losing it costs a
/// player nothing once they are online — but before M3 it is the only copy
/// there is, so it still has to survive being killed.
class SaveRepository {
  SaveRepository(this._db);

  final SaveDatabase _db;

  static const _slots = [0, 1];

  Future<void> initialise() => _db.ensureSchema();

  /// Writes [state] to whichever slot was not written last.
  ///
  /// Alternating slots is what makes this safe. Overwriting the single most
  /// recent save means a process killed halfway through leaves nothing to fall
  /// back to; writing to the older slot means the newer one stays intact until
  /// the transaction commits.
  Future<void> save(PlayerState state, {required int nowMs}) async {
    final latest = await _latestSlot();
    final target = latest == null ? _slots.first : _slots[1 - latest];

    await _db.transaction(() async {
      await _db.customStatement(
        'INSERT OR REPLACE INTO saves '
        '(slot, payload, schema_version, saved_at_ms) VALUES (?, ?, ?, ?)',
        [target, jsonEncode(state.toJson()), state.version, nowMs],
      );
    });
  }

  /// Returns the newest save that can actually be read.
  ///
  /// Tries the most recent slot first and falls back to the other one if it
  /// cannot be parsed. A save that is merely *present* is not a save — a
  /// truncated or half-migrated payload has to be survivable, or one bad write
  /// ends the player's game.
  Future<SaveRecord?> load() async {
    final rows = await _db
        .customSelect(
          'SELECT payload, saved_at_ms FROM saves ORDER BY saved_at_ms DESC',
        )
        .get();

    for (final row in rows) {
      final payload = row.read<String>('payload');
      try {
        final decoded = jsonDecode(payload);
        if (decoded is! Map<String, dynamic>) continue;
        return SaveRecord(
          state: PlayerState.fromJson(decoded),
          savedAtMs: row.read<int>('saved_at_ms'),
        );
      } on Object {
        // Damaged slot: try the older one rather than giving up.
        continue;
      }
    }

    return null;
  }

  /// Wipes both slots. Used by a deliberate reset, never by error handling.
  Future<void> clear() => _db.customStatement('DELETE FROM saves');

  Future<int?> _latestSlot() async {
    final rows = await _db
        .customSelect(
          'SELECT slot FROM saves ORDER BY saved_at_ms DESC LIMIT 1',
        )
        .get();

    return rows.isEmpty ? null : rows.first.read<int>('slot');
  }
}
