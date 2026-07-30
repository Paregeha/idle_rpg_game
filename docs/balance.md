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

Filled in as the config takes shape in T-015. The shape we start from:

- Upgrade cost: `base * growth^n`.
- Monster HP and rewards: per-zone curves keyed off player level.
- Offline: capped accrual, cap in config (starting at 8 hours), separate VIP
  multiplier.

## Invariants worth testing

- Progression is monotonic: no upgrade ever lowers the rate of progress.
- Each prestige cycle is strictly faster than the previous one (T-017).
- Time-to-next-upgrade never exceeds the session length we design for at any
  point on the curve.
