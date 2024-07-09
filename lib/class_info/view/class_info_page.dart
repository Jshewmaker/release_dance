import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/class_info/bloc/class_info_bloc.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

final formatCurrency = NumberFormat.simpleCurrency();

class ClassInfoPage extends StatelessWidget {
  const ClassInfoPage({required this.classId, super.key});

  factory ClassInfoPage.pageBuilder(BuildContext _, GoRouterState state) {
    return ClassInfoPage(
      classId: state.pathParameters['classId']!,
    );
  }

  final String classId;
  static String get routeName => 'classInfod';
  static String get routePath => '/classInfo/:classId';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassInfoBloc>(
      create: (context) => ClassInfoBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(ClassInfoRequested(classId)),
      child: const _ClassInfoView(),
    );
  }
}

class _ClassInfoView extends StatelessWidget {
  const _ClassInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: BlocBuilder<ClassInfoBloc, ClassInfoState>(
        builder: (context, state) {
          if (state is ClassInfoLoaded) {
            final course = state.classInfo;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: ScrollableColumn(
                  children: [
                    ReleaseClassCard(
                      title: course.name,
                      subtitle: '',
                      location: 'Release - Ferndale',
                      id: course.classId,
                      active: true,
                      background: Assets.images.releaseStudio.path,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.descriptionTitle,
                            style: theme.textTheme.headlineLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            course.description.replaceAll(r'\n', '\n'),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyTernary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      course.durationWeeks > 1
                          ? '${l10n.joinCourseLabel} ${formatCurrency.format(
                              course.price,
                            )}'
                          : '${l10n.joinClassLabel} ${formatCurrency.format(
                              course.price,
                            )}',
                    ),
                  ),
                ),
              ),
            );
          }
          if (state is ClassInfoError) {
            return Center(
              child: Text(l10n.errorLoadingClassData),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
