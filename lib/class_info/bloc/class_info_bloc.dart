import 'package:bloc/bloc.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'class_info_event.dart';
part 'class_info_state.dart';

class ClassInfoBloc extends Bloc<ClassInfoEvent, ClassInfoState> {
  ClassInfoBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(ClassInfoInitial()) {
    on<ClassInfoRequested>(_onClassInfoRequested);
  }

  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onClassInfoRequested(
    ClassInfoRequested event,
    Emitter<ClassInfoState> emit,
  ) async {
    emit(ClassInfoLoading());
    try {
      emit(ClassInfoLoading());
      final classInfo =
          await _releaseProfileRepository.getClassInfo(event.classId);
      emit(ClassInfoLoaded(classInfo));
    } catch (e) {
      emit(ClassInfoError(e));
    }
  }
}
