import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:release_dance/checkout/checkout.dart';

class CheckoutPageTwo extends StatelessWidget {
  static Page<void> page() {
    return NoTransitionPage(child: CheckoutPageTwo());
  }

  @override
  Widget build(BuildContext context) {
    final basket = context.flow<CheckoutFlow>().state;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          context.flow<CheckoutFlow>().complete(
              (basket) => basket.copyWith(status: FlowStatus.completed));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Checkout Page Two'),
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
                child: Text('Go to Checkout Page Three'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
