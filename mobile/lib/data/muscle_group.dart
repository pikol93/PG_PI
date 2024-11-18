import "package:pi_mobile/i18n/strings.g.dart" as i18n;

enum MuscleGroup {
  chest,
  frontDeltoid,
  triceps,
  lats,
  abs,
  obliques,
  quads,
  adductors,
  glutes,
  lowerBack,
  calves,
  hamstrings,
  trapezius,
  forearmFlexors,
  lateralDeltoid,
  rearDeltoids,
  biceps,
  rotatorCuffs;

  i18n.MuscleGroup toTranslationVariant() {
    switch (this) {
      case MuscleGroup.chest:
        return i18n.MuscleGroup.chest;
      case MuscleGroup.frontDeltoid:
        return i18n.MuscleGroup.frontDeltoid;
      case MuscleGroup.triceps:
        return i18n.MuscleGroup.triceps;
      case MuscleGroup.lats:
        return i18n.MuscleGroup.lats;
      case MuscleGroup.abs:
        return i18n.MuscleGroup.abs;
      case MuscleGroup.obliques:
        return i18n.MuscleGroup.obliques;
      case MuscleGroup.quads:
        return i18n.MuscleGroup.quads;
      case MuscleGroup.adductors:
        return i18n.MuscleGroup.adductors;
      case MuscleGroup.glutes:
        return i18n.MuscleGroup.glutes;
      case MuscleGroup.lowerBack:
        return i18n.MuscleGroup.lowerBack;
      case MuscleGroup.calves:
        return i18n.MuscleGroup.calves;
      case MuscleGroup.hamstrings:
        return i18n.MuscleGroup.hamstrings;
      case MuscleGroup.trapezius:
        return i18n.MuscleGroup.trapezius;
      case MuscleGroup.forearmFlexors:
        return i18n.MuscleGroup.forearmFlexors;
      case MuscleGroup.lateralDeltoid:
        return i18n.MuscleGroup.lateralDeltoid;
      case MuscleGroup.rearDeltoids:
        return i18n.MuscleGroup.rearDeltoids;
      case MuscleGroup.biceps:
        return i18n.MuscleGroup.biceps;
      case MuscleGroup.rotatorCuffs:
        return i18n.MuscleGroup.rotatorCuffs;
    }
  }
}
