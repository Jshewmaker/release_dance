import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class De {
  static Map<String, Map<CalendarType, List<String>>> fullMonthNames = const {
    'de': {
      CalendarType.JALALI: [
        'Farvardin',
        'Ordibehesht',
        'Khordad',
        'Tir',
        'Mordad',
        'Shahrivar',
        'Mehr',
        'Aban',
        'Azar',
        'Dey',
        'Bahman',
        'Esfand',
      ],
      CalendarType.GREGORIAN: [
        'Januar',
        'Februar',
        'März',
        'April',
        'Mai',
        'Juni',
        'Juli',
        'August',
        'September',
        'Oktober',
        'November',
        'Dezember',
      ],
    },
  };
  static Map<String, Map<CalendarType, List<String>>> shortMonthNames = const {
    'de': {
      CalendarType.JALALI: [
        'Far',
        'Ord',
        'Kho',
        'Tir',
        'Mor',
        'Sha',
        'Mehr',
        'Aban',
        'Azar',
        'Dey',
        'Bah',
        'Esf',
      ],
      CalendarType.GREGORIAN: [
        'Jan',
        'Feb',
        'Mär',
        'Apr',
        'Mai',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Okt',
        'Nov',
        'Dez',
      ],
    },
  };

  static Map<String, Map<CalendarType, List<String>>> fullDayNames = const {
    'de': {
      CalendarType.JALALI: [
        'Saturday',
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
      ],
      CalendarType.GREGORIAN: [
        'Sonntag',
        'Montag',
        'Dienstag',
        'Mittwoch',
        'Donnerstag',
        'Freitag',
        'Samstag',
      ],
    },
  };
  static Map<String, Map<CalendarType, List<String>>> shortDayNames = const {
    'de': {
      CalendarType.JALALI: ['Sa', 'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr'],
      CalendarType.GREGORIAN: ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'],
    },
  };
  static Map<String, Map<String, String>> titles = const {
    'de': {
      'empty': 'Keine Termine geplant.',
      'month_selector': 'Einen Monat auswählen.',
      'year_selector': 'Ein Jahr auswählen.',
      'day_selector': 'Einen Tag auswählen.',
    },
  };

  static Map<String, bool> directionIsRTL = {'de': false};
}
