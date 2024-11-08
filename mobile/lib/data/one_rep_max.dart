import "package:freezed_annotation/freezed_annotation.dart";

part "one_rep_max.g.dart";
part "one_rep_max.freezed.dart";

@freezed
class OneRepMax with _$OneRepMax {
  const factory OneRepMax({
    required Map<String, double> oneRepMaxMap,
    required DateTime date,
  }) = _OneRepMax;

  factory OneRepMax.fromJson(Map<String, Object?> json) =>
      _$OneRepMaxFromJson(json);
}
