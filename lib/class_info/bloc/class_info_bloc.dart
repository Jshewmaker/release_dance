import 'package:bloc/bloc.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'class_info_event.dart';
part 'class_info_state.dart';

class ClassInfoBloc extends Bloc<ClassInfoEvent, ClassInfoState> {
  ClassInfoBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(const ClassInfoState()) {
    on<ClassInfoRequested>(_onClassInfoRequested);
    on<DropInRedeemed>(_dropInRedeemed);
    on<CourseSignUp>(_courseSignUp);
  }

  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onClassInfoRequested(
    ClassInfoRequested event,
    Emitter<ClassInfoState> emit,
  ) async {
    emit(state.copyWith(status: ClassInfoStatus.loading));
    try {
      final classInfo =
          await _releaseProfileRepository.getClassInfo(event.classId);

      emit(
        state.copyWith(classInfo: classInfo, status: ClassInfoStatus.loaded),
      );
    } catch (e) {
      emit(state.copyWith(status: ClassInfoStatus.error));
    }
  }

  Future<void> _dropInRedeemed(
    DropInRedeemed event,
    Emitter<ClassInfoState> emit,
  ) async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      await _releaseProfileRepository.enrollInClass(event.classId, 1);
      emit(state.copyWith(status: ClassInfoStatus.redeemed));
    } catch (e) {
      emit(state.copyWith(status: ClassInfoStatus.error));
    }
  }

  Future<void> _courseSignUp(
    CourseSignUp event,
    Emitter<ClassInfoState> emit,
  ) async {
    emit(state.copyWith(status: ClassInfoStatus.loading));
    try {
      await _releaseProfileRepository.enrollInCourse(event.classId);
      emit(state.copyWith(status: ClassInfoStatus.redeemed));
    } catch (e) {
      emit(state.copyWith(status: ClassInfoStatus.error));
    }
  }
}
