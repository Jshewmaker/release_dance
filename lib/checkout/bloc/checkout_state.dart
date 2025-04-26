part of 'checkout_bloc.dart';

enum CheckoutStatus {
  loading,
  loaded,
  processing,
  success,
  error,
}

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.loading,
    this.releaseClass,
    this.quantity,
    this.isProcessing = false,
    this.paymentError,
    this.error,
  });

  final CheckoutStatus status;
  final ReleaseClass? releaseClass;
  final int? quantity;
  final bool isProcessing;
  final String? paymentError;
  final String? error;
  @override
  List<Object?> get props => [
        status,
        releaseClass,
        quantity,
        isProcessing,
        paymentError,
        error,
      ];

  CheckoutState copyWith({
    CheckoutStatus? status,
    ReleaseClass? releaseClass,
    int? quantity,
    bool? isProcessing,
    String? paymentError,
    String? error,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      releaseClass: releaseClass ?? this.releaseClass,
      quantity: quantity ?? this.quantity,
      isProcessing: isProcessing ?? this.isProcessing,
      paymentError: paymentError ?? this.paymentError,
      error: error ?? this.error,
    );
  }
}
