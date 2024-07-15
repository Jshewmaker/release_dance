import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(CheckoutInitial()) {
    on<CheckoutStarted>(_onCheckOut);
    on<CheckoutFinished>(_onCheckOutFinished);
  }

  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onCheckOut(
      CheckoutStarted event, Emitter<CheckoutState> emit) async {
    emit(CheckoutCourseLoading());
    try {
      final course = await _releaseProfileRepository.getSingleClass(
        event.classId,
        event.date,
      );
      emit(CheckoutCourseLoaded(releaseClass: course));
    } catch (e) {
      emit(CheckoutError(e));
    }
  }

  Future<void> _onCheckOutFinished(
      CheckoutFinished event, Emitter<CheckoutState> emit) async {
    emit(CheckoutCourseLoading());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      await _releaseProfileRepository.enrollInClass(
        event.classId,
        event.duration,
      );
      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutError(e));
    }
  }
}
