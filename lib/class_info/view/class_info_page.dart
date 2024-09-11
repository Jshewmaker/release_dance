import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/class_info/bloc/class_info_bloc.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_dance/home/home.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

final formatCurrency = NumberFormat.simpleCurrency();

class ClassInfoPage extends StatelessWidget {
  const ClassInfoPage({required this.classId, required this.date, super.key});

  factory ClassInfoPage.pageBuilder(BuildContext _, GoRouterState state) {
    return ClassInfoPage(
      classId: state.pathParameters['classId']!,
      date: state.pathParameters['date']!,
    );
  }

  final String classId;
  final String date;
  static String get routeName => 'classInfo';
  static String get routePath => 'classInfo/:classId/:date';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassInfoBloc>(
      create: (context) => ClassInfoBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(ClassInfoRequested(classId, date)),
      child: _ClassInfoView(
        date: date,
      ),
    );
  }
}

class _ClassInfoView extends StatelessWidget {
  const _ClassInfoView({required this.date});
  final String date;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: BlocConsumer<ClassInfoBloc, ClassInfoState>(
        listener: (context, state) {
          if (state.status == ClassInfoStatus.redeemed) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.successfullyRegisteredForClass),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ClassInfoStatus.loaded ||
              state.status == ClassInfoStatus.redeemed) {
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
                      title: course!.name,
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
                  child: (course.isDropIn)
                      ? _SignUpForDropInButton(
                          classInfo: course,
                          date: date,
                        )
                      : _SignUpForCourseButton(classInfo: course),
                ),
              ),
            );
          }
          if (state.status == ClassInfoStatus.error) {
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

class _SignUpForDropInButton extends StatelessWidget {
  const _SignUpForDropInButton({
    required this.classInfo,
    required this.date,
  });

  final ClassInfo classInfo;
  final String date;

  @override
  Widget build(BuildContext context) {
    final dropIns = context.select<UserBloc, int>(
      (userBloc) => userBloc.state.user?.dropInClasses ?? 0,
    );

    final l10n = context.l10n;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greyTernary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () async {
        if (dropIns > 0 && classInfo.isDropIn) {
          await _useDropInBottomSheet(
            context,
            dropIns,
          );
        } else {
          await _buyDropInBottomSheet(
            context,
            classInfo,
          );
        }
      },
      child: (dropIns > 0)
          ? Text(l10n.registerForClass)
          : Text(
              '${l10n.joinClassLabel} ${formatCurrency.format(
                classInfo.price,
              )}',
            ),
    );
  }

  Future<void> _useDropInBottomSheet(
    BuildContext context,
    int dropInClasses,
  ) async {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      l10n.confirmSignUp,
                      style: theme.textTheme.displayMedium!
                          .copyWith(color: AppColors.black),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      l10n.thisWillUseDropInClass(
                        dropInClasses - 1,
                      ),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greyTernary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<ClassInfoBloc>()
                            .add(DropInRedeemed(classInfo.classId));

                        Navigator.pop(context);
                      },
                      child: Text(l10n.confirmRegisterLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _buyDropInBottomSheet(
    BuildContext context,
    ClassInfo course,
  ) async {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SizedBox(
          child: Column(
            children: [
              Text(
                l10n.selectAPackage,
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: AppColors.black),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: DROP_IN_PACKAGES.length,
                  itemBuilder: (context, index) {
                    final price = DROP_IN_PACKAGES.values.elementAt(index);
                    final quantity = DROP_IN_PACKAGES.keys.elementAt(index);
                    return ListTile(
                      title: Text(
                        l10n.quantityClassPack(quantity),
                        style: theme.textTheme.labelMedium,
                      ),
                      subtitle: Text(
                        l10n.oneMonthExpiration,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      trailing: Text(
                        formatCurrency.format(price),
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => ConfirmCheckoutPage(
                            classId: course.classId,
                            date: date,
                            duration: course.durationWeeks,
                            dropIns: quantity,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SignUpForCourseButton extends StatelessWidget {
  const _SignUpForCourseButton({required this.classInfo});

  final ClassInfo classInfo;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greyTernary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () async {
        context.read<ClassInfoBloc>().add(CourseSignUp(classInfo.classId));
      },
      child: Text(
        '${l10n.joinCourseLabel} ${formatCurrency.format(
          classInfo.price,
        )}',
      ),
    );
  }
}