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

class EnrolledInDropIn extends CheckoutEvent {
  const EnrolledInDropIn({
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
