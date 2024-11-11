import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/widgets/calendar/calendar.dart";
import "package:pi_mobile/widgets/calendar/calendar_day_details.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AppNavigationDrawer(),
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: const Text("Calendar"), // TODO: I18N
        ),
        body: const Center(
          child: Column(
            children: [
              Calendar(),
              Divider(),
              CalendarDayDetails(),
            ],
          ),
        ),
      );
}
