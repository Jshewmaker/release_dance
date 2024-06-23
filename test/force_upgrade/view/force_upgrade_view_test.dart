// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_config_repository/app_config_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('ForceUpgradeView', () {
    const forceUpgradeUrl = 'https://verygood.ventures';
    late AppBloc appBloc;

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      appBloc = _MockAppBloc();
      when(() => appBloc.state).thenReturn(
        const AppState.forceUpgradeRequired(
          ForceUpgrade(
            upgradeUrl: forceUpgradeUrl,
            isUpgradeRequired: true,
          ),
        ),
      );
    });

    testWidgets('renders a ForceUpgradeCard', (tester) async {
      await tester.pumpApp(
        const ForceUpgradeView(),
        appBloc: appBloc,
      );
      expect(find.byType(ForceUpgradeCard), findsOneWidget);
    });

    testWidgets('renders a AppStoreButton', (tester) async {
      await tester.pumpApp(
        const ForceUpgradeView(),
        appBloc: appBloc,
      );
      expect(find.byType(AppStoreButton), findsOneWidget);
    });

    testWidgets('launches upgrade url when AppStoreButton is tapped',
        (tester) async {
      final mock = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mock;
      when(() => mock.launchUrl(any(), any())).thenAnswer((_) async => true);
      await tester.pumpApp(
        const ForceUpgradeView(),
        appBloc: appBloc,
      );
      await tester.tap(find.byType(AppStoreButton));
      verify(() => mock.launchUrl(any(), any())).called(1);
    });

    testWidgets('contains PopScope which prevents pops', (tester) async {
      await tester.pumpApp(
        const ForceUpgradeView(),
        appBloc: appBloc,
      );
      final popScope = tester.findWidgetByType<PopScope>();
      expect(popScope.onPopInvoked, isNull);
    });
  });
}
