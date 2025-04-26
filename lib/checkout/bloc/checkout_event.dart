part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class CheckoutEventStarted extends CheckoutEvent {
  const CheckoutEventStarted({
    required this.classId,
    required this.date,
  });

  final String date;
  final String classId;

  @override
  List<Object> get props => [
        classId,
        date,
      ];
}

class CheckoutEventEnrolledInDropIn extends CheckoutEvent {
  const CheckoutEventEnrolledInDropIn({
    required this.classId,
    required this.dropInsUsed,
  });

  final String classId;
  final int dropInsUsed;

  @override
  List<Object> get props => [
        classId,
        dropInsUsed,
      ];
}

class CheckoutEventBoughtDropIns extends CheckoutEvent {
  const CheckoutEventBoughtDropIns({required this.numberOfClassesBought});

  final int numberOfClassesBought;

  @override
  List<Object> get props => [numberOfClassesBought];
}

// Event for changing the quantity of classes
class CheckoutQuantityChanged extends CheckoutEvent {
  const CheckoutQuantityChanged(this.quantity);
  final int quantity;
  @override
  List<Object> get props => [quantity];
}

// Event for starting a payment
class CheckoutPaymentStarted extends CheckoutEvent {
  const CheckoutPaymentStarted({
    required this.method,
    required this.numberOfClassesBought,
  });
  final String method;
  final int numberOfClassesBought;
  @override
  List<Object> get props => [method, numberOfClassesBought];
}

// Event for payment result (success/failure)
class CheckoutPaymentResult extends CheckoutEvent {
  const CheckoutPaymentResult({this.error});
  final String? error;
  @override
  List<Object> get props => [error ?? ''];
}
