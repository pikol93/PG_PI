import 'package:pi_mobile/classes/set_of_exercise.dart';
import 'package:pi_mobile/classes/strength_exercise.dart';

class Workload {
  StrengthExercise exercise;
  List<SetOfExercise> sets;
  String description;

  Workload(this.exercise, this.sets, this.description);

  static double getAverageRPE(List<SetOfExercise> sets){
    if (sets.isEmpty) {
      return 0;
    }
    int totalRPE = 0;

    sets.forEach((set) {
      totalRPE += set.rpe;
    });

    return totalRPE / sets.length;
  }
}
