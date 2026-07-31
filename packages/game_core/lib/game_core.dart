/// The single source of truth for the rules of the game.
///
/// This library is pure Dart on purpose: the Serverpod backend re-runs the very
/// same simulation the client does, which is what lets the server recompute any
/// player's progress without trusting a stream of client events.
library;

export 'src/balance/balance_config.dart';
export 'src/balance/balance_exception.dart';
export 'src/balance/generator_config.dart';
export 'src/balance/hero_config.dart';
export 'src/balance/item_upgrade_config.dart';
export 'src/balance/lamp_config.dart';
export 'src/balance/monster_config.dart';
export 'src/balance/prestige_config.dart';
export 'src/balance/progression_config.dart';
export 'src/balance/skill_config.dart';
export 'src/balance/slot_config.dart';
export 'src/balance/start_config.dart';
export 'src/battle/battle_event.dart';
export 'src/battle/battle_resolver.dart';
export 'src/battle/battle_result.dart';
export 'src/battle/combat_stats.dart';
export 'src/items/drop.dart';
export 'src/items/equipment.dart';
export 'src/items/item_config.dart';
export 'src/items/item_upgrade.dart';
export 'src/items/lamp.dart';
export 'src/items/owned_item.dart';
export 'src/math/big_num.dart';
export 'src/random/seeded_random.dart';
export 'src/sim/hero_level.dart';
export 'src/sim/offline_progress.dart';
export 'src/sim/offline_report.dart';
export 'src/sim/prestige.dart';
export 'src/sim/progression.dart';
export 'src/sim/projection.dart';
export 'src/sim/purchase.dart';
export 'src/sim/sim_result.dart';
export 'src/sim/simulator.dart';
export 'src/skills/skill_pack.dart';
export 'src/skills/skills.dart';
export 'src/state/big_num_converter.dart';
export 'src/state/generator_state.dart';
export 'src/state/new_game.dart';
export 'src/state/player_state.dart';
export 'src/state/prestige_state.dart';
export 'src/time/clock.dart';
export 'src/time/system_clock.dart';
