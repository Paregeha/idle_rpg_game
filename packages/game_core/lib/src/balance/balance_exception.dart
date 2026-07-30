/// Thrown when a balance config cannot be loaded.
///
/// Balance ships as data and can be updated without a client release (`T-035`),
/// which means a bad file can reach a running game. Failing loudly at load
/// time, naming the offending field, is far better than a silent default that
/// quietly changes the economy for everyone.
class BalanceConfigException implements Exception {
  const BalanceConfigException(this.message, {this.field});

  /// What is wrong, in terms a person editing the JSON can act on.
  final String message;

  /// Dotted path to the offending field, when one can be identified.
  final String? field;

  @override
  String toString() => field == null
      ? 'BalanceConfigException: $message'
      : 'BalanceConfigException at "$field": $message';
}
