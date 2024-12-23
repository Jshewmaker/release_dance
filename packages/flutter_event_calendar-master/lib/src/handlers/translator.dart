import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/dictionaries/dictionary.dart';

class Translator {
  static String getPartTranslate(
      HeaderOptions options, PartFormat format, int index) {
    switch (format) {
      case PartFormat.MONTH:
        return _getMonthName(options.monthStringType, index);
      default:
        return '';
    }
  }

  static String _getMonthName(MonthStringTypes type, int index) {
    switch (type) {
      case MonthStringTypes.SHORT:
        return getShortMonthNames()[index];
      case MonthStringTypes.FULL:
        return getFullMonthNames()[index];
    }
  }

  static String getTranslation(String word) =>
      titles[EventCalendar.calendarLanguage]![word]!;

  static List<String> getNameOfDay(WeekDayStringTypes type) {
    switch (type) {
      case WeekDayStringTypes.SHORT:
        return getShortNameOfDays();
      case WeekDayStringTypes.FULL:
        return getFullNameOfDays();
    }
  }

  static Map getMonthDaysShort(int monthIndex) =>
      EventCalendar.calendarProvider.getMonthDaysShort(monthIndex);

  static List<String> getShortNameOfDays() => shortDayNames[
      EventCalendar.calendarLanguage]![EventCalendar.calendarType]!;

  static List<String> getFullNameOfDays() => fullDayNames[
      EventCalendar.calendarLanguage]![EventCalendar.calendarType]!;

  static List<String> getFullMonthNames() => fullMonthNames[
      EventCalendar.calendarLanguage]![EventCalendar.calendarType]!;

  static List<String> getShortMonthNames() => shortMonthNames[
      EventCalendar.calendarLanguage]![EventCalendar.calendarType]!;

  static bool isRTL() => directionIsRTL[EventCalendar.calendarLanguage]!;
}
