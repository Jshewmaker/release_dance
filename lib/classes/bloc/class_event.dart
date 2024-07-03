part of 'class_bloc.dart';

sealed class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object> get props => [];
}

final class ClassesFetched extends ClassEvent {}
