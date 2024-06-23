// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/counter/counter.dart';

void main() {
  group('CounterBloc', () {
    test('initial state is 0', () {
      expect(CounterBloc().state, equals(0));
    });

    blocTest<CounterBloc, int>(
      'emits [1] when increment is added',
      build: CounterBloc.new,
      act: (bloc) => bloc.add(CounterEvent.increment),
      expect: () => [equals(1)],
    );

    blocTest<CounterBloc, int>(
      'emits [-1] when decrement is added',
      build: CounterBloc.new,
      act: (bloc) => bloc.add(CounterEvent.decrement),
      expect: () => [equals(-1)],
    );
  });
}
