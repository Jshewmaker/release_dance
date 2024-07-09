import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/class_info/view/class_info_page.dart';
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
      child: Scaffold(
        body: BlocBuilder<ClassBloc, ClassState>(
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
                ),
              ),
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
                    child: ReleaseClassCard(
                      id: e.id,
                      onTap: () => context.pushNamed(
                        ClassInfoPage.routeName,
                        pathParameters: {'classId': e.id},
                      ),
                      title: e.name,
                      subtitle:
                          '${e.startTime.hour} - ${e.endTime.hour} ${e.instructor}',
                      location: 'Release - Ferndale',
                      active: true,
                      background: Assets.images.releaseStudio.path,
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
      ),
    );
  }
}
