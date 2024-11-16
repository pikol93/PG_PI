import "package:pi_mobile/i18n/strings.g.dart" as i18n;

enum MuscleGroup {
  chest,
  frontDeltoid,
  triceps;

  i18n.MuscleGroup toTranslationVariant() {
    switch (this) {
      case MuscleGroup.chest:
        return i18n.MuscleGroup.chest;
      case MuscleGroup.frontDeltoid:
        return i18n.MuscleGroup.frontDeltoid;
      case MuscleGroup.triceps:
        return i18n.MuscleGroup.triceps;
    }
  }
}
