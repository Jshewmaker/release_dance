import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/checkout/routes/routes.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

final formatCurrency = NumberFormat.simpleCurrency();

enum FlowStatus { notStarted, selectPackage, checkout }

class CheckoutFlow {
  const CheckoutFlow({
    this.classId,
    this.numberOfClasses,
    this.total,
    this.duration,
    this.status = FlowStatus.selectPackage,
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
/// Page that handles the navigation of the checkout flow.
/// {@endtemplate}
class CheckoutPage extends StatelessWidget {
  ///{@macro checkout_page}
  const CheckoutPage({
    required this.classId,
    required this.date,
    required this.duration,
    required this.dropIns,
    super.key,
  });

  factory CheckoutPage.pageBuilder(BuildContext _, GoRouterState state) {
    return CheckoutPage(
      classId: state.pathParameters['classId']!,
      date: state.pathParameters['date']!,
      duration: int.parse(state.pathParameters['duration']!),
      dropIns: int.parse(state.pathParameters['dropIn']!),
    );
  }
  final String date;
  final String classId;
  final int dropIns;
  final int duration;
  static const String routeName = 'checkout';
  static const String routePath = 'checkout/:duration/:dropIn';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(
          CheckoutStarted(classId: classId, date: date),
        ),
      child: FlowBuilder<CheckoutFlow>(
        state: CheckoutFlow(
          status: dropIns > 0 ? FlowStatus.checkout : FlowStatus.selectPackage,
        ),
        onGeneratePages: (state, pages) =>
            onGenerateCheckoutPages(state, pages, duration),
      ),
    );
  }
}
