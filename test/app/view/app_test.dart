// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_config_repository/app_config_repository.dart';
import 'package:app_support_repository/app_support_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/counter/counter.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';
import 'package:release_dance/login/login.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

// ignore: must_be_immutable
class _MockUser extends Mock implements User {}

class _MockUserRepository extends Mock implements UserRepository {}

class _MockAppConfigRepository extends Mock implements AppConfigRepository {}

class _MockAppSupportRepository extends Mock implements AppSupportRepository {}

class _MockConnectivityRepository extends Mock
    implements ConnectivityRepository {}

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('App', () {
    late AppConfigRepository appConfigRepository;
    late AppSupportRepository appSupportRepository;
    late ConnectivityRepository connectivityRepository;
    late UserRepository userRepository;
    late User user;

    setUpAll(mockHydratedStorage);

    setUp(() {
      userRepository = _MockUserRepository();
      when(() => userRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      appConfigRepository = _MockAppConfigRepository();
      when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
        (_) => const Stream.empty(),
      );
      appSupportRepository = _MockAppSupportRepository();
      connectivityRepository = _MockConnectivityRepository();
      when(() => connectivityRepository.onConnectivityChanged).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => connectivityRepository.connectivityStatus()).thenAnswer(
        (_) async => ConnectivityStatus.online,
      );
      user = _MockUser();
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          appConfigRepository: appConfigRepository,
          appSupportRepository: appSupportRepository,
          connectivityRepository: connectivityRepository,
          userRepository: userRepository,
          user: user,
        ),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AppBloc appBloc;
    late AppSupportRepository appSupportRepository;
    late ConnectivityRepository connectivityRepository;
    late UserRepository userRepository;

    setUp(() {
      appBloc = _MockAppBloc();
      appSupportRepository = _MockAppSupportRepository();
      connectivityRepository = _MockConnectivityRepository();
      userRepository = _MockUserRepository();
      when(() => connectivityRepository.onConnectivityChanged).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => connectivityRepository.connectivityStatus()).thenAnswer(
        (_) async => ConnectivityStatus.online,
      );
    });

    testWidgets('navigates to DownForMaintenancePage when isDownForMaintenance',
        (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.downForMaintenance());
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(DownForMaintenancePage), findsOneWidget);
    });

    testWidgets('navigates to ForceUpgradePage when force upgrade is required',
        (tester) async {
      when(() => appBloc.state).thenReturn(
        const AppState.forceUpgradeRequired(
          ForceUpgrade(isUpgradeRequired: true, upgradeUrl: 'upgrade-url'),
        ),
      );
      await tester.pumpApp(const AppView(), appBloc: appBloc);
      await tester.pumpAndSettle();
      expect(find.byType(ForceUpgradePage), findsOneWidget);
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to CounterPage when authenticated', (tester) async {
      final user = _MockUser();
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        appSupportRepository: appSupportRepository,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
