import 'package:flutter/material.dart';

import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';

import 'package:flutter_event_calendar/src/handlers/event_selector.dart';

import 'package:flutter_event_calendar/src/utils/style_provider.dart';
import 'package:flutter_event_calendar/src/widgets/day.dart';

class CalendarDaily extends StatelessWidget {

  CalendarDaily({this.onCalendarChanged, required this.specialDays}) : super() {
    dayIndex = CalendarUtils.getPartByInt(format: PartFormat.DAY);
  }
  Function? onCalendarChanged;
  var dayIndex;
  late ScrollController animatedTo;
  EventSelector selector = EventSelector();
  List<CalendarDateTime> specialDays;

  @override
  Widget build(BuildContext context) {
    animatedTo = ScrollController(
        initialScrollOffset: (DayOptions.of(context).compactMode
                ? 40.0
                : (HeaderOptions.of(context).weekDayStringType ==
                        WeekDayStringTypes.FULL
                    ? 80.0
                    : 60.0)) *
            (dayIndex - 1),);

    executeAsync(context);
    // Yearly , Monthly , Weekly and Daily calendar
    return SizedBox(
      height: DayOptions.of(context).showWeekDay
          ? DayOptions.of(context).compactMode
              ? 70
              : 100
          : 70,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            reverse: EventCalendar.calendarProvider.isRTL(),
            controller: animatedTo,
            scrollDirection: Axis.horizontal,
            children: daysMaker(context),
          ),
          if (DayOptions.of(context).disableFadeEffect) const SizedBox() else Align(
                  alignment: Alignment.centerLeft,
                  child: IgnorePointer(
                    child: Container(
                      width: 70,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xffffffff), Color(0x0affffff)],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                ),
          if (DayOptions.of(context).disableFadeEffect) const SizedBox() else Align(
                  alignment: Alignment.centerRight,
                  child: IgnorePointer(
                    child: Container(
                      width: 70,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [Color(0xffffffff), Color(0x0affffff)],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  List<Widget> daysMaker(BuildContext context) {
    var currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final var currentYear = CalendarUtils.getPartByInt(format: PartFormat.YEAR);

    final headersStyle = HeaderOptions.of(context);

    var days = <Widget>[
      SizedBox(
          width: DayOptions.of(context).compactMode
              ? 40
              : headersStyle.weekDayStringType == WeekDayStringTypes.FULL
                  ? 80
                  : 60,),
    ];

    final int day = dayIndex;
    CalendarUtils.getDays(headersStyle.weekDayStringType, currentMonth)
        .forEach((index, weekDay) {
      final specialDay = CalendarUtils.getFromSpecialDay(
          specialDays, currentYear, currentMonth, index,);

      final var decoration = StyleProvider.getSpecialDayDecoration(
          specialDay, currentYear, currentMonth, index,);

      final selected = index == day;

      final var isBeforeToday =
          CalendarUtils.isBeforeThanToday(currentYear, currentMonth, index);

      days.add(Day(
        day: index,
        dayEvents: selector.getEventsByDayMonthYear(
          CalendarDateTime(
              year: currentYear,
              month: currentMonth,
              day: index,
              calendarType: CalendarUtils.getCalendarType(),),
        ),
        dayStyle: DayStyle(
          compactMode: DayOptions.of(context).compactMode,
          decoration: decoration,
          enabled: specialDay?.isEnableDay ?? true,
          selected: selected,
          useDisabledEffect: DayOptions.of(context).disableDaysBeforeNow
              ? isBeforeToday
              : false,
        ),
        weekDay: weekDay,
        onCalendarChanged: () {
          CalendarUtils.goToDay(index);
          onCalendarChanged?.call();
        },
      ),);
    });

    days.add(
      SizedBox(
        width: DayOptions.of(context).compactMode
            ? 40
            : headersStyle.weekDayStringType == WeekDayStringTypes.FULL
                ? 80
                : 60,
      ),
    );

    return days;
  }

  BoxDecoration? _getDecoration(
      CalendarDateTime? specialDay, curYear, int currMonth, day,) {
    BoxDecoration? decoration;
    final isStartRange =
        CalendarUtils.isStartOfRange(specialDay, curYear, currMonth, day);
    final isEndRange =
        CalendarUtils.isEndOfRange(specialDay, curYear, currMonth, day);
    final isInRange =
        CalendarUtils.isInRange(specialDay, curYear, currMonth, day);

    if (isEndRange && isStartRange) {
      decoration = BoxDecoration(
          color: specialDay?.color, borderRadius: BorderRadius.circular(8),);
    } else if (isStartRange) {
      decoration = BoxDecoration(
          color: specialDay?.color,
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(8)),);
    } else if (isEndRange) {
      decoration = BoxDecoration(
          color: specialDay?.color,
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(8)),);
    } else if (isInRange) {
      decoration = BoxDecoration(color: specialDay?.color);
    }
    return decoration;
  }

  Future<void> executeAsync(context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (animatedTo.hasClients) {
        final animateOffset = (DayOptions.of(context).compactMode
                ? 40.0
                : (HeaderOptions.of(context).weekDayStringType ==
                        WeekDayStringTypes.FULL
                    ? 80.0
                    : 60.0)) *
            (dayIndex - 1);
        animatedTo.animateTo(animateOffset,
            duration: const Duration(milliseconds: 700),
            curve: Curves.decelerate,);
      }
    });
  }
}
