import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(CheckoutInitial()) {
    on<CheckoutEventStarted>(_onCheckOut);
    on<CheckoutEventEnrolledInDropIn>(_onCheckOutFinished);
    on<CheckoutEventBoughtDropIns>(_onDropInPackageBought);
  }

  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onCheckOut(
    CheckoutEventStarted event,
    Emitter<CheckoutState> emit,
  ) async {
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
    CheckoutEventEnrolledInDropIn event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutCourseLoading());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      await _releaseProfileRepository.enrollInClass(
        event.classId,
        event.dropInsUsed,
      );
      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutError(e));
    }
  }

  Future<void> _onDropInPackageBought(
    CheckoutEventBoughtDropIns event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutCourseLoading());
    try {
      await _releaseProfileRepository.buyDropIns(event.numberOfClassesBought);
      emit(CheckoutSuccess());
    } catch (e) {
      emit(CheckoutError(e));
    }
  }
}
