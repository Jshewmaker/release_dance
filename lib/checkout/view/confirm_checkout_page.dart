import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

final formatCurrency = NumberFormat.simpleCurrency();

///{@template checkout_page}
/// Page that handles the navigation of the checkout flow.
/// {@endtemplate}
class ConfirmCheckoutPage extends StatelessWidget {
  ///{@macro checkout_page}
  const ConfirmCheckoutPage({
    required this.classId,
    required this.date,
    required this.duration,
    required this.dropIns,
    super.key,
  });

  final String date;
  final String classId;
  final int dropIns;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutBloc(
        releaseProfileRepository: context.read<ReleaseProfileRepository>(),
      )..add(
          CheckoutEventStarted(classId: classId, date: date),
        ),
      child: ConfirmCheckoutView(
        numberOfClassesBought: dropIns,
      ),
    );
  }
}

@visibleForTesting
class ConfirmCheckoutView extends StatelessWidget {
  ///{@macro confirm_checkout_view}
  const ConfirmCheckoutView({required this.numberOfClassesBought, super.key});
  final int numberOfClassesBought;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Confirm Checkout'),
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      if (state is CheckoutCourseLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Text(
                                l10n.course,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              trailing: Text(
                                state.releaseClass.name,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greyTernary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => context.read<CheckoutBloc>().add(
                            CheckoutEventBoughtDropIns(
                              numberOfClassesBought: numberOfClassesBought,
                            ),
                          ),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
