// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestige_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrestigeState _$PrestigeStateFromJson(Map<String, dynamic> json) =>
    _PrestigeState(
      currency: json['currency'] == null
          ? BigNum.zero
          : const BigNumConverter().fromJson(json['currency'] as String),
      resets: (json['resets'] as num?)?.toInt() ?? 0,
      permanentUpgrades:
          (json['permanentUpgrades'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
    );

Map<String, dynamic> _$PrestigeStateToJson(_PrestigeState instance) =>
    <String, dynamic>{
      'currency': const BigNumConverter().toJson(instance.currency),
      'resets': instance.resets,
      'permanentUpgrades': instance.permanentUpgrades,
    };
