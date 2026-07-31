// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salvage_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalvageConfig _$SalvageConfigFromJson(Map<String, dynamic> json) =>
    _SalvageConfig(
      yields:
          (json['yields'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              (e as Map<String, dynamic>).map(
                (k, e) =>
                    MapEntry(k, const BigNumConverter().fromJson(e as String)),
              ),
            ),
          ) ??
          const <String, Map<String, BigNum>>{},
      levelMultiplier: (json['levelMultiplier'] as num?)?.toDouble() ?? 1.5,
    );

Map<String, dynamic> _$SalvageConfigToJson(_SalvageConfig instance) =>
    <String, dynamic>{
      'yields': instance.yields.map(
        (k, e) => MapEntry(
          k,
          e.map((k, e) => MapEntry(k, const BigNumConverter().toJson(e))),
        ),
      ),
      'levelMultiplier': instance.levelMultiplier,
    };
