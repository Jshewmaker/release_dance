// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:app_config_repository/app_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:user_repository/user_repository.dart';

class _MockUser extends Mock implements User {}

void main() {
  group('AppEvent', () {
    group('AppForceUpgradeStatusChanged', () {
      final forceUpgrade = ForceUpgrade(isUpgradeRequired: false);
      test('supports value comparisons', () {
        expect(
          AppForceUpgradeStatusChanged(forceUpgrade),
          AppForceUpgradeStatusChanged(forceUpgrade),
        );
      });
    });

    group('AppDownForMaintenanceStatusChanged', () {
      test('supports value comparisons', () {
        expect(
          AppDownForMaintenanceStatusChanged(),
          AppDownForMaintenanceStatusChanged(),
        );
      });
    });

    group('AppUserChanged', () {
      final user = _MockUser();
      test('supports value comparisons', () {
        expect(
          AppUserChanged(user),
          AppUserChanged(user),
        );
      });
    });

    group('AppOnboardingCompleted', () {
      test('supports value comparisons', () {
        expect(
          AppOnboardingCompleted(),
          AppOnboardingCompleted(),
        );
      });
    });

    group('AppLogoutRequested', () {
      test('supports value comparisons', () {
        expect(
          AppLogoutRequested(),
          AppLogoutRequested(),
        );
      });
    });

    group('AppUserAccountDeleted', () {
      test('supports value comparisons', () {
        expect(
          AppUserAccountDeleted(),
          AppUserAccountDeleted(),
        );
      });
    });
  });
}
