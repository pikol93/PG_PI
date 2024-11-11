import "package:flutter/material.dart";

class CalendarIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const CalendarIcon({
    super.key,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: color),
        constraints: const BoxConstraints(
          minWidth: 16.0,
          minHeight: 16.0,
          maxWidth: 16.0,
          maxHeight: 16.0,
        ),
        child: Icon(
          icon,
          size: 16.0,
          color: Colors.white,
        ),
      );
}

class HeartReadingCalendarIcon extends StatelessWidget {
  const HeartReadingCalendarIcon({super.key});

  @override
  Widget build(BuildContext context) => const CalendarIcon(
        color: Colors.red,
        icon: Icons.favorite,
      );
}

class TrackCalendarIcon extends StatelessWidget {
  const TrackCalendarIcon({super.key});

  @override
  Widget build(BuildContext context) => const CalendarIcon(
        color: Colors.blue,
        icon: Icons.directions_run,
      );
}

class ExerciseCalendarIcon extends StatelessWidget {
  const ExerciseCalendarIcon({super.key});

  @override
  Widget build(BuildContext context) => const CalendarIcon(
        color: Colors.green,
        icon: Icons.fitness_center,
      );
}
