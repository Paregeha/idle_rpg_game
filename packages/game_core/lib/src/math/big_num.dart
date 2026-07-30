import 'dart:math' as math;

import 'package:meta/meta.dart';

/// A number held as `mantissa * 10^exponent`.
///
/// Idle games leave `double` behind within hours of play: past `1e308` every
/// value collapses to infinity, and long before that the integer precision that
/// upgrade thresholds rely on is gone. Splitting the magnitude into its own
/// integer exponent removes that ceiling — only the *precision* stays bounded
/// by the double mantissa, which is roughly 15 significant digits and is more
/// than a player can perceive.
///
/// The mantissa is always normalized to `1 <= |mantissa| < 10`, except for zero
/// which is canonically `mantissa == 0, exponent == 0`. Every operation
/// renormalizes, so two values that are mathematically equal have identical
/// fields and compare equal.
///
/// See ADR-002 in `docs/decisions.md`.
@immutable
class BigNum implements Comparable<BigNum> {
  /// Creates a value equal to `mantissa * 10^exponent`, normalizing it.
  ///
  /// [mantissa] may be given at any scale — `BigNum(1234.5, 2)` and
  /// `BigNum(1.2345, 5)` are the same value.
  factory BigNum(double mantissa, int exponent) {
    if (!mantissa.isFinite) {
      throw ArgumentError.value(mantissa, 'mantissa', 'must be finite');
    }
    if (mantissa == 0) return zero;

    var m = mantissa;
    var e = exponent;

    // One log gets us to the right order; the loops then fix the off-by-one
    // that floating-point rounding leaves behind near powers of ten.
    final magnitude = (math.log(m.abs()) / math.ln10).floor();
    if (magnitude != 0) {
      m /= math.pow(10, magnitude);
      e += magnitude;
    }
    while (m.abs() >= 10) {
      m /= 10;
      e++;
    }
    while (m.abs() < 1) {
      m *= 10;
      e--;
    }

    return BigNum._raw(m, e);
  }

  /// Creates a value from a plain [double].
  factory BigNum.fromDouble(double value) => BigNum(value, 0);

  /// Parses the output of [serialize].
  ///
  /// Accepts both `1.5e3` and a plain `1500`. The exponent is parsed as an
  /// `int`, so magnitudes far beyond `double` round-trip losslessly.
  factory BigNum.parse(String source) {
    final text = source.trim();
    if (text.isEmpty) {
      throw const FormatException('empty string is not a BigNum');
    }
    if (text == '0') return zero;

    final split = text.indexOf(RegExp('[eE]'));
    if (split == -1) {
      final value = double.tryParse(text);
      if (value == null) {
        throw FormatException('not a BigNum', source);
      }
      return BigNum.fromDouble(value);
    }

    final mantissa = double.tryParse(text.substring(0, split));
    final exponent = int.tryParse(text.substring(split + 1));
    if (mantissa == null || exponent == null) {
      throw FormatException('not a BigNum', source);
    }
    return BigNum(mantissa, exponent);
  }

  const BigNum._raw(this.mantissa, this.exponent);

  /// Normalized to `1 <= |mantissa| < 10`, or exactly `0`.
  final double mantissa;

  /// Power of ten the [mantissa] is scaled by.
  final int exponent;

  /// The additive identity.
  static const BigNum zero = BigNum._raw(0, 0);

  /// The multiplicative identity.
  static const BigNum one = BigNum._raw(1, 0);

  /// Beyond this difference in exponent the smaller term cannot affect the
  /// larger one: the double mantissa simply has no digits left to hold it.
  static const int _significantDigits = 17;

  bool get isZero => mantissa == 0;

  bool get isNegative => mantissa < 0;

  BigNum operator +(BigNum other) {
    if (isZero) return other;
    if (other.isZero) return this;

    final diff = exponent - other.exponent;
    if (diff > _significantDigits) return this;
    if (diff < -_significantDigits) return other;

    // Scale the smaller term down to the larger one's exponent. Both branches
    // sum the same two doubles, which keeps addition exactly commutative.
    if (diff >= 0) {
      return BigNum(mantissa + other.mantissa / math.pow(10, diff), exponent);
    }
    return BigNum(
      mantissa / math.pow(10, -diff) + other.mantissa,
      other.exponent,
    );
  }

  BigNum operator -(BigNum other) => this + (-other);

  BigNum operator *(BigNum other) {
    if (isZero || other.isZero) return zero;
    return BigNum(mantissa * other.mantissa, exponent + other.exponent);
  }

  BigNum operator /(BigNum other) {
    if (other.isZero) {
      throw ArgumentError.value(other, 'other', 'division by zero');
    }
    if (isZero) return zero;
    return BigNum(mantissa / other.mantissa, exponent - other.exponent);
  }

  BigNum operator -() => isZero ? zero : BigNum._raw(-mantissa, exponent);

  BigNum abs() => isNegative ? -this : this;

  bool operator <(BigNum other) => compareTo(other) < 0;

  bool operator <=(BigNum other) => compareTo(other) <= 0;

  bool operator >(BigNum other) => compareTo(other) > 0;

