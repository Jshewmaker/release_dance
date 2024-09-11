part of 'class_info_bloc.dart';

sealed class ClassInfoEvent extends Equatable {
  const ClassInfoEvent();

  @override
  List<Object> get props => [];
}

class ClassInfoRequested extends ClassInfoEvent {
  const ClassInfoRequested(this.classId, this.date);

  final String classId;
  final String date;

  @override
  List<Object> get props => [
        classId,
        date,
      ];
}

class DropInRedeemed extends ClassInfoEvent {
  const DropInRedeemed(this.classId);

  final String classId;

  @override
  List<Object> get props => [classId];
}

class CourseSignUp extends ClassInfoEvent {
  const CourseSignUp(this.classId);

  final String classId;

  @override
  List<Object> get props => [classId];
}
