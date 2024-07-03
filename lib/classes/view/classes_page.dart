import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
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
      )..add(ClassesFetched()),
      child: const ClassesView(),
    );
  }
}

class ClassesView extends StatelessWidget {
  const ClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ClassBloc, ClassState>(
        builder: (context, state) {
          if (state is ClassesLoading || state is ClassesInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ClassesLoaded) {
            return EventCalendar(
              headerOptions: HeaderOptions(
                weekDayStringType: WeekDayStringTypes.SHORT,
              ),
              dayOptions: DayOptions(selectedBackgroundColor: AppColors.black),
              calendarOptions: CalendarOptions(
                toggleViewType: true,
                viewType: ViewType.DAILY,
                headerMonthBackColor: AppColors.greyPrimary,
                headerMonthShadowColor: AppColors.greyPrimary,
                bottomSheetBackColor: AppColors.black,
              ),
              calendarType: CalendarType.GREGORIAN,
              events: [
                ...state.classes.map((e) {
                  final hour = int.parse(e.startTime.hour.split(' ')[0]);
                  return Event(
                    child: _ClassCard(
                      title: e.name,
                      time: '${e.startTime.hour} - ${e.endTime.hour}',
                      instructor: e.instructor,
                      location: 'Ferndale',
                      active: true,
                    ),
                    dateTime: CalendarDateTime(
                      hour: hour,
                      minute: int.parse(e.startTime.minute),
                      year: int.parse(e.startTime.year),
                      month: int.parse(e.startTime.month),
                      day: int.parse(e.startTime.day),
                      calendarType: CalendarType.GREGORIAN,
                    ),
                  );
                }),
              ],
            );
          }
          return const Center(
            child: Text('Error'),
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