  bool operator >=(BigNum other) => compareTo(other) >= 0;

  /// Raises this value to [exponent_].
  ///
  /// Whole exponents go through exponentiation by squaring, which is exact:
  /// `BigNum(2, 0).pow(3)` is `8`, not `8.000000000000002`. That matters more
  /// than it looks — generator levels are whole numbers, so this path runs on
  /// every production calculation, and a logarithmic detour would leave a
  /// client and the server holding values that compare unequal.
  ///
  /// Other exponents use `(m * 10^e)^p = 10^(p * log10(m * 10^e))`, which keeps
  /// fractional powers working and never overflows, since the resulting order
  /// of magnitude stays an `int`.
  ///
  /// Throws [ArgumentError] for a negative base, where a fractional power has
  /// no real answer.
  BigNum pow(num exponent_) {
    if (exponent_ == 0) return one;
    if (isZero) return zero;
    if (isNegative) {
      throw ArgumentError.value(this, 'this', 'pow of a negative base');
    }

    if (exponent_ > 0 &&
        exponent_ <= _maxExactPower &&
        exponent_ == exponent_.roundToDouble()) {
      return _wholePow(exponent_.round());
    }

    final scaledLog = log10() * exponent_;
    final wholePart = scaledLog.floor();
    final fraction = scaledLog - wholePart;
    return BigNum(math.pow(10, fraction).toDouble(), wholePart);
  }

  /// Above this the squaring loop stops being worth it and precision of the
  /// logarithm is no longer the limiting factor anyway.
  static const int _maxExactPower = 4096;

  BigNum _wholePow(int exponent_) {
    var result = one;
    var base = this;
    var remaining = exponent_;

    while (remaining > 0) {
      if (remaining.isOdd) result *= base;
      remaining >>= 1;
      if (remaining > 0) base *= base;
    }

    return result;
  }

  /// Base-10 logarithm: `exponent + log10(mantissa)`.
  ///
  /// Throws [ArgumentError] for zero or a negative value.
  double log10() {
    if (isZero || isNegative) {
      throw ArgumentError.value(this, 'this', 'log10 needs a positive value');
    }
    return exponent + math.log(mantissa) / math.ln10;
  }

  /// Collapses to a [double], which overflows to infinity past `1e308`.
  ///
  /// Only for interop with code that cannot take a [BigNum] — never for game
  /// logic.
  double toDouble() => mantissa * math.pow(10, exponent);

  @override
  int compareTo(BigNum other) {
    if (isZero && other.isZero) return 0;
    if (isNegative != other.isNegative) return isNegative ? -1 : 1;
    if (isZero) return other.isNegative ? 1 : -1;
    if (other.isZero) return isNegative ? -1 : 1;

    // Same sign: a larger exponent means a larger magnitude, which for two
    // negatives means a *smaller* value.
    final sign = isNegative ? -1 : 1;
    if (exponent != other.exponent) {
      return exponent > other.exponent ? sign : -sign;
    }
    return mantissa.compareTo(other.mantissa);
  }

  /// Player-facing rendering: `1.24K`, `3.51M`, `9.99e42`.
  ///
  /// Values are truncated rather than rounded, so a number just short of the
  /// next magnitude never renders as `1000.00K`.
  String format() {
    if (isZero) return '0';

    final sign = isNegative ? '-' : '';
    final magnitude = mantissa.abs();

    if (exponent < 3) {
      final value = magnitude * math.pow(10, exponent);
      final rounded = value.roundToDouble();
      if ((value - rounded).abs() < 1e-9 * math.max(value, 1)) {
        return '$sign${rounded.toStringAsFixed(0)}';
      }
      return '$sign${_truncate2(value)}';
    }

    final tier = exponent ~/ 3;
    if (tier < _suffixes.length) {
      final scaled = magnitude * math.pow(10, exponent - tier * 3);
      return '$sign${_truncate2(scaled)}${_suffixes[tier]}';
    }

    return '$sign${_truncate2(magnitude)}e$exponent';
  }

  /// Lossless round-trip form, read back by [BigNum.parse].
  ///
  /// The mantissa uses Dart's shortest representation that parses back to the
  /// same double, and the exponent stays an `int`, so no magnitude is lost.
  String serialize() => isZero ? '0' : '${mantissa}e$exponent';

  @override
  String toString() => format();

  @override
  bool operator ==(Object other) =>
      other is BigNum &&
      mantissa == other.mantissa &&
      exponent == other.exponent;

  @override
  int get hashCode => Object.hash(mantissa, exponent);

  static const List<String> _suffixes = [
    '',
    'K',
    'M',
    'B',
    'T',
    'Qa',
    'Qi',
    'Sx',
    'Sp',
    'Oc',
    'No',
    'Dc',
  ];

  /// Two decimals, truncated. The epsilon absorbs the representation error of
  /// values like `1.24`, which would otherwise truncate down to `1.23`.
  static String _truncate2(double value) {
    final truncated = (value * 100 + 1e-9).truncateToDouble() / 100;
    return truncated.toStringAsFixed(2);
  }
}
