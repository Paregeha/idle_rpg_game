import 'package:drift/drift.dart';

/// The local save database.
///
/// Written against drift's runtime without code generation: `drift_dev` needs
/// analyzer 13, and `freezed` in `game_core` caps the shared workspace
/// resolution below 11 (ADR-004). The schema is small enough that raw SQL is
/// clearer than a generated layer anyway — one table, two rows.
class SaveDatabase extends GeneratedDatabase {
  SaveDatabase(super.executor);

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const [];

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => _createSchema(),
    onUpgrade: (m, from, to) async => _createSchema(),
  );

  Future<void> _createSchema() async {
    // Two slots, written alternately. A save never overwrites the row it might
    // have to fall back to, so a process killed mid-write leaves the previous
    // save intact and readable.
    await customStatement('''
      CREATE TABLE IF NOT EXISTS saves (
        slot INTEGER NOT NULL PRIMARY KEY,
        payload TEXT NOT NULL,
        schema_version INTEGER NOT NULL,
        saved_at_ms INTEGER NOT NULL
      )
    ''');
  }

  /// Ensures the schema exists even when the database file already existed at
  /// a version drift did not create.
  Future<void> ensureSchema() => _createSchema();
}
