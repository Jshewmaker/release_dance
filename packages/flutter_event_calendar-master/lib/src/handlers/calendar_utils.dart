import 'package:collection/collection.dart';

import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';

class CalendarUtils {
  static CalendarDateTime goToYear(int index) {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.goToYear(index);
  }

  static CalendarDateTime goToMonth(int index) {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.goToMonth(index);
  }

  static CalendarDateTime goToDay(int index) {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.goToDay(index);
  }

  static CalendarDateTime nextDay() {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.getNextDayDateTime();
  }

  static CalendarDateTime previousDay() {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.getPreviousDayDateTime();
  }

  static CalendarDateTime nextMonth() {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.getNextMonthDateTime();
  }

  static CalendarDateTime previousMonth() {
    return EventCalendar.dateTime =
        EventCalendar.calendarProvider.getPreviousMonthDateTime();
  }

  static List<int> getYears() => EventCalendar.calendarProvider.getYears();
  static List<int> getDaysAmount() =>
      EventCalendar.calendarProvider.getDayAmount();

  static Map<int, String> getDays(WeekDayStringTypes type, int monthIndex) {
    return EventCalendar.calendarProvider.getMonthDays(type, monthIndex);
  }

  static Map<int, String> getMonthDays(
    WeekDayStringTypes type,
    int monthIndex,
  ) =>
      EventCalendar.calendarProvider.getMonthDays(type, monthIndex);

  static String getPartByString({
    required PartFormat format,
    required HeaderOptions options,
  }) {
    return Translator.getPartTranslate(
      options,
      format,
      EventCalendar.calendarProvider.getDateTimePart(format) - 1,
    );
  }

  static int getPartByInt({required PartFormat format}) {
    return EventCalendar.calendarProvider.getDateTimePart(format);
  }

  static CalendarDateTime? getFromSpecialDay(
    List<CalendarDateTime> specialDays,
    int year,
    int month,
    int day,
  ) {
    return specialDays.firstWhereOrNull(
      (element) => _isRange(element)
          ? isInRange(element, year, month, day)
          : element.isDateEqualByInt(year, month, day),
    );
  }

  static bool _isRange(CalendarDateTime element) =>
      element.toMonth != null || element.toDay != null;

  static bool isEndOfRange(
    CalendarDateTime? element,
    int year,
    int month,
    int day,
  ) {
    if (element?.year != year) return false;
    if (element?.toMonth == null) {
      if (element?.toDay == null) return element?.day == day;
      return element?.toDay == day;
    } else if (element?.toMonth == month) {
      if (element?.toDay == null) return element?.day == day;
      return element?.toDay == day;
    }
    return false;
  }

  static bool isStartOfRange(
    CalendarDateTime? element,
    int year,
    int month,
    int day,
  ) =>
      element?.year == year && element?.month == month && element?.day == day;

  static bool isInRange(
    CalendarDateTime? selectedDateTime,
    int year,
    int month,
    int day,
  ) {
    if (selectedDateTime?.year != year) return false;
    if (selectedDateTime?.month != null && selectedDateTime!.month > month) {
      return false;
    }
    if (selectedDateTime?.toMonth != null &&
        selectedDateTime!.toMonth! < month) {
      return false;
    }
    if (selectedDateTime?.day != null &&
        selectedDateTime!.month == month &&
        selectedDateTime.day > day) return false;

    if (selectedDateTime?.toMonth != null) {
      if (selectedDateTime!.toDay != null &&
          selectedDateTime.toMonth == month &&
          selectedDateTime.toDay! < day) return false;
    } else {
      if (selectedDateTime!.toDay != null &&
          (selectedDateTime.month != month || selectedDateTime.toDay! < day)) {
        return false;
      }
    }
    return true;
  }

  static bool isBeforeThanToday(
    int currentYear,
    int currentMonth,
    int currentDay,
  ) {
    final now = EventCalendar.calendarProvider.getDateTime();
    final currentDateTime = DateTime(currentYear, currentMonth, currentDay);
    return currentDateTime.difference(now.toDateTime()).isNegative;
  }

  static CalendarType getCalendarType() {
    return EventCalendar.calendarProvider.getCalendarType();
  }
}
