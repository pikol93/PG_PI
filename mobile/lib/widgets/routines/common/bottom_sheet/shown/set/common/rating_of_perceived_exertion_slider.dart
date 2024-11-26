import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/data/rating_of_perceived_exertion.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/widgets/common/enum_slider.dart";

class RatingOfPerceivedExertionSlider extends StatefulWidget {
  final ValueNotifier<RatingOfPerceivedExertion> rpeNotifier;

  const RatingOfPerceivedExertionSlider({
    super.key,
    required this.rpeNotifier,
  });

  @override
  State<RatingOfPerceivedExertionSlider> createState() =>
      _RatingOfPerceivedExertionSliderState();
}

class _RatingOfPerceivedExertionSliderState
    extends State<RatingOfPerceivedExertionSlider> with Logger {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            "Rating of Perceived Exertion (RPE)", // TODO: I18N
            style: context.textStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            children: [
              EnumSlider<RatingOfPerceivedExertion>(
                values: RatingOfPerceivedExertion.values,
                initialValue: RatingOfPerceivedExertion.noRpe,
                onValueChanged: _onRpeChanged,
              ),
              Text(
                "RPE value (? RIR)",
                style: context.textStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      );

  void _onRpeChanged(RatingOfPerceivedExertion rpe) {
    logger.debug("RPE changed to $rpe");
    widget.rpeNotifier.value = rpe;
  }
}
