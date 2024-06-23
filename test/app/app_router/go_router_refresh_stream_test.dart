// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors, invalid_use_of_protected_member
import 'dart:async';

import 'package:app_config_repository/app_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app/app_router/go_router_refresh_stream.dart';
import 'package:user_repository/user_repository.dart';

class _MockUser extends Mock implements User {}

void main() {
  group('GoRouterRefreshStream', () {
    late StreamController<AppState> controller;
    late GoRouterRefreshStream routerRefreshStream;
    late User user;

    setUp(() {
      user = _MockUser();
      controller = StreamController<AppState>();
      routerRefreshStream = GoRouterRefreshStream(controller.stream);
    });

    test('status changes through all the status', () async {
      var updatedTimes = 0;
      routerRefreshStream.addListener(() {
        updatedTimes++;
      });

      controller
        ..add(AppState.unauthenticated())
        ..add(AppState.authenticated(user))
        ..add(AppState.onboardingRequired(user))
        ..add(
          AppState.forceUpgradeRequired(
            ForceUpgrade(isUpgradeRequired: true, upgradeUrl: ''),
          ),
        )
        ..add(AppState.downForMaintenance());

      await Future<void>.delayed(Duration.zero);

      expect(updatedTimes, equals(5));
    });

    test('dispose', () {
      routerRefreshStream
        ..notifyListeners()
        ..dispose();

      expect(
        routerRefreshStream.notifyListeners,
        throwsFlutterError,
      );
      expect(routerRefreshStream.hasListeners, isFalse);
    });
  });
}
