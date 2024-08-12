part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

final class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.initial, this.user});
  final HomeStatus status;
  final ReleaseUser? user;

  HomeState copyWith({
    HomeStatus? status,
    ReleaseUser? user,
  }) {
    return HomeState(
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
