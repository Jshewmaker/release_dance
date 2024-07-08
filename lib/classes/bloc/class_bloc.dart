import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  ClassBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(const ClassState()) {
    on<ClassesFetched>(_onGetClasses);
  }
  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onGetClasses(
    ClassesFetched event,
    Emitter<ClassState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ClassStatus.loading));
      final classes = await _releaseProfileRepository.getClasses(event.date);
      emit(state.copyWith(classes: classes, status: ClassStatus.loaded));
    } catch (e) {
      emit(const ClassState(status: ClassStatus.error));
    }
  }
}
