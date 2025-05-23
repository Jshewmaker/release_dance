import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';

class CalendarMonthlyUtils extends CalendarUtils {
  static int getYear(int month) {
    final year = CalendarUtils.getPartByInt(format: PartFormat.YEAR);
    return year;
  }

  static int getMonth(int month) {
    if (month > 12) {
      return 1;
    } else if (month < 1) return 1;
    return month;
  }

  static int getFirstDayOfMonth(
      List<String> dayNames, HeaderOptions headersStyle) {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final monthDays = CalendarUtils.getMonthDays(
        headersStyle.weekDayStringType, currentMonth);
    return dayNames.indexOf(monthDays[1] as String);
  }

  static String getDayNameOfMonth(
      HeaderOptions headersStyle, int currMonth, int index) {
    final dayName = EventCalendar.calendarProvider
        .getMonthDays(headersStyle.weekDayStringType, currMonth)[index];
    return dayName.toString();
  }

  static int getLastDayOfMonth(HeaderOptions headersStyle) {
    final currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final currentYear = CalendarUtils.getPartByInt(format: PartFormat.YEAR);
    return DateTime(currentYear, currentMonth + 1, 0).day;
  }

  static int getLastMonthLastDay(HeaderOptions headersStyle) {
    final cMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);
    final cYear = CalendarUtils.getPartByInt(format: PartFormat.YEAR);

    // Handle January case (previous month would be December of previous year)
    if (cMonth - 1 < 1) {
      return DateTime(cYear - 1, 12, 0).day;
    }

    return DateTime(cYear, cMonth - 1, 0).day;
  }
}
