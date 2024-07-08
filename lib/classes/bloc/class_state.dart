part of 'class_bloc.dart';

enum ClassStatus { initial, loading, loaded, error }

final class ClassState extends Equatable {
  const ClassState({
    this.status = ClassStatus.initial,
    this.classes = const <ReleaseClass>[],
  });
  final ClassStatus status;
  final List<ReleaseClass> classes;

  ClassState copyWith({
    ClassStatus? status,
    List<ReleaseClass>? classes,
  }) {
    return ClassState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
    );
  }

  @override
  List<Object> get props => [status, classes];
}
