// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/onboarding/onboarding.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('OnboardingPage', () {
    test('pageBuilder returns an OnboardingPage', () {
      expect(
        OnboardingPage.pageBuilder(null, null),
        isA<OnboardingPage>(),
      );
    });

    testWidgets('renders OnboardingWelcome by default', (tester) async {
      await tester.pumpApp(const OnboardingPage());
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingWelcome), findsOneWidget);
    });
  });

  group('OnboardingWelcome', () {
    testWidgets(
        'updates to state to welcomeComplete '
        'when next is pressed', (tester) async {
      final controller = FakeFlowController<OnboardingState>(
        OnboardingState.initial,
      );
      await tester.pumpApp(
        FlowBuilder(
          controller: controller,
          onGeneratePages: (_, __) => [OnboardingWelcome.page()],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));

      expect(controller.state, equals(OnboardingState.welcomeComplete));
    });
  });

  group('OnboardingFeatures', () {
    testWidgets(
        'updates to state to featuresComplete '
        'when next is pressed', (tester) async {
      final controller = FakeFlowController<OnboardingState>(
        OnboardingState.initial,
      );
      await tester.pumpApp(
        FlowBuilder(
          controller: controller,
          onGeneratePages: (_, __) => [OnboardingFeatures.page()],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));

      expect(controller.state, equals(OnboardingState.featuresComplete));
    });
  });

  group('OnboardingSummary', () {
    testWidgets(
        'adds AppOnboardingCompleted '
        'when next is pressed', (tester) async {
      final appBloc = _MockAppBloc();
      await tester.pumpApp(
        BlocProvider<AppBloc>.value(
          value: appBloc,
          child: const OnboardingSummary(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));

      verify(() => appBloc.add(const AppOnboardingCompleted())).called(1);
    });
  });
}
