// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:app_config_repository/app_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:user_repository/user_repository.dart';

class _MockUser extends Mock implements User {}

void main() {
  group('AppState', () {
    group('downForMaintenance', () {
      test('has correct status', () {
        final state = AppState.downForMaintenance();
        expect(state.status, AppStatus.downForMaintenance);
        expect(state.user, User.unauthenticated);
      });
    });

    group('forceUpgradeRequired', () {
      test('has correct status', () {
        final state = AppState.forceUpgradeRequired(
          ForceUpgrade(isUpgradeRequired: false),
        );
        expect(state.status, AppStatus.forceUpgradeRequired);
        expect(state.user, User.unauthenticated);
      });
    });

    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, User.unauthenticated);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final user = _MockUser();
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });

    group('onboardingRequired', () {
      test('has correct status', () {
        final user = _MockUser();
        final state = AppState.onboardingRequired(user);
        expect(state.status, AppStatus.onboardingRequired);
        expect(state.user, user);
      });
    });
  });
}
