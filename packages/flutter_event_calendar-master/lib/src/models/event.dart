import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class Event {
  Event({
    required this.child,
    required this.dateTime,
    VoidCallback? Function(int listIndex)? onTap,
    VoidCallback? Function(int listIndex)? onLongPress,
  }) {
    this.onTap = onTap;
    this.onLongPress = onLongPress ??
        (int listIndex) {
          print('LongPress ' + listIndex.toString());
        };
  }
  late int listIndex;
  late Widget child;
  late CalendarDateTime dateTime;
  late Function? onTap;
  late Function? onLongPress;
}
