import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:release_dance/checkout/checkout.dart';

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
            onPressed: () => context.flow<CheckoutFlow>().update(
                  (basket) => basket.copyWith(
                    status: FlowStatus.notStarted,
                  ),
                ),
          ),
          title: const Text('Checkout Page Two'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(basket.total.toString()),
              ElevatedButton(
                onPressed: () {
                  context.read<CheckoutBloc>().add(
                        CheckoutFinished(
                          classId: basket.classId!,
                          total: basket.total!,
                          duration: basket.numberOfClasses!,
                        ),
                      );
                },
                child: const Text('Go to Checkout Page Three'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
