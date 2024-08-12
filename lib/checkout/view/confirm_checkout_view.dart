import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/l10n/l10n.dart';

///{@template confirm_checkout_view}
/// End of the checkout process.
/// Displays the total and a button to complete the checkout.
/// {@endtemplate}
class ConfirmCheckoutView extends StatelessWidget {
  ///{@macro confirm_checkout_view}
  const ConfirmCheckoutView({super.key});

  static Page<void> page() {
    return const NoTransitionPage(child: ConfirmCheckoutView());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final basket = context.flow<CheckoutFlow>().state;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          context.flow<CheckoutFlow>().complete(
                (basket) => basket.copyWith(status: FlowStatus.checkout),
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.pop(),
          ),
          title: const Text('Confirm Checkout'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
                              'Course:',
                              style: theme.textTheme.displaySmall,
                            ),
                            trailing: Text(
                              state.releaseClass.name,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Course:',
                              style: theme.textTheme.displaySmall,
                            ),
                            trailing: Text(
                              state.releaseClass.name,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              'Course:',
                              style: theme.textTheme.displaySmall,
                            ),
                            trailing: Text(
                              state.releaseClass.name,
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                        ],
                      );
                      // return Row(
                      //   children: [
                      //     const Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [Text('Course')],
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [

                      //           Text(
                      //             state.releaseClass.name,
                      //             style: theme.textTheme.displaySmall,
                      //           ),
                      //           Text(
                      //             state.releaseClass.name,
                      //             style: theme.textTheme.displaySmall,
                      //           )
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // );
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
                    onPressed: () {
                      // context.read<CheckoutBloc>().add(
                      //       EnrolledInDropIn(
                      //         classId: basket.classId!,
                      //         total: basket.total!,
                      //         duration: basket.numberOfClasses!,
                      //       ),
                      //     );
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
