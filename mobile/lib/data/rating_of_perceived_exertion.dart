import "package:fpdart/fpdart.dart";
import "package:pi_mobile/i18n/strings.g.dart";

enum RatingOfPerceivedExertion {
  noRpe,
  rpe6,
  rpe6AndAHalf,
  rpe7,
  rpe7AndAHalf,
  rpe8,
  rpe8AndAHalf,
  rpe9,
  rpe9AndAHalf,
  rpe10
}

extension RatingOfPerceivedExertionExtension on RatingOfPerceivedExertion {
  Option<double> toDouble() => switch (this) {
        RatingOfPerceivedExertion.noRpe => const Option.none(),
        RatingOfPerceivedExertion.rpe6 => const Option.of(6),
        RatingOfPerceivedExertion.rpe6AndAHalf => const Option.of(6.5),
        RatingOfPerceivedExertion.rpe7 => const Option.of(7),
        RatingOfPerceivedExertion.rpe7AndAHalf => const Option.of(7.5),
        RatingOfPerceivedExertion.rpe8 => const Option.of(8),
        RatingOfPerceivedExertion.rpe8AndAHalf => const Option.of(8.5),
        RatingOfPerceivedExertion.rpe9 => const Option.of(9),
        RatingOfPerceivedExertion.rpe9AndAHalf => const Option.of(9.5),
        RatingOfPerceivedExertion.rpe10 => const Option.of(10),
      };

  RatingOfPerceivedExertionI18N toI18N() => switch (this) {
        RatingOfPerceivedExertion.noRpe => RatingOfPerceivedExertionI18N.noRpe,
        RatingOfPerceivedExertion.rpe6 => RatingOfPerceivedExertionI18N.rpe6,
        RatingOfPerceivedExertion.rpe6AndAHalf =>
          RatingOfPerceivedExertionI18N.rpe6AndAHalf,
        RatingOfPerceivedExertion.rpe7 => RatingOfPerceivedExertionI18N.rpe7,
        RatingOfPerceivedExertion.rpe7AndAHalf =>
          RatingOfPerceivedExertionI18N.rpe7AndAHalf,
        RatingOfPerceivedExertion.rpe8 => RatingOfPerceivedExertionI18N.rpe8,
        RatingOfPerceivedExertion.rpe8AndAHalf =>
          RatingOfPerceivedExertionI18N.rpe8AndAHalf,
        RatingOfPerceivedExertion.rpe9 => RatingOfPerceivedExertionI18N.rpe9,
        RatingOfPerceivedExertion.rpe9AndAHalf =>
          RatingOfPerceivedExertionI18N.rpe9AndAHalf,
        RatingOfPerceivedExertion.rpe10 => RatingOfPerceivedExertionI18N.rpe10,
      };
}
