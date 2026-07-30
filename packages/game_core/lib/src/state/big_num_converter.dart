import 'package:game_core/src/math/big_num.dart';
import 'package:json_annotation/json_annotation.dart';

/// Stores a [BigNum] as its string form rather than a JSON number.
///
/// A JSON number is a `double` on the way back in, which would cap saved
/// progress at `1e308` and quietly round everything below it. The string form
/// keeps the exponent an `int`, so a save round-trips at any magnitude.
class BigNumConverter implements JsonConverter<BigNum, String> {
  const BigNumConverter();

  @override
  BigNum fromJson(String json) => BigNum.parse(json);

  @override
  String toJson(BigNum object) => object.serialize();
}
