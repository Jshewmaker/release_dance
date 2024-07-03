part of 'class_bloc.dart';

sealed class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [];
}

final class ClassesInitial extends ClassState {}

final class ClassesLoading extends ClassState {}

final class ClassesLoaded extends ClassState {
  const ClassesLoaded(this.classes);

  final List<ReleaseClass> classes;

  @override
  List<Object> get props => [classes];
}

final class ClassesError extends ClassState {
  const ClassesError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
