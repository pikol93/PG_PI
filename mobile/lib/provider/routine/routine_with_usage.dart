import "package:fpdart/fpdart.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/provider/routine/routine.dart";

part "routine_with_usage.freezed.dart";

@freezed
class RoutineWithUsage with _$RoutineWithUsage {
  const RoutineWithUsage._();

  const factory RoutineWithUsage({
    required Routine routine,
    required List<Usage> usages,
  }) = _RoutineWithUsage;

  Option<DateTime> getMostRecentDateTime() =>
      usages.map((item) => item.dateTime).maximumBy(Order.orderDate);
}

@freezed
class Usage with _$Usage {
  const factory Usage({
    required DateTime dateTime,
  }) = _Usage;
}
