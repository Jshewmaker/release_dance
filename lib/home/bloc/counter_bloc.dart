// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc/bloc.dart';

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      switch (event) {
        case CounterEvent.increment:
          return emit(state + 1);
        case CounterEvent.decrement:
          return emit(state - 1);
      }
    });
  }
}
