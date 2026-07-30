# Balance

Balance lives in data, never in code: `packages/game_core/assets/balance/v*.json`,
versioned and validated on load. If a number that a player can feel appears in
`simulator.dart`, that is a bug.

## Why data

Two reasons. The server serves the config version to the client (T-035), so a
balance change ships without a store release. And the CLI simulator
(`tools/balance`, T-018) can sweep a config across player profiles without
launching the game — which is the only practical way to find out that the curve
falls apart on day 14.

## Working on balance

1. Edit the JSON, bump its version.
2. `dart run simulate --days 30 --profile casual` (also `active`, `whale`).
3. Compare the CSV against the previous run before committing.

The simulator is the review tool: a diff of two CSVs says more about a balance
change than the diff of the config does.

## Curves

All of these live in `assets/balance/v1.json` and are validated on load.

| Quantity | Formula | Config fields |
|---|---|---|
| Generator output | `baseRatePerSecond * owned * levelMultiplier^level` | `generators.*` |
| Generator price | `costBase * costGrowth^owned` | `costBase`, `costGrowth` |
| Bulk price | geometric series over the above | — |
| Monster health | `baseHp * hpGrowth^level` | `monsters.*` |
| Kill reward | `rewardBase * rewardGrowth^level` | `monsters.*` |
| Offline payout | `min(away, offlineCapMs * vipMultiplier)` | `offlineCapMs` |

The pacing of the genre comes from one gap: output grows *linearly* with how
many units you own, while price grows *exponentially*. Everything else is
decoration on top of that.

A second, smaller gap does the same job for combat: `hpGrowth` is set above
`rewardGrowth` in every monster, so pushing into a deeper zone is a decision
with a cost rather than a free upgrade. A test asserts this holds for the
shipped file, because it is the kind of invariant that a well-meaning tuning
pass silently breaks.

## Validation

The config is validated when it is parsed, not when a value is first read.
Balance can be updated without a client release (T-035), so a broken file can
reach a running game — failing loudly at load, naming the field, beats a silent
default that quietly changes the economy for everyone.

Rejected outright: a missing or future `version`, a non-positive cap, a
generator that produces nothing or produces at a negative rate, `costGrowth`
at or below 1 (units would never get more expensive and progression would
disappear), `hpGrowth` or `rewardGrowth` at or below 1, and a `dropChance`
outside 0..1.

## What the first run says (v1, 30 days)

| profile | day 1 | day 7 | day 14 | day 30 |
|---|---|---|---|---|
| casual | 187 | 728 | 779 | 827 |
| active | 544 | 760 | 802 | 846 |
| whale | 602 | 765 | 806 | 849 |

Units owned. Two problems are visible immediately, and neither would have been
obvious from reading the config:

**The curve saturates within a week.** A casual player reaches 728 units on day
7 and gains only ~100 more over the next three weeks. Whatever the game is
after day 7, it is not this loop.

**Playing more barely matters.** By day 30 the gap between a casual and a whale
is under 3%. Six times the sessions buys almost nothing, which removes the
reason to open the game.

Both point the same way: `costGrowth` (1.07–1.12) is too shallow against
production that scales linearly with units, so everything affordable gets bought
almost at once and the wall arrives together. Fixing it is a design decision —
steeper cost growth, generator levels that matter more, or content beyond
generators — not a code change.

## Invariants worth testing

- Progression is monotonic: no upgrade ever lowers the rate of progress.
- Each prestige cycle is strictly faster than the previous one (T-017).
- Time-to-next-upgrade never exceeds the session length we design for at any
  point on the curve.
