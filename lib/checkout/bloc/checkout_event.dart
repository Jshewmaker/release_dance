part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted({
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

class CheckoutFinished extends CheckoutEvent {
  const CheckoutFinished({
    required this.classId,
    required this.total,
    required this.duration,
  });

  final String classId;
  final double total;
  final int duration;

  @override
  List<Object> get props => [
        classId,
        total,
        duration,
      ];
}
