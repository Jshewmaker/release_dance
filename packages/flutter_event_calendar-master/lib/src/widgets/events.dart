import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/handlers/event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/event_selector.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/models/calendar_options.dart';
import 'package:flutter_event_calendar/src/models/style/event_options.dart';
import 'package:flutter_event_calendar/src/widgets/event_card.dart';

class Events extends StatelessWidget {
  Events({required this.onEventsChanged});
  final Function onEventsChanged;
  late final EventOptions eventStyle;

  @override
  Widget build(BuildContext context) {
    eventStyle = EventOptions.of(context);
    var events = eventCardsMaker(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onPanEnd: (details) {
            var vc = details.velocity;
            String clearVc;
            clearVc = vc.toString().replaceAll('(', '');
            clearVc = clearVc.replaceAll(')', '');
            clearVc = clearVc.replaceAll('Velocity', '');
            if (double.parse(clearVc.split(',')[0]) > 0) {
              // left
              switch (EventCalendar.calendarProvider.isRTL()) {
                case true:
                  CalendarUtils.nextDay();
                  break;
                case false:
                  CalendarUtils.previousDay();
                  break;
              }
              onEventsChanged.call();
            } else {
              // right
              switch (EventCalendar.calendarProvider.isRTL()) {
                case true:
                  CalendarUtils.previousDay();
                  break;
                case false:
                  CalendarUtils.nextDay();
                  break;
              }
              onEventsChanged.call();
            }
          },
          child: eventStyle.showLoadingForEvent?.call() == true
              ? eventStyle.loadingWidget!.call()
              : events.isEmpty
                  ? emptyView(context)
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [...events, const SizedBox(height: 200)],
                    ),
        ),
      ),
    );
  }

  List<Widget> eventCardsMaker(BuildContext context) {
    final selectedEvents = EventSelector().updateEvents();
    var eventCards = <Widget>[];
    for (final item in selectedEvents) {
      eventCards.add(
        EventCard(
          fullCalendarEvent: item,
        ),
      );
    }

    return eventCards;
  }

  Widget emptyView(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              eventStyle.emptyIcon,
              size: 95,
              color: eventStyle.emptyIconColor,
            ),
            Text(
              eventStyle.emptyText ?? Translator.getTranslation('empty'),
              style: TextStyle(
                color: eventStyle.emptyTextColor,
                fontSize: 25,
                fontFamily: CalendarOptions.of(context).font,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
