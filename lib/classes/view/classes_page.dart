import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:release_dance/generated/assets.gen.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  factory ClassesPage.pageBuilder(_, __) {
    return const ClassesPage();
  }

  static String get routeName => '/classes';

  @override
  Widget build(BuildContext context) {
    return const ClassesView();
  }
}

class ClassesView extends StatelessWidget {
  const ClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EventCalendar(
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
          Event(
            child: const _ClassCard(
              title: 'Hip Hop Beg/Int Class',
              time: 'Monday 5:45 PM',
              instructor: 'Janet',
              location: 'Ferndale',
            ),
            dateTime: CalendarDateTime(
              hour: 5,
              minute: 45,
              year: 2024,
              month: 7,
              day: 1,
              calendarType: CalendarType.GREGORIAN,
            ),
          ),
          Event(
            child: const _ClassCard(
              title: 'GROOVES (CARDIO DANCE)',
              time: 'Monday 6:45 PM',
              instructor: 'Release Crew',
              location: 'Ferndale',
            ),
            dateTime: CalendarDateTime(
              hour: 6,
              minute: 45,
              year: 2024,
              month: 7,
              day: 1,
              calendarType: CalendarType.GREGORIAN,
            ),
          ),
          Event(
            child: const _ClassCard(
              title: 'TECHNIQUE (LEAPS & TURNS)',
              time: 'Monday 7:30 PM',
              instructor: 'Jermey',
              location: 'Ferndale',
            ),
            dateTime: CalendarDateTime(
              hour: 7,
              minute: 30,
              year: 2024,
              month: 7,
              day: 1,
              calendarType: CalendarType.GREGORIAN,
            ),
          ),
          Event(
            child: const _ClassCard(
              title: 'CONTEMPORARY INT/ADV',
              time: 'Monday 8:45 PM',
              instructor: 'Sam',
              location: 'Ferndale',
            ),
            dateTime: CalendarDateTime(
              hour: 8,
              minute: 45,
              year: 2024,
              month: 7,
              day: 1,
              calendarType: CalendarType.GREGORIAN,
            ),
          ),
          Event(
              child: const SizedBox(
                height: 200,
              ),
              dateTime: CalendarDateTime(
                hour: 9,
                minute: 45,
                year: 2024,
                month: 7,
                day: 1,
                calendarType: CalendarType.GREGORIAN,
              ))
        ],
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
    super.key,
  });
  final String title;
  final String time;
  final String instructor;
  final String location;

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
              AppColors.black.withOpacity(0.5),
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
