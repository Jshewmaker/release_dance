import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class En {
  static Map<String, Map<CalendarType, List<String>>> fullMonthNames = const {
    'en': {
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
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
    },
  };
  static Map<String, Map<CalendarType, List<String>>> shortMonthNames = const {
    'en': {
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
        'Esf'
      ],
      CalendarType.GREGORIAN: [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ],
    },
  };

  static Map<String, Map<CalendarType, List<String>>> fullDayNames = const {
    'en': {
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
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday'
      ],
    },
  };
  static Map<String, Map<CalendarType, List<String>>> shortDayNames = const {
    'en': {
      CalendarType.JALALI: ['Sa', 'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr'],
      CalendarType.GREGORIAN: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
    },
  };
  static Map<String, Map<String, String>> titles = const {
    'en': {
      'empty': 'Empty',
      'month_selector': 'Choose a month',
      'year_selector': 'Choose a year',
      'day_selector': 'choose a day',
    },
  };

  static Map<String, bool> directionIsRTL = {'en': false};
}
