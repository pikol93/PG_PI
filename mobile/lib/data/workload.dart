import 'package:pi_mobile/data/set_of_exercise.dart';
import 'package:pi_mobile/data/strength_exercise.dart';

class Workload {
  StrengthExercise exercise;
  List<SetOfExercise> sets;
  String description;

  Workload(this.exercise, this.sets, this.description);

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
