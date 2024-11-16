import "package:fpdart/fpdart.dart";
import "package:isar/isar.dart";

part "one_rep_max_history.g.dart";

@collection
class OneRepMaxHistory {
  Id? id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late int exerciseId;

  late List<OneRepMaxEntry> oneRepMaxHistory;

  OneRepMaxHistory();

  factory OneRepMaxHistory.emptyWithExerciseId(int exerciseId) =>
      OneRepMaxHistory()
        ..exerciseId = exerciseId
        ..oneRepMaxHistory = [];

  Option<double> findCurrentOneRepMax() => oneRepMaxHistory
      .maximumBy(Order.by((item) => item.dateTime, Order.orderDate))
      .map((item) => item.value);
}

@embedded
class OneRepMaxEntry {
  late double value;
  late DateTime dateTime;
}
