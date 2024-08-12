part of 'class_info_bloc.dart';

enum ClassInfoStatus {
  initial,
  loading,
  loaded,
  redeemed,
  error,
}

final class ClassInfoState extends Equatable {
  const ClassInfoState({
    this.classInfo,
    this.status = ClassInfoStatus.initial,
  });

  final ClassInfoStatus status;
  final ClassInfo? classInfo;

  ClassInfoState copyWith({
    ClassInfoStatus? status,
    ClassInfo? classInfo,
  }) {
    return ClassInfoState(
      status: status ?? this.status,
      classInfo: classInfo ?? this.classInfo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        classInfo,
      ];
}
