part of 'user_bloc.dart';

enum UserStatus { initial, loading, loaded, error }

final class UserState extends Equatable {
  const UserState({this.status = UserStatus.initial, this.user});
  final UserStatus status;
  final ReleaseUser? user;

  UserState copyWith({
    UserStatus? status,
    ReleaseUser? user,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
      ];
}
