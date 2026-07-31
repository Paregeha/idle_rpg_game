import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot_config.freezed.dart';
part 'slot_config.g.dart';

/// One place on the character where an item can go.
///
/// [id] and [accepts] are separate because a character can have two slots that
/// take the same kind of item: `ring1` and `ring2` both accept a `ring`. With
/// a single field, a ring would be nailed to one of them and the second slot
/// could never be filled.
@freezed
abstract class SlotConfig with _$SlotConfig {
  const factory SlotConfig({
    /// Unique name of the slot, e.g. `ring2`.
    required String id,

    /// Item kind this slot takes. Empty means "the same as [id]", which is the
    /// common case and keeps the config short.
    @Default('') String accepts,

    /// Display order. Slots are shown low-to-high.
    @Default(0) int order,
  }) = _SlotConfig;

  const SlotConfig._();

  factory SlotConfig.fromJson(Map<String, dynamic> json) =>
      _$SlotConfigFromJson(json);

  /// Kind of item this slot actually takes.
  String get itemKind => accepts.isEmpty ? id : accepts;
}
