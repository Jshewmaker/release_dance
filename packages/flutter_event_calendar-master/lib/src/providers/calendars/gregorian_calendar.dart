import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/providers/calendars/calendar_provider.dart';

class GregorianCalendar extends CalendarProvider {
  @override
  CalendarDateTime getDateTime() {
    return CalendarDateTime.parseDateTime(
        DateTime.now().toString(), getCalendarType())!;
  }

  @override
  CalendarDateTime getNextMonthDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime.parseDateTime(
        DateTime(date.year, date.month + 1).toString(), getCalendarType())!;
  }

  @override
  CalendarDateTime getPreviousMonthDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime.parseDateTime(
        DateTime(date.year, date.month - 1).toString(), getCalendarType())!;
  }

  @override
  CalendarDateTime getPreviousDayDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime(
        year: date.year,
        month: date.month,
        day: date.day - 1,
        calendarType: getCalendarType());
  }

  @override
  CalendarDateTime getNextDayDateTime() {
    final date = _getSelectedDate();
    return CalendarDateTime(
        year: date.year,
        month: date.month,
        day: date.day + 1,
        calendarType: getCalendarType());
  }

  @override
  bool isRTL() => Translator.isRTL();

  @override
  Map<int, String> getMonthDays(WeekDayStringTypes type, int index) {
    final Map<int, String> days = {};
    var now = _getSelectedDate();
    var monthLength = DateTime(now.year, index + 1, 0).day;
    var firstDayOfMonth = DateTime(now.year, index);
    var dayIndex = firstDayOfMonth.weekday;

    switch (type) {
      case WeekDayStringTypes.FULL:
        for (var i = 1; i <= monthLength; i++) {
          days[i] = Translator.getFullNameOfDays()[dayIndex % 7];
          dayIndex++;
        }
        break;
      case WeekDayStringTypes.SHORT:
        for (var i = 1; i <= monthLength; i++) {
          days[i] = Translator.getShortNameOfDays()[dayIndex % 7];
          dayIndex++;
        }
        break;
    }
    return days;
  }

  @override
  Map<int, String> getMonthDaysShort(int index) {
    final Map<int, String> days = {};
    final now = _getSelectedDate();
    final monthLength = DateTime(now.year, index + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, index);
    var dayIndex = firstDayOfMonth.weekday;
    for (var i = 1; i <= monthLength; i++) {
      days[i] = Translator.getShortNameOfDays()[dayIndex % 7];
      dayIndex++;
    }
    return days;
  }

  @override
  List<int> getYears() {
    final year = _getSelectedDate().year;
    var years = <int>[];
    for (var i = -100; i <= 50; i++) {
      years.add(year + i);
    }
    return years;
  }

  @override
  List<int> getDayAmount() {
    final month = _getSelectedDate().month;
    var daysinCurrentMonth =
        getMonthDays(WeekDayStringTypes.FULL, month).length;
    var days = <int>[];
    for (var i = 1; i <= daysinCurrentMonth; i++) {
      days.add(i);
    }
    return days;
  }

  CalendarDateTime _getSelectedDate() {
    return EventCalendar.dateTime!;
  }

  @override
  CalendarDateTime goToDay(int index) {
    final date = _getSelectedDate();
    return CalendarDateTime(
        year: date.year,
        month: date.month,
        day: index,
        calendarType: getCalendarType());
  }

  @override
  CalendarDateTime goToMonth(int index) {
    final date = _getSelectedDate();
    return CalendarDateTime(
        year: date.year, month: index, day: 1, calendarType: getCalendarType());
  }

  @override
  CalendarDateTime goToYear(int index) {
    final date = _getSelectedDate();
    return CalendarDateTime(
        year: index,
        month: date.month,
        day: 1,
        calendarType: getCalendarType());
  }

  @override
  int getDateTimePart(PartFormat format) {
    final date = _getSelectedDate();
    switch (format) {
      case PartFormat.YEAR:
        return date.year;
      case PartFormat.MONTH:
        return date.month;
      case PartFormat.DAY:
        return date.day;
    }
  }

  @override
  String getFormattedDate({DateTime? customDate}) {
    CalendarDateTime? dateTime;
    if (customDate != null) {
      dateTime = CalendarDateTime.parseDateTime(
          customDate.toString(), getCalendarType());
    } else {
      dateTime = _getSelectedDate();
    }
    return '${dateTime!.day} ${Translator.getFullMonthNames()[dateTime.month - 1]} ${dateTime.year}';
  }

  @override
  CalendarType getCalendarType() {
    return CalendarType.GREGORIAN;
  }
}
