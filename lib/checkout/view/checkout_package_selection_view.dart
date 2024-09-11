import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

class CheckoutPackageSelectionPage extends StatelessWidget {
  const CheckoutPackageSelectionPage({
    required this.classId,
    required this.date,
    required this.duration,
    super.key,
  });

  final String classId;
  final String date;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(
          CheckoutEventStarted(classId: classId, date: date),
        ),
      child: CheckoutPackageSelectionView(
        duration: duration,
      ),
    );
  }
}

class CheckoutPackageSelectionView extends StatefulWidget {
  const CheckoutPackageSelectionView({
    required this.duration,
    super.key,
  });

  final int duration;

  @override
  State<CheckoutPackageSelectionView> createState() =>
      _CheckoutPackageSelectionViewState();
}

class _CheckoutPackageSelectionViewState
    extends State<CheckoutPackageSelectionView> {
  int selectedPackage = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state is CheckoutCourseLoaded) {
          final course = state.releaseClass;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: Column(
                children: [
                  ReleaseClassCard(
                    title: course.name,
                    subtitle:
                        '${course.startTime.hour}-${course.endTime.hour} ',
                    location: course.date,
                    id: course.id,
                    active: true,
                    background: Assets.images.releaseStudio.path,
                  ),
                  if (widget.duration > 1)
                    Text(
                      l10n.courseDuration(widget.duration),
                    ),
                  if (widget.duration == 1)
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: AppSpacing.sm,
                        ),
                        itemCount: DROP_IN_PACKAGES.length,
                        itemBuilder: (context, package) {
                          final price =
                              DROP_IN_PACKAGES.values.elementAt(package);
                          final quantity =
                              DROP_IN_PACKAGES.keys.elementAt(package);
                          return ListTile(
                            selected: package == selectedPackage,
                            onTap: () {
                              setState(() {
                                selectedPackage = package;
                              });
                            },
                            title: Text(l10n.quantityClassPack(quantity)),
                            trailing: Text(
                              formatCurrency.format(price),
                              style: textTheme.labelMedium!.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            subtitle: Text(l10n.oneMonthExpiration),
                          );
                        },
                      ),
                    ),
                ],
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greyTernary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => ConfirmCheckoutPage(
                          classId: course.id,
                          date: course.date,
                          dropIns:
                              DROP_IN_PACKAGES.keys.elementAt(selectedPackage),
                          duration: widget.duration,
                        ),
                      ),
                    );
                    // context.flow<CheckoutFlow>().update(
                    //       (basket) => basket.copyWith(
                    //         status: FlowStatus.checkout,
                    //         numberOfClasses: DROP_IN_PACKAGES.keys
                    //             .elementAt(selectedPackage),
                    //         total: DROP_IN_PACKAGES.values
                    //             .elementAt(selectedPackage),
                    //         classId: course.id,
                    //       ),
                    //     );
                  },
                  child: Text(l10n.registerLabel),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
