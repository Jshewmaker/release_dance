// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectivityRepository', () {
    late Connectivity connectivity;
    late ConnectivityRepository connectivityRepository;

    setUp(() {
      connectivity = _MockConnectivity();
      connectivityRepository =
          ConnectivityRepository(connectivity: connectivity);
    });

    test('creates Connectivity instance internally when not injected', () {
      expect(ConnectivityRepository.new, isNot(throwsException));
    });

    group('onConnectivityChanged', () {
      setUp(() {
        when(
          () => connectivity.onConnectivityChanged,
        ).thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));
      });

      test('calls onConnectivityChanged', () async {
        connectivityRepository.onConnectivityChanged;
        verify(() => connectivity.onConnectivityChanged).called(1);
      });
    });

    group('connectivityStatus', () {
      setUp(() {
        when(
          () => connectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);
      });

      test('calls checkConnectivity', () {
        connectivityRepository.connectivityStatus();
        verify(() => connectivity.checkConnectivity()).called(1);
      });
    });

    group('getStatusFromResult', () {
      test('ConnectivityResult maps to ConnectivityStatus', () {
        final controller =
            StreamController<List<ConnectivityResult>>(sync: true);
        when(
          () => connectivity.onConnectivityChanged,
        ).thenAnswer((_) => controller.stream);

        final actual = <ConnectivityStatus>[];
        final expected = [
          ConnectivityStatus.online,
          ConnectivityStatus.online,
          ConnectivityStatus.online,
          ConnectivityStatus.offline,
          ConnectivityStatus.offline,
          ConnectivityStatus.offline,
          ConnectivityStatus.online,
        ];

        final subscription =
            connectivityRepository.onConnectivityChanged.listen(actual.add);

        controller
          ..add([ConnectivityResult.wifi])
          ..add([ConnectivityResult.mobile])
          ..add([ConnectivityResult.ethernet])
          ..add([ConnectivityResult.bluetooth])
          ..add([ConnectivityResult.other])
          ..add([ConnectivityResult.none])
          ..add([ConnectivityResult.bluetooth, ConnectivityResult.wifi]);

        expect(actual, equals(expected));
        subscription.cancel();
        controller.close();
      });
    });
  });
}
