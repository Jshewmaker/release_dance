import 'package:flutter_event_calendar/flutter_event_calendar.dart';

abstract class CalendarProvider {
  bool isRTL();

  Map<int, String> getMonthDays(WeekDayStringTypes type, int index);

  Map<int, String> getMonthDaysShort(int index);

  CalendarDateTime getNextMonthDateTime();

  CalendarDateTime getPreviousMonthDateTime();

  CalendarDateTime getNextDayDateTime();

  CalendarDateTime getPreviousDayDateTime();

  CalendarDateTime getDateTime();

  String getFormattedDate({DateTime? customDate});

  CalendarDateTime goToMonth(int index);

  CalendarDateTime goToDay(int index);

  CalendarDateTime goToYear(int index);

  int getDateTimePart(PartFormat format);

  List<int> getYears();
  List<int> getDayAmount();
  CalendarType getCalendarType();
}
