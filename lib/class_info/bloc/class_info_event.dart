part of 'class_info_bloc.dart';

sealed class ClassInfoEvent extends Equatable {
  const ClassInfoEvent();

  @override
  List<Object> get props => [];
}

class ClassInfoRequested extends ClassInfoEvent {
  const ClassInfoRequested(this.classId);

  final String classId;

  @override
  List<Object> get props => [classId];
}
