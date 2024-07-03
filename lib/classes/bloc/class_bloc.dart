import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  ClassBloc({required ReleaseProfileRepository releaseProfileRepository})
      : _releaseProfileRepository = releaseProfileRepository,
        super(ClassesInitial()) {
    on<ClassesFetched>(_onGetClasses);
  }
  final ReleaseProfileRepository _releaseProfileRepository;

  Future<void> _onGetClasses(
    ClassesFetched event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassesLoading());
    try {
      final classes = await _releaseProfileRepository.getClasses('2024-07-02');
      emit(ClassesLoaded(classes));
    } catch (e) {
      emit(ClassesError(e.toString()));
    }
  }
}
