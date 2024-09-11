// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors

import 'package:app_config_repository/app_config_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app/app_router/app_route.dart';
import 'package:release_dance/app/app_router/app_router.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';
import 'package:release_dance/home/home.dart';
import 'package:release_dance/login/login.dart';
import 'package:release_dance/onboarding/onboarding.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockUser extends Mock implements User {}

class _MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  group('AppRouter', () {
    late AppBloc appBloc;
    late GlobalKey<NavigatorState> navigatorKey;
    late NotificationRepository notificationRepository;

    setUp(() {
      appBloc = _MockAppBloc();
      when(() => appBloc.state).thenReturn(AppState.unauthenticated());
      navigatorKey = GlobalKey();
      notificationRepository = _MockNotificationRepository();
    });

    test('can be instantiated', () {
      expect(
        AppRouter(
          appBloc: appBloc,
          navigatorKey: navigatorKey,
          openedNotificationsStream: notificationRepository.openedNotifications,
        ),
        isNotNull,
      );
    });

    test('can get routes', () {
      expect(
        AppRouter(
          appBloc: appBloc,
          navigatorKey: navigatorKey,
          openedNotificationsStream: notificationRepository.openedNotifications,
        ).routes,
        isNotNull,
      );
    });

    group('redirects', () {
      @isTestGroup
      void testRedirect(
        String description,
        AppState state,
        AppState previousState,
        Type type,
      ) {
        group(description, () {
          testWidgets('when initial status is ${state.status}', (tester) async {
            when(() => appBloc.state).thenReturn(state);
            await tester.pumpApp(
              AppView(),
              appBloc: appBloc,
            );
            expect(find.byType(type), findsOneWidget);
          });

          testWidgets('when status changes to ${state.status}', (tester) async {
            whenListen(
              appBloc,
              Stream.fromIterable([previousState, state]),
              initialState: previousState,
            );
            await tester.pumpApp(
              AppView(),
              appBloc: appBloc,
            );
            expect(find.byType(type), findsOneWidget);
          });

          testWidgets('when attempting to navigate to a different page',
              (tester) async {
            when(() => appBloc.state).thenReturn(state);
            await tester.pumpApp(
              AppView(),
              appBloc: appBloc,
            );
            tester.go(previousState.status.route);
            await tester.pumpAndSettle();
            expect(find.byType(type), findsOneWidget);
          });

          testWidgets('when navigating to an unknown route', (tester) async {
            when(() => appBloc.state).thenReturn(state);
            await tester.pumpApp(
              AppView(),
              appBloc: appBloc,
            );
            tester.go('unknown-route-12345');
            await tester.pumpAndSettle();
            expect(find.byType(type), findsOneWidget);
          });
        });
      }

      testRedirect(
        'to LoginPage',
        AppState.unauthenticated(),
        AppState.authenticated(_MockUser()),
        LoginPage,
      );

      testRedirect(
        'to OnboardingPage',
        AppState.onboardingRequired(_MockUser()),
        AppState.unauthenticated(),
        OnboardingPage,
      );

      testRedirect(
        'to CounterPage',
        AppState.authenticated(_MockUser()),
        AppState.unauthenticated(),
        HomePage,
      );

      testRedirect(
        'to DownForMaintenancePage',
        AppState.downForMaintenance(),
        AppState.unauthenticated(),
        DownForMaintenancePage,
      );

      testRedirect(
        'to ForceUpgradePage',
        AppState.forceUpgradeRequired(
          ForceUpgrade(isUpgradeRequired: true, upgradeUrl: ''),
        ),
        AppState.unauthenticated(),
        ForceUpgradePage,
      );
    });
  });
}

extension on WidgetTester {
  void go(String routeName) {
    final app = widget<MaterialApp>(
      find.descendant(
        of: find.byType(AppView),
        matching: find.byType(MaterialApp),
      ),
    );
    (app.routerConfig! as GoRouter).go(routeName);
  }
}
