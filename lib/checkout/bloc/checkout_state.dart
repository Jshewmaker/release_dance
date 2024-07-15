part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutCourseLoading extends CheckoutState {}

final class CheckoutCourseLoaded extends CheckoutState {
  const CheckoutCourseLoaded({required this.releaseClass});

  final ReleaseClass releaseClass;

  @override
  List<Object> get props => [releaseClass];
}

final class CheckoutRegisteredLoading extends CheckoutState {}

final class CheckoutRegisteredLoaded extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {}

final class CheckoutError extends CheckoutState {
  const CheckoutError(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}
