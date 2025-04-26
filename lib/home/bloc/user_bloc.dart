import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(const UserState()) {
    on<UserRequested>(_onUserRequested);
    on<UserUpdated>(_onUserUpdated);
  }
  final ReleaseProfileRepository _releaseProfileRepository;
  StreamSubscription<ReleaseUser>? _userSubscription;
  void _onUserRequested(
    UserRequested event,
    Emitter<UserState> emit,
  ) {
    emit(state.copyWith(status: UserStatus.loading));
    _userSubscription?.cancel();
    try {
      _userSubscription = _releaseProfileRepository
          .getUserProfile()
          .listen((event) => add(UserUpdated(event)))
        ..onError((error) {
          emit(state.copyWith(status: UserStatus.error));
        });
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error));
    }
  }

  Future<void> _onUserUpdated(
    UserUpdated event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(user: event.user, status: UserStatus.loaded));
  }
}
