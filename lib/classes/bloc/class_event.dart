part of 'class_bloc.dart';

sealed class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object> get props => [];
}

final class ClassesFetched extends ClassEvent {
  const ClassesFetched({required this.date});

  final String date;

  @override
  List<Object> get props => [date];
}
