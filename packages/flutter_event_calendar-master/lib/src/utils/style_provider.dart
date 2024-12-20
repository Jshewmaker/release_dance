import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/models/datetime.dart';

class StyleProvider {
  static BoxDecoration? getSpecialDayDecoration(
    CalendarDateTime? specialDay,
    int curYear,
    int currentMonth,
    int day,
  ) {
    BoxDecoration? decoration;
    final isStartRange =
        CalendarUtils.isStartOfRange(specialDay, curYear, currentMonth, day);
    final isEndRange =
        CalendarUtils.isEndOfRange(specialDay, curYear, currentMonth, day);
    final isInRange =
        CalendarUtils.isInRange(specialDay, curYear, currentMonth, day);

    if (isEndRange && isStartRange) {
      decoration = BoxDecoration(
        color: specialDay?.color,
        borderRadius: BorderRadius.circular(8),
      );
    } else if (isStartRange) {
      decoration = BoxDecoration(
        color: specialDay?.color,
        borderRadius: _getStartRadiusByLocale(),
      );
    } else if (isEndRange) {
      decoration = BoxDecoration(
        color: specialDay?.color,
        borderRadius: _getEndRadiusByLocale(),
      );
    } else if (isInRange) {
      decoration = BoxDecoration(color: specialDay?.color);
    }
    return decoration;
  }

  static bool _isRTL() => EventCalendar.calendarProvider.isRTL();

  static BorderRadius _getStartRadiusByLocale() {
    return _isRTL()
        ? const BorderRadius.horizontal(right: Radius.circular(8))
        : const BorderRadius.horizontal(left: Radius.circular(8));
  }

  static BorderRadius _getEndRadiusByLocale() {
    return _isRTL()
        ? const BorderRadius.horizontal(left: Radius.circular(8))
        : const BorderRadius.horizontal(right: Radius.circular(8));
  }
}
