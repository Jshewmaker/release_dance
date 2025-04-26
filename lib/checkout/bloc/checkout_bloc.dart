import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(const CheckoutState()) {
    on<CheckoutEventStarted>(_onCheckOut);
    // on<CheckoutEventEnrolledInDropIn>(_onCheckOutFinished);
    on<CheckoutQuantityChanged>(_onQuantityChanged);
    on<CheckoutPaymentStarted>(_onPaymentStarted);
  }

  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onCheckOut(
    CheckoutEventStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CheckoutStatus.loading,
        isProcessing: false,
        paymentError: null,
      ),
    );
    try {
      final course = await _releaseProfileRepository.getSingleClass(
        event.classId,
        event.date,
      );
      emit(state.copyWith(releaseClass: course, status: CheckoutStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: CheckoutStatus.error));
    }
  }

  // Future<void> _onCheckOutFinished(
  //   CheckoutEventEnrolledInDropIn event,
  //   Emitter<CheckoutState> emit,
  // ) async {
  //   emit(state.copyWith(isProcessing: true, paymentError: null));
  //   try {
  //     await Future<void>.delayed(const Duration(seconds: 1));
  //     await _releaseProfileRepository.enrollInClass(
  //       event.classId,
  //       event.dropInsUsed,
  //     );
  //     emit(CheckoutSuccess());
  //   } catch (e) {
  //     emit(CheckoutError(e));
  //   }
  // }

  void _onQuantityChanged(
    CheckoutQuantityChanged event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(quantity: event.quantity, paymentError: null));
  }

  Future<void> _onPaymentStarted(
    CheckoutPaymentStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true, paymentError: null));
    // Simulate payment delay
    try {
      await _releaseProfileRepository.buyDropIns(event.numberOfClassesBought);
      await Future<void>.delayed(const Duration(seconds: 2));
      // For now, always succeed
      emit(state.copyWith(status: CheckoutStatus.success));
    } on Exception catch (e) {
      emit(state.copyWith(isProcessing: false, paymentError: e.toString()));
    }
  }
}
