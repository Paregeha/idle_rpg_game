// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BalanceConfig _$BalanceConfigFromJson(Map<String, dynamic> json) =>
    _BalanceConfig(
      generators:
          (json['generators'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              GeneratorConfig.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const <String, GeneratorConfig>{},
    );

Map<String, dynamic> _$BalanceConfigToJson(_BalanceConfig instance) =>
    <String, dynamic>{
      'generators': instance.generators.map((k, e) => MapEntry(k, e.toJson())),
    };
