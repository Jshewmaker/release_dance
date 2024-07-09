part of 'class_info_bloc.dart';

sealed class ClassInfoState extends Equatable {
  const ClassInfoState();

  @override
  List<Object> get props => [];
}

final class ClassInfoInitial extends ClassInfoState {}

final class ClassInfoLoading extends ClassInfoState {}

final class ClassInfoLoaded extends ClassInfoState {
  const ClassInfoLoaded(this.classInfo);

  final ClassInfo classInfo;

  @override
  List<Object> get props => [classInfo];
}

final class ClassInfoError extends ClassInfoState {
  const ClassInfoError(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}
