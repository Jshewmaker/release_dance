part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  const HomeLoaded(this.user);
  final ReleaseUser user;

  @override
  List<Object> get props => [user];
}

final class HomeError extends HomeState {
  const HomeError(this.error);
  final Object error;

  @override
  List<Object> get props => [error];
}
