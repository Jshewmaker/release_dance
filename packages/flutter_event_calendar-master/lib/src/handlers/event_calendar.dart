import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/providers/calendars/calendar_provider.dart';
import 'package:flutter_event_calendar/src/providers/instance_provider.dart';
import 'package:flutter_event_calendar/src/widgets/calendar_daily.dart';
import 'package:flutter_event_calendar/src/widgets/calendar_monthly.dart';
import 'package:flutter_event_calendar/src/widgets/events.dart';
import 'package:flutter_event_calendar/src/widgets/header.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';

typedef CalendarChangeCallback = Function(CalendarDateTime);

// ignore: must_be_immutable
class EventCalendar extends StatefulWidget {
  EventCalendar({
    required CalendarType calendarType,
    GlobalKey? key,
    List<Event>? events,
    CalendarDateTime? dateTime,
    this.middleWidget,
    this.calendarOptions,
    this.dayOptions,
    this.eventOptions,
    this.headerOptions,
    this.showLoadingForEvent = false,
    this.specialDays = const [],
    this.onChangeDateTime,
    this.onMonthChanged,
    this.onDateTimeReset,
    this.onInit,
    this.onYearChanged,
    this.onChangeViewType,
    this.showEvents = true,
  }) : super(key: key) {
    calendarOptions ??= CalendarOptions();
    headerOptions ??= HeaderOptions();
    eventOptions ??= EventOptions();
    dayOptions ??= DayOptions();

    EventCalendar.calendarType = calendarType;

    EventCalendar.calendarProvider = createInstance(calendarType);

    if (key?.currentContext == null ||
        calendarType != EventCalendar.calendarType) {
      EventCalendar.dateTime = dateTime ?? calendarProvider.getDateTime();
    }
    EventCalendar.calendarType = calendarType ?? CalendarType.GREGORIAN;
    EventCalendar.calendarLanguage = 'en';
    EventCalendar.events = events ?? [];
  }
  static late CalendarProvider calendarProvider;
  static late CalendarDateTime? dateTime;
  static late List<Event> events;
  static List<Event> selectedEvents = [];

  // static late HeaderMonthStringTypes headerMonthStringType;
  // static late HeaderWeekDayStringTypes headerWeekDayStringType;
  static late String calendarLanguage;
  static late CalendarType calendarType;

  CalendarChangeCallback? onChangeDateTime;
  CalendarChangeCallback? onMonthChanged;
  CalendarChangeCallback? onYearChanged;
  CalendarChangeCallback? onDateTimeReset;
  ViewTypeChangeCallback? onChangeViewType;
  VoidCallback? onInit;

  List<CalendarDateTime> specialDays;

  CalendarOptions? calendarOptions;

  DayOptions? dayOptions;

  EventOptions? eventOptions;

  bool showLoadingForEvent;

  HeaderOptions? headerOptions;

  Widget? Function(CalendarDateTime)? middleWidget;

  bool showEvents;

  static void init({
    required CalendarType calendarType,
    CalendarDateTime? dateTime,
    String? calendarLanguage,
  }) {
    EventCalendar.calendarProvider = createInstance(calendarType);
    EventCalendar.dateTime =
        dateTime ?? EventCalendar.calendarProvider.getDateTime();
    EventCalendar.calendarType = calendarType;
    EventCalendar.calendarLanguage = calendarLanguage ?? 'en';
  }

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  @override
  void initState() {
    widget.onInit?.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildScopeModels(
      child: (context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Card(
                  color: CalendarOptions.of(context).headerMonthBackColor,
                  shadowColor:
                      CalendarOptions.of(context).headerMonthShadowColor,
                  shape: CalendarOptions.of(context).headerMonthShape,
                  elevation: CalendarOptions.of(context).headerMonthElevation,
                  child: Column(
                    children: [
                      Header(
                        onDateTimeReset: () {
                          widget.onDateTimeReset?.call(EventCalendar.dateTime!);
                          setState(() {});
                        },
                        onMonthChanged: (int selectedMonth) {
                          widget.onMonthChanged?.call(EventCalendar.dateTime!);
                          CalendarUtils.goToMonth(selectedMonth);
                          setState(() {});
                        },
                        onViewTypeChanged: (ViewType viewType) {
                          setState(() {});
                          widget.onChangeViewType?.call(viewType);
                        },
                        onYearChanged: (int selectedYear) {
                          widget.onYearChanged?.call(EventCalendar.dateTime!);
                          CalendarUtils.goToYear(selectedYear);
                          setState(() {});
                        },
                      ),
                      if (isMonthlyView())
                        SingleChildScrollView(
                          child: CalendarMonthly(
                            specialDays: widget.specialDays,
                            onCalendarChanged: () {
                              widget.onChangeDateTime
                                  ?.call(EventCalendar.dateTime!);

                              setState(() {});
                            },
                          ),
                        )
                      else
                        CalendarDaily(
                          specialDays: widget.specialDays,
                          onCalendarChanged: () {
                            widget.onChangeDateTime
                                ?.call(EventCalendar.dateTime!);
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
                if (widget.middleWidget != null)
                  widget.middleWidget!.call(EventCalendar.dateTime!)!,
                Events(
                  onEventsChanged: () {
                    widget.onChangeDateTime?.call(EventCalendar.dateTime!);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isMonthlyView() {
    return widget.calendarOptions?.viewType == ViewType.MONTHLY;
  }

  Widget buildScopeModels({required WidgetBuilder child}) {
    return ScopedModel<CalendarOptions>(
      model: widget.calendarOptions!,
      child: ScopedModel<DayOptions>(
        model: widget.dayOptions!,
        child: ScopedModel<EventOptions>(
          model: widget.eventOptions!,
          child: ScopedModel<HeaderOptions>(
            model: widget.headerOptions!,
            child: Builder(builder: child),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// reset date time after disposing child
    EventCalendar.dateTime = EventCalendar.calendarProvider.getDateTime();
    // EventCalendar.dateTime = null;
    super.dispose();
  }
}
