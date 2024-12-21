import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/dictionaries/en.dart';
import 'package:flutter_event_calendar/src/dictionaries/fa.dart';
import 'package:flutter_event_calendar/src/dictionaries/pt.dart';
import 'package:flutter_event_calendar/src/dictionaries/de.dart';

Map<String, Map<CalendarType, List<String>>> fullMonthNames = {
  ...Fa.fullMonthNames,
  ...En.fullMonthNames,
  ...Pt.fullMonthNames,
  ...De.fullMonthNames,
};

Map<String, Map<CalendarType, List<String>>> shortMonthNames = {
  ...Fa.shortMonthNames,
  ...En.shortMonthNames,
  ...Pt.shortMonthNames,
  ...De.shortMonthNames,
};

Map<String, Map<CalendarType, List<String>>> fullDayNames = {
  ...Fa.fullDayNames,
  ...En.fullDayNames,
  ...Pt.fullDayNames,
  ...De.fullDayNames,
};

Map<String, Map<CalendarType, List<String>>> shortDayNames = {
  ...Fa.shortDayNames,
  ...En.shortDayNames,
  ...Pt.shortDayNames,
  ...De.shortDayNames,
};

Map<String, Map<String, String>> titles = {
  ...Fa.titles,
  ...En.titles,
  ...Pt.titles,
  ...De.titles,
};

Map<String, bool> directionIsRTL = {
  ...Fa.directionIsRTL,
  ...En.directionIsRTL,
  ...Pt.directionIsRTL,
  ...De.directionIsRTL,
};
