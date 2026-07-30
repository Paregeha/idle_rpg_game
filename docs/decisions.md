# Architecture decisions

One entry per decision, two paragraphs: what we decided, and what it costs us.
Append only — when a decision is reversed, add a new entry that supersedes the
old one instead of editing history.

---

## ADR-001 · The server is the source of truth

The server stores every player's `PlayerState` together with `lastTickAtMs` and
recomputes progress by running the same `simulate()` the client runs. Clients
send *intents* (`buyUpgrade(id)`, `prestige()`, `attackBoss()`), never results.
An endpoint that accepts an outcome — `addGold(amount)` — is a bug, not a
shortcut. This is affordable precisely because of the genre: idle progress is a
pure function of state and elapsed time, so the server never needs a stream of
client events to know where a player should be.

The cost is that every gameplay feature has to be expressible as an intent plus
a deterministic transition, which rules out client-side surprises and makes some
UI-driven mechanics awkward. It also means the client's local simulation is
strictly cosmetic: on any divergence the server's answer replaces it, and the UI
must be able to absorb a state correction without looking broken.

## ADR-002 · `BigNum` instead of `double`

Game quantities use a mantissa/exponent pair rather than `double`. An idle game
crosses `double.maxFinite` within hours of active play, and long before that
`double` loses the integer precision that upgrade thresholds depend on. Every
arithmetic operation renormalizes, and the type carries its own comparison,
`log10`, `pow`, formatting and lossless string serialization.

The cost is that arithmetic is no longer free: allocations and normalization sit
in the hot loop of the simulation, and every formula in `game_core` must be
written against `BigNum` rather than plain numbers. Property tests guard the
laws we rely on, but note that floating-point mantissas make associativity hold
only up to a relative tolerance — the tests assert closeness, not equality.

## ADR-003 · Flame only for the battle scene

Flame renders the battle scene and nothing else. `GameWidget` is embedded inside
a regular Flutter screen, not the other way around. Menus, inventory, upgrade
lists, guild and leaderboard screens are ordinary Flutter widgets.

The cost is two rendering models in one app and a boundary to maintain between
them. We take that over the alternative: Flame's component tree has no answer
for scrollable lists, text input, accessibility or platform look-and-feel, and
rebuilding those inside a game engine would be a permanent tax on every screen
that is not a fight.

## ADR-004 · melos on top of Dart pub workspaces

melos 7 dropped `melos.yaml` and rebuilt itself on the native `workspace:` field
that Dart gained in 3.6. Configuration therefore lives in the root
`pubspec.yaml` under the `melos` key, every member declares
`resolution: workspace`, and a single resolution covers all packages. We keep
melos on top of the native mechanism for what pub does not do: named scripts and
package filters, which is what `melos run test:core` needs.

The cost is that one shared resolution means the Flutter SDK's pins bind
*every* package, including the pure-Dart ones. `flutter_test` pins `meta` and
`test_api`, so `game_core` cannot independently move to a newer `test` — its
constraints must stay loose enough to co-resolve with the client. This surfaced
immediately during T-001 and will surface again on every Flutter upgrade.

Scripts that invoke melos recursively call it as `dart run melos`, never as a
bare `melos`. A melos script runs in a shell that does not inherit a global pub
binary, so `melos exec` inside a script only resolves on a machine where melos
happens to be activated globally — green locally, `melos: not found` in CI. The
`dart run` form uses the workspace's own dev dependency, which also pins the
version to `pubspec.lock` instead of whatever the machine has.

## ADR-006 · Our own PRNG instead of `dart:math`'s `Random`

`Random(seed)` does not promise the same sequence across the Dart VM and a
JavaScript runtime. Client and server drawing different numbers from the same
state is precisely the divergence rule 5 exists to prevent, so `SeededRandom`
implements xorshift128 itself. That algorithm is the right shape for the
promise: only shifts and XOR, no multiplication — a 32×32 multiply would
overflow JavaScript's 53-bit integer precision and quietly differ. Every
intermediate is forced back through `toUnsigned(32)`, which behaves identically
on both platforms. CI runs the core test suite compiled to JavaScript so the
claim is checked rather than assumed.

The cost is a generator we own and must not casually change: saved games carry
an RNG state, so altering the step function would desynchronise every existing
save from the server. A golden-sequence test makes any such change loud. The
generator is also not cryptographically secure, which is acceptable only
because the server recomputes every outcome — predicting a roll gains a player
nothing.

## ADR-005 · Serverpod integration tests are opt-in locally

`melos run test` covers the pure-Dart packages and the Flutter client only. The
Serverpod integration tests need a live Postgres and live under
`melos run test:server`, which assumes `docker compose up` has been run first.
CI runs them in a dedicated job against an ephemeral Postgres service.

The cost is that the default local test command does not prove the server works;
a developer without Docker running will get a green `melos run test` while the
server is untested. CI is the backstop, and the split keeps the inner loop fast
enough that the tests actually get run.
