import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(const UserState()) {
    on<UserRequested>(_onUserRequested);
  }
  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onUserRequested(
    UserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = await _releaseProfileRepository.getUserProfile();
      emit(state.copyWith(user: user, status: UserStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.error));
    }
  }
}
