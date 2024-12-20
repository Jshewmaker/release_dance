import 'package:flutter/material.dart';

import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_monthly_utils.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/handlers/event_selector.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/utils/style_provider.dart';
import 'package:flutter_event_calendar/src/widgets/day.dart';

class CalendarMonthly extends StatefulWidget {
  Function onCalendarChanged;
  List<CalendarDateTime> specialDays;

  CalendarMonthly(
      {Key? key, required this.specialDays, required this.onCalendarChanged,})
      : super(key: key);

  @override
  State<CalendarMonthly> createState() => _CalendarMonthlyState();
}

class _CalendarMonthlyState extends State<CalendarMonthly> {
  EventSelector eventSelector = EventSelector();
  late List<String> dayNames;
  late HeaderOptions headersStyle;
  late DayOptions dayOptions;

  int currDay = -1;
  int currMonth = -1;

  @override
  void initState() {
    headersStyle = HeaderOptions.of(context);
    dayNames = Translator.getNameOfDay(headersStyle.weekDayStringType);
    dayOptions = DayOptions.of(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currDay = CalendarUtils.getPartByInt(format: PartFormat.DAY);
    currMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CalendarMonthly oldWidget) {
    dayNames = Translator.getNameOfDay(headersStyle.weekDayStringType);
    currDay = CalendarUtils.getPartByInt(format: PartFormat.DAY);
    currMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (dayOptions.showWeekDay) ...[
            _buildDayName(),
          ],
          const SizedBox(
            height: 12,
          ),
          _buildMonthView(),
        ],
      ),
    );
  }

  Row _buildDayName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: EventCalendar.calendarProvider.isRTL()
          ? TextDirection.rtl
          : TextDirection.ltr,
      children: List.generate(7, (index) {
        final dayName = CalendarMonthlyUtils.getDayNameOfMonth(
            headersStyle, currMonth, EventCalendar.dateTime!.day,);
        return Expanded(
          child: Center(
            heightFactor: 1,
            child: RotatedBox(
              quarterTurns:
                  headersStyle.weekDayStringType == WeekDayStringTypes.FULL
                      ? 3
                      : 0,
              child: Text(
                dayNames[index],
                style: TextStyle(
                    color: dayNames[index] == dayName
                        ? DayOptions.of(context).selectedBackgroundColor
                        : null,
                    fontSize: 15,
                    fontFamily: CalendarOptions.of(context).font,),
              ),
            ),
          ),
        );
      }),
    );
  }

  SizedBox _buildMonthView() {
    final firstDayIndex =
        CalendarMonthlyUtils.getFirstDayOfMonth(dayNames, headersStyle);
    final lastDayIndex =
        firstDayIndex + CalendarMonthlyUtils.getLastDayOfMonth(headersStyle);
    final lastMonthLastDay =
        CalendarMonthlyUtils.getLastMonthLastDay(headersStyle);

    return SizedBox(
      height: 7 * 40,
      child: Directionality(
        textDirection: EventCalendar.calendarProvider.isRTL()
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisExtent: 40, mainAxisSpacing: 5,),
            itemBuilder: (context, index) => _buildItem(
                index, firstDayIndex, lastDayIndex, lastMonthLastDay,),),
      ),
    );
  }

  dynamic _buildItem(
      int index, int firstDayIndex, int lastDayIndex, int lastMonthLastDay,) {
    var day = -1;

    final isCurrentMonthDays = index >= firstDayIndex && index < lastDayIndex;
    final isNextMonthDays = index >= lastDayIndex;

    if (isCurrentMonthDays) {
      day = index - firstDayIndex + 1;
    } else if (isNextMonthDays)
      day = index - lastDayIndex + 1;
    else
      day = lastMonthLastDay - (firstDayIndex - index) + 1;

    if (isCurrentMonthDays) {
      return buildCurrentMonthDay(day);
    } else if (isNextMonthDays) {
      return buildNextMonthDay(day);
    } else if (day > 0) {
      return buildPrevMonthDay(day);
    }
    return const SizedBox();
  }

  Day buildCurrentMonthDay(day) {
    final curYear = CalendarMonthlyUtils.getYear(currMonth);

    final specialDay = CalendarUtils.getFromSpecialDay(
        widget.specialDays, curYear, currMonth, day,);

    final var decoration = StyleProvider.getSpecialDayDecoration(
        specialDay, curYear, currMonth, day,);
    final var isBeforeToday =
        CalendarUtils.isBeforeThanToday(curYear, currMonth, day);

    return Day(
      dayEvents: eventSelector.getEventsByDayMonthYear(
        CalendarDateTime(
          year: curYear,
          month: currMonth,
          day: day,
          calendarType: CalendarUtils.getCalendarType(),
        ),
      ),
      day: day,
      weekDay: '',
      dayStyle: DayStyle(
          compactMode: DayOptions.of(context).compactMode,
          enabled: DayOptions.of(context).disableDaysBeforeNow
              ? !isBeforeToday
              : specialDay?.isEnableDay ?? true,
          selected: day == currDay,
          useDisabledEffect: DayOptions.of(context).disableDaysBeforeNow
              ? isBeforeToday
              : false,
          decoration: decoration,),
      onCalendarChanged: () {
        CalendarUtils.goToDay(day);
        widget.onCalendarChanged.call();
      },
    );
  }

  Day buildNextMonthDay(int day) {
    final year = CalendarMonthlyUtils.getYear(currMonth + 1);
    final month = CalendarMonthlyUtils.getMonth(currMonth + 1);

    final specialDay =
        CalendarUtils.getFromSpecialDay(widget.specialDays, year, month, day);

    var decoration =
        StyleProvider.getSpecialDayDecoration(specialDay, year, month, day);

    return Day(
      day: day,
      weekDay: '',
      dayEvents: eventSelector.getEventsByDayMonthYear(
        CalendarDateTime(
            year: year,
            month: month,
            day: day,
            calendarType: CalendarUtils.getCalendarType(),),
      ),
      dayStyle: DayStyle(
        compactMode: DayOptions.of(context).compactMode,
        enabled: specialDay?.isEnableDay ?? true,
        decoration: decoration,
        useUnselectedEffect: true,
      ),
      onCalendarChanged: () {
        // reset to first to fix switching between 31/30/29 month lengths
        CalendarUtils.nextMonth();
        CalendarUtils.goToDay(day);
        widget.onCalendarChanged.call();
      },
    );
  }

  Day buildPrevMonthDay(int day) {
    final year = CalendarMonthlyUtils.getYear(currMonth - 1);
    final month = CalendarMonthlyUtils.getMonth(currMonth - 1);

    final specialDay =
        CalendarUtils.getFromSpecialDay(widget.specialDays, year, month, day);
    var isBeforeToday = CalendarUtils.isBeforeThanToday(year, month, day);
    var decoration =
        StyleProvider.getSpecialDayDecoration(specialDay, year, month, day);

    return Day(
      day: day,
      dayEvents: eventSelector.getEventsByDayMonthYear(CalendarDateTime(
          year: year,
          month: month,
          day: day,
          calendarType: CalendarUtils.getCalendarType(),),),
      weekDay: '',
      dayStyle: DayStyle(
        compactMode: true,
        enabled: DayOptions.of(context).disableDaysBeforeNow
            ? !isBeforeToday
            : specialDay?.isEnableDay ?? true,
        decoration: decoration,
        useUnselectedEffect: true,
      ),
      onCalendarChanged: () {
        // reset to first to fix switching between 31/30/29 month lengths
        CalendarUtils.previousMonth();
        CalendarUtils.goToDay(day);
        widget.onCalendarChanged.call();
      },
    );
  }
}
