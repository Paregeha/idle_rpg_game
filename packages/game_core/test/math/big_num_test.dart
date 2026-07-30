import 'dart:math' as math;

import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Relative closeness, which is the only sane comparison for a floating-point
/// mantissa. See ADR-002.
Matcher closeToBigNum(BigNum expected, {double tolerance = 1e-9}) {
  return predicate<BigNum>((actual) {
    if (expected.isZero) return actual.isZero;
    final diff = (actual - expected).abs();
    final relative = (diff / expected.abs()).toDouble();
    return relative <= tolerance;
  }, 'within $tolerance relative error of ${expected.format()}');
}

void main() {
  group('construction and normalization', () {
    test('normalizes the mantissa into [1, 10)', () {
      final n = BigNum(1234.5, 2);

      expect(n.mantissa, closeTo(1.2345, 1e-12));
      expect(n.exponent, 5);
    });

    test('normalizes a mantissa below one', () {
      final n = BigNum(0.0001234, 10);

      expect(n.mantissa, closeTo(1.234, 1e-12));
      expect(n.exponent, 6);
    });

    test('keeps an already normalized value untouched', () {
      final n = BigNum(5.5, 3);

      expect(n.mantissa, closeTo(5.5, 1e-12));
      expect(n.exponent, 3);
    });

    test('zero has a canonical representation', () {
      expect(BigNum(0, 42).isZero, isTrue);
      expect(BigNum(0, 42).exponent, 0);
      expect(BigNum(0, 42), BigNum.zero);
    });

    test('preserves sign while normalizing', () {
      final n = BigNum(-1234.5, 2);

      expect(n.mantissa, closeTo(-1.2345, 1e-12));
      expect(n.exponent, 5);
      expect(n.isNegative, isTrue);
    });

    test('builds from a plain double', () {
      expect(BigNum.fromDouble(1500).mantissa, closeTo(1.5, 1e-12));
      expect(BigNum.fromDouble(1500).exponent, 3);
      expect(BigNum.fromDouble(0).isZero, isTrue);
      expect(BigNum.fromDouble(-0.05).mantissa, closeTo(-5, 1e-12));
      expect(BigNum.fromDouble(-0.05).exponent, -2);
    });

    test('rejects a non-finite input', () {
      expect(() => BigNum.fromDouble(double.nan), throwsArgumentError);
      expect(() => BigNum.fromDouble(double.infinity), throwsArgumentError);
      expect(() => BigNum(double.nan, 0), throwsArgumentError);
    });
  });

  group('addition and subtraction', () {
    test('adds values of the same magnitude', () {
      expect(BigNum(1.5, 3) + BigNum(2.5, 3), closeToBigNum(BigNum(4, 3)));
    });

    test('adds across magnitudes', () {
      // 1e6 + 5e3 = 1005000
      expect(BigNum(1, 6) + BigNum(5, 3), closeToBigNum(BigNum(1.005, 6)));
    });

    test('adding zero is identity', () {
      final n = BigNum(7.25, 12);

      expect(n + BigNum.zero, closeToBigNum(n));
      expect(BigNum.zero + n, closeToBigNum(n));
    });

    test('a hopelessly smaller term vanishes instead of corrupting', () {
      // Beyond double's ~17 significant digits the small term cannot show up.
      final big = BigNum(1, 100);

      expect(big + BigNum(1, 10), closeToBigNum(big));
    });

    test('subtracts to zero exactly', () {
      expect((BigNum(3.5, 8) - BigNum(3.5, 8)).isZero, isTrue);
    });

    test('subtraction can cross into negative', () {
      expect(BigNum(1, 3) - BigNum(2, 3), closeToBigNum(BigNum(-1, 3)));
    });

    test('unary minus flips the sign', () {
      expect(-BigNum(2.5, 4), closeToBigNum(BigNum(-2.5, 4)));
      expect((-BigNum.zero).isZero, isTrue);
    });

    test('abs drops the sign', () {
      expect(BigNum(-2.5, 4).abs(), closeToBigNum(BigNum(2.5, 4)));
    });
  });

  group('multiplication and division', () {
    test('multiplies mantissas and adds exponents', () {
      expect(BigNum(2, 5) * BigNum(3, 7), closeToBigNum(BigNum(6, 12)));
    });

    test('renormalizes when the mantissa product overflows ten', () {
      // 5e3 * 4e3 = 2e7
      final n = BigNum(5, 3) * BigNum(4, 3);

      expect(n.mantissa, closeTo(2, 1e-12));
      expect(n.exponent, 7);
    });

    test('multiplying by zero is zero', () {
      expect((BigNum(3, 50) * BigNum.zero).isZero, isTrue);
    });

    test('divides mantissas and subtracts exponents', () {
      expect(BigNum(6, 12) / BigNum(3, 7), closeToBigNum(BigNum(2, 5)));
    });

    test('renormalizes when the mantissa quotient drops below one', () {
      // 2e7 / 4e3 = 5e3
      final n = BigNum(2, 7) / BigNum(4, 3);

      expect(n.mantissa, closeTo(5, 1e-12));
      expect(n.exponent, 3);
    });

    test('division by zero throws', () {
      expect(() => BigNum(1, 0) / BigNum.zero, throwsA(isA<ArgumentError>()));
    });

    test('survives magnitudes double cannot hold', () {
      // 1e200 * 1e200 = 1e400, far past double.maxFinite.
      final n = BigNum(1, 200) * BigNum(1, 200);

      expect(n.exponent, 400);
      expect(n.mantissa, closeTo(1, 1e-12));
    });
  });

  group('pow and log10', () {
    test('raises to an integer power', () {
      expect(BigNum(2, 0).pow(10), closeToBigNum(BigNum(1.024, 3)));
    });

    test('raises a large value to a power', () {
      // (1e10)^5 = 1e50
      expect(BigNum(1, 10).pow(5), closeToBigNum(BigNum(1, 50)));
    });

    test('supports fractional exponents', () {
      // sqrt(1e10) = 1e5
      expect(BigNum(1, 10).pow(0.5), closeToBigNum(BigNum(1, 5)));
    });

    test('anything to the zeroth power is one', () {
      expect(BigNum(7, 33).pow(0), closeToBigNum(BigNum.one));
    });

    test('log10 of a power of ten is its exponent', () {
      expect(BigNum(1, 42).log10(), closeTo(42, 1e-12));
    });

    test('log10 accounts for the mantissa', () {
      expect(BigNum(5, 3).log10(), closeTo(3 + math.log(5) / math.ln10, 1e-12));
    });

    test('log10 of zero or a negative throws', () {
      expect(BigNum.zero.log10, throwsA(isA<ArgumentError>()));
      expect(BigNum(-1, 5).log10, throwsA(isA<ArgumentError>()));
    });
  });

  group('comparison', () {
    test('orders by exponent first', () {
      expect(BigNum(1, 10) > BigNum(9, 9), isTrue);
      expect(BigNum(9, 9) < BigNum(1, 10), isTrue);
    });

    test('orders by mantissa within the same exponent', () {
      expect(BigNum(2, 5) > BigNum(1.9, 5), isTrue);
      expect(BigNum(2, 5) >= BigNum(2, 5), isTrue);
      expect(BigNum(2, 5) <= BigNum(2, 5), isTrue);
    });

    test('negatives order below positives and zero', () {
      expect(BigNum(-1, 50) < BigNum.zero, isTrue);
      expect(BigNum(-1, 50) < BigNum(1, 0), isTrue);
    });

    test('a more negative magnitude is smaller', () {
      expect(BigNum(-9, 9) < BigNum(-1, 9), isTrue);
      expect(BigNum(-1, 10) < BigNum(-9, 9), isTrue);
    });

    test('compareTo agrees with the operators', () {
      expect(BigNum(1, 3).compareTo(BigNum(1, 4)), isNegative);
      expect(BigNum(1, 4).compareTo(BigNum(1, 3)), isPositive);
      expect(BigNum(1, 3).compareTo(BigNum(1, 3)), isZero);
    });

    test('sorts a list correctly', () {
      final list = [BigNum(5, 2), BigNum(-1, 9), BigNum.zero, BigNum(1, 3)]
        ..sort();

      expect(list, [BigNum(-1, 9), BigNum.zero, BigNum(5, 2), BigNum(1, 3)]);
    });

    test('equality and hashCode agree', () {
      expect(BigNum(1.5, 3), BigNum(1500, 0));
      expect(BigNum(1.5, 3).hashCode, BigNum(1500, 0).hashCode);
      expect(BigNum(1.5, 3), isNot(BigNum(1.5, 4)));
    });
  });

  group('format', () {
    test('renders small numbers plainly', () {
      expect(BigNum.fromDouble(0).format(), '0');
      expect(BigNum.fromDouble(1).format(), '1');
      expect(BigNum.fromDouble(999).format(), '999');
    });

    test('uses suffixes by magnitude', () {
      expect(BigNum.fromDouble(1240).format(), '1.24K');
      expect(BigNum.fromDouble(3510000).format(), '3.51M');
      expect(BigNum.fromDouble(1000000000).format(), '1.00B');
      expect(BigNum.fromDouble(1000000000000).format(), '1.00T');
    });

    test('falls back to scientific notation past the suffix table', () {
      expect(BigNum(9.99, 42).format(), '9.99e42');
      expect(BigNum(1, 300).format(), '1.00e300');
    });

    test('keeps the sign', () {
      expect(BigNum.fromDouble(-1240).format(), '-1.24K');
      expect(BigNum(-9.99, 42).format(), '-9.99e42');
    });

    test('does not round up across a magnitude boundary', () {
      // 999_999 must not read as "1000.00K".
      expect(BigNum.fromDouble(999999).format(), isNot(startsWith('1000')));
    });
  });

  group('serialization', () {
    test('round-trips through a string', () {
      final values = [
        BigNum.zero,
        BigNum.one,
        BigNum(1.234567890123, 45),
        BigNum(-9.87654321, -30),
        BigNum(5, 0),
      ];

      for (final v in values) {
        expect(BigNum.parse(v.serialize()), closeToBigNum(v), reason: '$v');
      }
    });

    test('serialized form is stable and machine readable', () {
      expect(BigNum.zero.serialize(), '0');
      expect(BigNum(1.5, 3).serialize(), startsWith('1.5'));
      expect(BigNum.parse('1.5e3'), closeToBigNum(BigNum(1.5, 3)));
      expect(BigNum.parse('-2.5e-4'), closeToBigNum(BigNum(-2.5, -4)));
    });

    test('parses a plain number without an exponent', () {
      expect(BigNum.parse('1500'), closeToBigNum(BigNum(1.5, 3)));
    });

    test('rejects garbage with a readable error', () {
      expect(() => BigNum.parse('not a number'), throwsFormatException);
      expect(() => BigNum.parse(''), throwsFormatException);
    });

    test('survives a magnitude no double could round-trip', () {
      final huge = BigNum(1.23456789, 5000);

      expect(BigNum.parse(huge.serialize()), closeToBigNum(huge));
    });
  });

  group('properties over 10 000 random pairs', () {
    // Seeded: rule 5 in CLAUDE.md — a failure must be reproducible.
    final rng = math.Random(20260730);

    BigNum randomBigNum() => BigNum(
      (rng.nextDouble() * 18) - 9,
      rng.nextInt(400) - 200,
    );

    test('addition is associative within 1e-9 relative error', () {
      // Exact associativity cannot hold with a double mantissa — see ADR-002.
      for (var i = 0; i < 10000; i++) {
        final a = randomBigNum();
        final b = randomBigNum();
        final c = randomBigNum();

        final left = (a + b) + c;
        final right = a + (b + c);

        if (left.isZero || right.isZero) continue;
        final relative = ((left - right).abs() / left.abs()).toDouble();
        expect(
          relative,
          lessThanOrEqualTo(1e-9),
          reason: 'a=$a b=$b c=$c',
        );
      }
    });

    test('multiplication is commutative exactly', () {
      for (var i = 0; i < 10000; i++) {
        final a = randomBigNum();
        final b = randomBigNum();

        expect(a * b, b * a, reason: 'a=$a b=$b');
      }
    });

    test('addition is commutative exactly', () {
      for (var i = 0; i < 10000; i++) {
        final a = randomBigNum();
        final b = randomBigNum();

        expect(a + b, b + a, reason: 'a=$a b=$b');
      }
    });

    test('division inverts multiplication within 1e-9', () {
      for (var i = 0; i < 10000; i++) {
        final a = randomBigNum();
        final b = randomBigNum();
        if (b.isZero) continue;

        expect((a * b) / b, closeToBigNum(a), reason: 'a=$a b=$b');
      }
    });

    test('serialization round-trips within 1e-9', () {
      for (var i = 0; i < 10000; i++) {
        final a = randomBigNum();

        expect(BigNum.parse(a.serialize()), closeToBigNum(a), reason: '$a');
      }
    });
  });
}
