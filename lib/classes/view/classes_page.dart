import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/classes/classes.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  factory ClassesPage.pageBuilder(_, __) {
    return const ClassesPage();
  }

  static String get routeName => '/classes';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(
          ClassesFetched(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          ),
        ),
      child: const ClassesView(),
    );
  }
}

class ClassesView extends StatefulWidget {
  const ClassesView({super.key});

  @override
  State<ClassesView> createState() => _ClassesViewState();
}

class _ClassesViewState extends State<ClassesView> {
  final now = DateTime.now();
  late CalendarDateTime newDate;

  @override
  void initState() {
    newDate = CalendarDateTime(
      calendarType: CalendarType.GREGORIAN,
      year: int.parse(DateFormat().add_y().format(now)),
      month: int.parse(DateFormat().add_M().format(now)),
      day: int.parse(DateFormat().add_d().format(now)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ClassBloc, ClassState>(
        builder: (context, state) {
          return EventCalendar(
            eventOptions: EventOptions(
                showLoadingForEvent: () {
                  return state.status == ClassStatus.loading;
                },
                loadingWidget: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    )),
            onDateTimeReset: (date) {
              context
                  .read<ClassBloc>()
                  .add(ClassesFetched(date: date.getDate()));
              setState(() {
                newDate = date;
              });
            },
            onMonthChanged: (date) {
              context
                  .read<ClassBloc>()
                  .add(ClassesFetched(date: date.getDate()));
              setState(() {
                newDate = date;
              });
            },
            dateTime: newDate,
            headerOptions: HeaderOptions(
              weekDayStringType: WeekDayStringTypes.SHORT,
            ),
            dayOptions: DayOptions(selectedBackgroundColor: AppColors.black),
            calendarOptions: CalendarOptions(
              viewType: ViewType.DAILY,
              headerMonthBackColor: AppColors.greyPrimary,
              headerMonthShadowColor: AppColors.greyPrimary,
              bottomSheetBackColor: AppColors.black,
            ),
            calendarType: CalendarType.GREGORIAN,
            events: [
              ...state.classes.map((e) {
                final hour = e.startTime.hour.split(':');
                return Event(
                  child: _ClassCard(
                    title: e.name,
                    time: '${e.startTime.hour} - ${e.endTime.hour}',
                    instructor: e.instructor,
                    location: 'Ferndale',
                    active: true,
                  ),
                  dateTime: CalendarDateTime(
                    hour: int.parse(hour.first),
                    minute: int.parse(hour.last),
                    year: int.parse(e.startTime.year),
                    month: int.parse(e.startTime.month),
                    day: int.parse(e.startTime.day),
                    calendarType: CalendarType.GREGORIAN,
                  ),
                );
              }),
              ...state.classes.map((e) {
                final hour = e.startTime.hour.split(':');
                return Event(
                  child: _ClassCard(
                    title: e.name,
                    time: '${e.startTime.hour} - ${e.endTime.hour}',
                    instructor: e.instructor,
                    location: 'Ferndale',
                    active: true,
                  ),
                  dateTime: CalendarDateTime(
                    hour: int.parse(hour.first),
                    minute: int.parse(hour.last),
                    year: int.parse(e.startTime.year),
                    month: int.parse(e.startTime.month),
                    day: int.parse(e.startTime.day),
                    calendarType: CalendarType.GREGORIAN,
                  ),
                );
              }),
              ...state.classes.map((e) {
                final hour = e.startTime.hour.split(':');
                return Event(
                  child: _ClassCard(
                    title: e.name,
                    time: '${e.startTime.hour} - ${e.endTime.hour}',
                    instructor: e.instructor,
                    location: 'Ferndale',
                    active: true,
                  ),
                  dateTime: CalendarDateTime(
                    hour: int.parse(hour.first),
                    minute: int.parse(hour.last),
                    year: int.parse(e.startTime.year),
                    month: int.parse(e.startTime.month),
                    day: int.parse(e.startTime.day),
                    calendarType: CalendarType.GREGORIAN,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.title,
    required this.time,
    required this.instructor,
    required this.location,
    required this.active,
    super.key,
  });
  final String title;
  final String time;
  final String instructor;
  final String location;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(Assets.images.releaseStudio.path),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              AppColors.black.withOpacity(active ? 0.3 : 0.8),
              BlendMode.darken,
            ),
          ),
        ),
        height: 200,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displayMedium,
                  ),
                  Text(
                    '$time - $instructor',
                    style: const TextStyle(color: AppColors.white),
                  ),
                  Text(
                    'Release - $location',
                    style: const TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
