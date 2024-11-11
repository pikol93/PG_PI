import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/date_formatter_provider.dart";
import "package:pi_mobile/utility/datetime.dart";
import "package:pi_mobile/widgets/calendar/calendar_data.dart";
import "package:pi_mobile/widgets/calendar/calendar_icon.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:table_calendar/table_calendar.dart";

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> with Logger {
  static const Map<CalendarFormat, String> _availableCalendarFormats = {
    CalendarFormat.month: "",
  };

  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = context.textStyles.labelLarge;
    final locale = ref.watch(currentLocaleProvider).languageCode;
    return ref.watch(calendarDataProvider).when(
          data: (data) {
            final firstDay = data.getMinDate() ??
                DateTime.now().subtract(const Duration(days: 30));
            final lastDay = DateTime.now();

            return Scaffold(
              drawer: const AppNavigationDrawer(),
              appBar: AppBar(
                backgroundColor: context.colors.scaffoldBackground,
                title: const Text("Calendar"), // TODO: I18N
              ),
              body: Center(
                child: Column(
                  children: [
                    TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: firstDay,
                      lastDay: lastDay,
                      locale: locale,
                      calendarFormat: CalendarFormat.month,
                      availableCalendarFormats: _availableCalendarFormats,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: _onDaySelected,
                      selectedDayPredicate: _selectedDayPredicate,
                      onPageChanged: _onPageChanged,
                      calendarBuilders: CalendarBuilders(
                        prioritizedBuilder: (context, day, focusedDay) =>
                            _prioritizedBuilder(
                          context,
                          day,
                          focusedDay,
                          data,
                          defaultTextStyle,
                          firstDay,
                          lastDay,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text("Error: $error"),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }

  bool _selectedDayPredicate(DateTime day) => isSameDay(day, _focusedDay);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    logger.debug("On day selected: $selectedDay, $focusedDay");
    setState(() {
      _focusedDay = selectedDay;
    });
  }

  Widget? _prioritizedBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
    CalendarData calendarData,
    TextStyle defaultTextStyle,
    DateTime firstDay,
    DateTime lastDay,
  ) {
    final calendarIcons = <Widget>[];

    if (calendarData.hasAnyHeartRateEntryOn(day)) {
      calendarIcons.add(const HeartReadingCalendarIcon());
    }

    if (calendarData.hasAnyTracksOn(day)) {
      calendarIcons.add(const TrackCalendarIcon());
    }

    if (calendarData.hasAnyExercisesOn(day)) {
      calendarIcons.add(const ExerciseCalendarIcon());
    }

    DayType dayType;
    if (!day.isSameYearAndMonth(_focusedDay) ||
        day.isDayBefore(firstDay) ||
        day.isDayAfter(lastDay)) {
      dayType = DayType.inactive;
    } else if (isSameDay(day, _focusedDay)) {
      dayType = DayType.selected;
    } else {
      dayType = DayType.normal;
    }

    return _CalendarDay(
      defaultTextStyle: defaultTextStyle,
      dateTime: day,
      dayType: dayType,
      calendarIcons: calendarIcons,
    );
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }
}

enum DayType {
  normal,
  selected,
  inactive,
}

class _CalendarDay extends StatelessWidget {
  final TextStyle defaultTextStyle;
  final DateTime dateTime;
  final DayType dayType;
  final List<Widget> calendarIcons;

  const _CalendarDay({
    required this.defaultTextStyle,
    required this.dateTime,
    required this.dayType,
    required this.calendarIcons,
  });

  @override
  Widget build(BuildContext context) {
    if (calendarIcons.isEmpty) {
      return _StacklessCalendarDay(
        defaultTextStyle: defaultTextStyle,
        dateTime: dateTime,
        dayType: dayType,
      );
    } else {
      return _StackCalendarDay(
        defaultTextStyle: defaultTextStyle,
        dateTime: dateTime,
        dayType: dayType,
        calendarIcons: calendarIcons,
      );
    }
  }
}

class _StacklessCalendarDay extends StatelessWidget {
  final TextStyle defaultTextStyle;
  final DateTime dateTime;
  final DayType dayType;

  const _StacklessCalendarDay({
    required this.defaultTextStyle,
    required this.dateTime,
    required this.dayType,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: _createWidget(context, dayType, "${dateTime.day}"),
      );

  Widget _createWidget(
    BuildContext context,
    DayType dayType,
    String text,
  ) {
    switch (dayType) {
      case DayType.normal:
        return Text(
          text,
          style: defaultTextStyle,
        );
      case DayType.selected:
        return Container(
          width: 32.0,
          height: 32.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Center(
            child: Text(
              text,
              style: defaultTextStyle,
            ),
          ),
        );
      case DayType.inactive:
        return Text(
          text,
          style: defaultTextStyle.copyWith(color: Colors.grey),
        );
    }
  }
}

class _StackCalendarDay extends StatelessWidget {
  final TextStyle defaultTextStyle;
  final DateTime dateTime;
  final DayType dayType;
  final List<Widget> calendarIcons;

  const _StackCalendarDay({
    required this.defaultTextStyle,
    required this.dateTime,
    required this.dayType,
    required this.calendarIcons,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          _StacklessCalendarDay(
            defaultTextStyle: defaultTextStyle,
            dateTime: dateTime,
            dayType: dayType,
          ),
          Column(
            children: [
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Wrap(
                    textDirection: TextDirection.rtl,
                    alignment: WrapAlignment.end,
                    verticalDirection: VerticalDirection.up,
                    children: calendarIcons,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
