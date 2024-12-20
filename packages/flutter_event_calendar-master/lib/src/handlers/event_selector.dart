import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class EventSelector {
  List<Event> updateEvents() {
    EventCalendar.selectedEvents = [];

    var i = 0;
    for (final item in EventCalendar.events) {
      final eventDateTimeParts = item.dateTime;
      final calendarDateTimeParts = EventCalendar.dateTime!;
      if (eventDateTimeParts.isDateEqual(calendarDateTimeParts)) {
        item.listIndex = i;
        EventCalendar.selectedEvents.add(item);
      }

      i++;
    }

    return EventCalendar.selectedEvents;
  }

  List<Event> getEventsByDayMonthYear(CalendarDateTime date) {
    EventCalendar.selectedEvents = [];
    var i = 0;
    for (final item in EventCalendar.events) {
      final eventDateTimeParts = item.dateTime;
      if (eventDateTimeParts.isDateEqual(date)) {
        item.listIndex = i;
        EventCalendar.selectedEvents.add(item);
      }
      i++;
    }

    return EventCalendar.selectedEvents;
  }
}
