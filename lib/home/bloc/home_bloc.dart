import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(HomeInitial()) {
    on<UserRequested>(_onUserRequested);
  }
  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onUserRequested(
    UserRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final user = await _releaseProfileRepository.getUserProfile();
      emit(HomeLoaded(user));
    } catch (e) {
      emit(HomeError(e));
    }
  }
}
