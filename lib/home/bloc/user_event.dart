part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserRequested extends UserEvent {}

final class UserUpdated extends UserEvent {
  const UserUpdated(this.user);
  final ReleaseUser user;
  @override
  List<Object> get props => [user];
}
