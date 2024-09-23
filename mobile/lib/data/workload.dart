import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pi_mobile/data/set_of_exercise.dart';
import 'package:pi_mobile/data/strength_exercise.dart';

part "workload.g.dart";
part "workload.freezed.dart";

@freezed
class Workload with _$Workload {
  const factory Workload({
    required StrengthExercise exercise,
    required List<SetOfExercise> sets,
    required String description,
  }) = _Workload;

  factory Workload.fromJson(Map<String, Object?> json) =>
      _$WorkloadFromJson(json);

  static double getAverageRPE(List<SetOfExercise> sets) {
    if (sets.isEmpty) {
      return 0;
    }
    int totalRPE = 0;

    for (var set in sets) {
      totalRPE += set.rpe;
    }

    return totalRPE / sets.length;
  }
}