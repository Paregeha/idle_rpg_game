# Idle RPG

A mobile idle RPG in Flutter with an online layer: leaderboards, guilds and a
shared raid boss.

The defining property of the genre is that progress is a pure function of state
and elapsed time. That is what lets the server recompute any player's progress
on its own, without trusting a stream of events from the client — and it is the
assumption the whole architecture leans on.

## Layout

```
packages/game_core   Pure Dart. Formulas, simulate(), balance, BigNum. No Flutter.
apps/client          Flutter app.
apps/server          Serverpod backend.
apps/server_client   Generated Serverpod client — do not edit by hand.
tools/balance        CLI balance simulators.
tools/ci             Checks that guard architectural rules in CI.
```

`game_core` is shared by the client and the server, and is the single source of
truth for the rules of the game.

## Getting started

Requires the Flutter SDK (3.41.5 or newer) and, for the server, Docker.

```bash
flutter pub get              # resolves the whole workspace
dart run melos run test
```

melos comes from the workspace's own dev dependency, so no global install is
needed — and the version is the one in `pubspec.lock` rather than whatever is on
the machine. Installing it globally (`dart pub global activate melos`) is a
convenience that lets you type `melos …` instead of `dart run melos …`; the
commands below work either way.

## Commands

Prefix each with `dart run` if melos is not installed globally.

| Command | What it does |
|---|---|
| `melos bootstrap` | Resolve the workspace |
| `melos run analyze` | Static analysis across all packages |
| `melos run format` | Check formatting (`format:fix` writes) |
| `melos run test` | Pure-Dart packages + Flutter client |
| `melos run test:core` | `game_core` only |
| `melos run test:server` | Serverpod integration tests — needs Postgres up |
| `melos run check:core-deps` | Fail if `game_core` gains Flutter or Flame |

The server tests expect the database to be running:

```bash
cd apps/server && docker compose up --detach
```

## Documentation

- [`CLAUDE.md`](CLAUDE.md) — working agreements and the hard rules.
- [`TASKS.md`](TASKS.md) — the backlog. One task, one branch, one PR.
- [`docs/decisions.md`](docs/decisions.md) — architecture decisions and what
  each one costs.
- [`docs/balance.md`](docs/balance.md) — how balance is authored and tuned.
