import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/preferences/date_formatter_provider.dart";
import "package:pi_mobile/utility/datetime.dart";
import "package:pi_mobile/widgets/calendar/calendar_data.dart";
import "package:pi_mobile/widgets/calendar/calendar_icon.dart";
import "package:table_calendar/table_calendar.dart";

enum DayType {
  normal,
  selected,
  inactive,
}

class Calendar extends ConsumerWidget with Logger {
  static const Map<CalendarFormat, String> _availableCalendarFormats = {
    CalendarFormat.month: "",
  };

  const Calendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultTextStyle = context.textStyles.labelLarge;
    final locale = ref.watch(currentLocaleProvider).languageCode;
    final focusedDay = ref.watch(focusedDayProvider);

    return ref.watch(calendarDataProvider).when(
          data: (data) {
            final firstDay = data.getMinDate() ??
                DateTime.now().subtract(const Duration(days: 30));
            final lastDay = DateTime.now();

            return TableCalendar(
              focusedDay: focusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              locale: locale,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: _availableCalendarFormats,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (selectedDay, focusedDay) =>
                  _onDaySelected(selectedDay, focusedDay, ref),
              onPageChanged: (focusedDay) => _onPageChanged(focusedDay, ref),
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
    if (!day.isSameYearAndMonth(focusedDay) ||
        day.isDayBefore(firstDay) ||
        day.isDayAfter(lastDay)) {
      dayType = DayType.inactive;
    } else if (isSameDay(day, focusedDay)) {
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

  void _onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
    WidgetRef ref,
  ) {
    logger.debug("On day selected: $selectedDay, $focusedDay");
    ref.read(focusedDayProvider.notifier).state = selectedDay;
  }

  void _onPageChanged(DateTime focusedDay, WidgetRef ref) {
    logger.debug("On page changed: $focusedDay");
    ref.read(focusedDayProvider.notifier).state = focusedDay;
  }
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
            color: Color.fromRGBO(128, 128, 128, 0.5),
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
