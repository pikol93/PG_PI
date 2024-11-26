import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";

class ExerciseIcon extends StatelessWidget {
  final double size;
  final double borderRadius;

  const ExerciseIcon({super.key, this.size = 32, this.borderRadius = 8});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: context.colors.scheme.secondaryContainer,
          ),
          child: Padding(
            padding: EdgeInsets.all(borderRadius),
            child: Icon(
              Icons.fitness_center,
              size: size,
            ),
          ),
        ),
      );
}
