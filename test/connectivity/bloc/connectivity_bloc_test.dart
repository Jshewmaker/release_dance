// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/connectivity/connectivity.dart';

class _MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

void main() {
  group('ConnectivityBloc', () {
    late ConnectivityRepository connectivityRepository;

    setUp(() {
      connectivityRepository = _MockConnectivityRepository();
      when(() => connectivityRepository.onConnectivityChanged).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    test('initial state is unknown', () {
      expect(
        ConnectivityBloc(connectivityRepository: connectivityRepository).state,
        equals(ConnectivityState.unknown),
      );
    });

    group('ConnectivityStatusChanged', () {
      blocTest<ConnectivityBloc, ConnectivityState>(
        'updates ConnectivityState',
        setUp: () {
          when(() => connectivityRepository.onConnectivityChanged).thenAnswer(
            (_) => Stream.value(ConnectivityStatus.online),
          );
        },
        build: () => ConnectivityBloc(
          connectivityRepository: connectivityRepository,
        ),
        expect: () => const <ConnectivityState>[ConnectivityState.online],
      );
    });

    group('ConnectivityStatusRequested', () {
      blocTest<ConnectivityBloc, ConnectivityState>(
        'updates ConnectivityState to online on successful query',
        setUp: () {
          when(() => connectivityRepository.connectivityStatus()).thenAnswer(
            (_) async => ConnectivityStatus.online,
          );
        },
        build: () => ConnectivityBloc(
          connectivityRepository: connectivityRepository,
        ),
        act: (bloc) => bloc.add(ConnectivityRequested()),
        expect: () => const <ConnectivityState>[ConnectivityState.online],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'updates ConnectivityState to offline on successful query',
        setUp: () {
          when(() => connectivityRepository.connectivityStatus()).thenAnswer(
            (_) async => ConnectivityStatus.offline,
          );
        },
        build: () => ConnectivityBloc(
          connectivityRepository: connectivityRepository,
        ),
        act: (bloc) => bloc.add(ConnectivityRequested()),
        expect: () => const <ConnectivityState>[ConnectivityState.offline],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'updates ConnectivityState to unknown on unsuccessful query',
        setUp: () {
          when(() => connectivityRepository.connectivityStatus()).thenThrow(
            Exception(),
          );
        },
        build: () => ConnectivityBloc(
          connectivityRepository: connectivityRepository,
        ),
        act: (bloc) => bloc.add(ConnectivityRequested()),
        expect: () => const <ConnectivityState>[ConnectivityState.unknown],
        errors: () => [isA<Exception>()],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'calls currentConnectivityStatus',
        build: () => ConnectivityBloc(
          connectivityRepository: connectivityRepository,
        ),
        seed: () => ConnectivityState.online,
        act: (bloc) => bloc.add(ConnectivityRequested()),
        verify: (_) {
          verify(() => connectivityRepository.connectivityStatus()).called(1);
        },
      );
    });
  });
}
