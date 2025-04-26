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

/// A redesigned checkout page for confirming class purchase.
/// Displays class details, editable quantity, order summary, and payment options.
class ConfirmCheckoutView extends StatelessWidget {
  /// {@macro confirm_checkout_view}
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
          if (state.status == CheckoutStatus.success) {
            // Pop to classes page and show snackbar
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.l10n.successfullyRegisteredForClass)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CheckoutStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CheckoutStatus.error) {
            return Center(child: Text(l10n.errorLoadingClassData));
          }
          final course = state.releaseClass;
          final quantity = state.quantity ?? numberOfClassesBought;
          final pricePerClass = 20.0; // TODO: Get from course or pricing logic
          final subtotal = pricePerClass * quantity;
          final tax = subtotal * 0.06;
          final total = subtotal + tax;
          return AbsorbPointer(
            absorbing: state.isProcessing,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (course != null)
                      ReleaseClassCard(
                        id: course.id,
                        title: course.name,
                        subtitle:
                            '${course.startTime.hour}:${course.startTime.minute.toString().padLeft(2, '0')} - '
                            '${course.endTime.hour}:${course.endTime.minute.toString().padLeft(2, '0')}',
                        location: course.instructor,
                        active: true,
                        background: 'assets/images/release_studio.jpg',
                        onTap: null,
                      ),
                    const SizedBox(height: 16),
                    Text(l10n.orderSummary, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.numberOfClasses),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1 && !state.isProcessing
                                  ? () => context.read<CheckoutBloc>().add(
                                        CheckoutQuantityChanged(quantity - 1),
                                      )
                                  : null,
                            ),
                            Text('$quantity',
                                style: theme.textTheme.titleMedium),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: quantity < 10 && !state.isProcessing
                                  ? () => context.read<CheckoutBloc>().add(
                                        CheckoutQuantityChanged(quantity + 1),
                                      )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    _OrderSummaryRow(
                        label: l10n.pricePerClass,
                        value: formatCurrency.format(pricePerClass)),
                    _OrderSummaryRow(
                        label: l10n.subtotalLabel,
                        value: formatCurrency.format(subtotal)),
                    _OrderSummaryRow(
                        label: l10n.taxLabel,
                        value: formatCurrency.format(tax)),
                    _OrderSummaryRow(
                        label: l10n.totalLabel,
                        value: formatCurrency.format(total),
                        isTotal: true),
                    const SizedBox(height: 24),
                    Text(l10n.paymentMethod, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    if (state.paymentError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(state.paymentError!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    _CheckoutButton(
                      label: l10n.payWithCreditDebit,
                      icon: Icons.credit_card,
                      loading: state.isProcessing,
                      onPressed: !state.isProcessing
                          ? () => context.read<CheckoutBloc>().add(
                                CheckoutPaymentStarted(
                                  method: 'Credit/Debit',
                                  numberOfClassesBought: quantity,
                                ),
                              )
                          : null,
                    ),
                    _CheckoutButton(
                      label: l10n.payWithApplePay,
                      icon: Icons.phone_iphone,
                      loading: state.isProcessing,
                      onPressed: !state.isProcessing
                          ? () => context.read<CheckoutBloc>().add(
                                CheckoutPaymentStarted(
                                  method: 'Apple Pay',
                                  numberOfClassesBought: quantity,
                                ),
                              )
                          : null,
                    ),
                    _CheckoutButton(
                      label: l10n.payWithGooglePay,
                      icon: Icons.android,
                      loading: state.isProcessing,
                      onPressed: !state.isProcessing
                          ? () => context.read<CheckoutBloc>().add(
                                CheckoutPaymentStarted(
                                  method: 'Google Pay',
                                  numberOfClassesBought: quantity,
                                ),
                              )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Helper widget for order summary rows.
class _OrderSummaryRow extends StatelessWidget {
  const _OrderSummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });
  final String label;
  final String value;
  final bool isTotal;
  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

// Helper widget for payment buttons.
class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greyTernary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(label),
      ),
    );
  }
}
