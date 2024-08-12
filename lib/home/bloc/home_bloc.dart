import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(const HomeState()) {
    on<UserRequested>(_onUserRequested);
  }
  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onUserRequested(
    UserRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final user = await _releaseProfileRepository.getUserProfile();
      emit(state.copyWith(user: user, status: HomeStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }
}
