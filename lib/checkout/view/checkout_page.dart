import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/checkout/routes/routes.dart';
import 'package:release_dance/generated/assets.gen.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

final formatCurrency = NumberFormat.simpleCurrency();

enum FlowStatus { notStarted, pageOne, completed }

class CheckoutFlow {
  const CheckoutFlow({
    this.classId,
    this.numberOfClasses,
    this.total,
    this.duration,
    this.status = FlowStatus.notStarted,
  });
  final int? numberOfClasses;
  final String? classId;
  final double? total;
  final int? duration;
  final FlowStatus status;

  CheckoutFlow copyWith({
    int? numberOfClasses,
    String? classId,
    double? total,
    int? duration,
    FlowStatus? status,
  }) {
    return CheckoutFlow(
      numberOfClasses: numberOfClasses ?? this.numberOfClasses,
      classId: classId ?? this.classId,
      total: total ?? this.total,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }
}

///{@template checkout_page}
/// A page that displays the checkout screen.
/// {@endtemplate}
class CheckoutPage extends StatelessWidget {
  ///{@macro checkout_page}
  const CheckoutPage(
      {required this.classId,
      required this.date,
      required this.duration,
      super.key});

  factory CheckoutPage.pageBuilder(BuildContext _, GoRouterState state) {
    return CheckoutPage(
      classId: state.pathParameters['classId']!,
      date: state.pathParameters['date']!,
      duration: int.parse(state.pathParameters['duration']!),
    );
  }
  final String date;
  final String classId;
  final int duration;
  static const String routeName = 'checkout';
  static const String routePath = 'checkout/:duration';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(
          CheckoutStarted(classId: classId, date: date),
        ),
      child: const FlowBuilder<CheckoutFlow>(
        state: CheckoutFlow(),
        onGeneratePages: onGenerateCheckoutPages,
      ),
    );
  }
}

class CheckoutPageOne extends StatefulWidget {
  const CheckoutPageOne({
    required this.duration,
    super.key,
  });

  static Page<void> page(int duration) {
    return const NoTransitionPage<void>(child: CheckoutPageOne(duration: 1));
  }

  final int duration;

  @override
  State<CheckoutPageOne> createState() => _CheckoutPageOneState();
}

class _CheckoutPageOneState extends State<CheckoutPageOne> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state is CheckoutCourseLoaded) {
          final course = state.releaseClass;
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    onPressed: () => context.flow<CheckoutFlow>().complete(
                        (basket) =>
                            basket.copyWith(status: FlowStatus.completed)),
                  ),
                ),
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
                          'This is a ${widget.duration} week course that will meet weekly'),
                    if (widget.duration == 1)
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: AppSpacing.sm,
                          ),
                          itemCount: prices.length,
                          itemBuilder: (context, index) {
                            final price = prices.values.elementAt(index);
                            final quantity = prices.keys.elementAt(index);
                            return ListTile(
                              selected: index == selectedIndex,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              title: Text('$quantity Class Pack'),
                              trailing: Text(
                                '${formatCurrency.format(price)}',
                                style: textTheme.labelMedium!.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              subtitle: Text('1 month expiration'),
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
                      context
                          .flow<CheckoutFlow>()
                          .update((basket) => basket.copyWith(
                                status: FlowStatus.pageOne,
                                numberOfClasses:
                                    prices.keys.elementAt(selectedIndex),
                                total: prices.values.elementAt(selectedIndex),
                                classId: course.id,
                              ));
                    },
                    child: const Text('Register'),
                  ),
                )),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Map<int, double> prices = {
  1: 20.0,
  3: 55.0,
  5: 85.0,
  10: 160.0,
  30: 500.0,
};
