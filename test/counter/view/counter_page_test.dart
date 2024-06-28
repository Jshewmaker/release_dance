// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app_store_review/app_store_review.dart';
import 'package:release_dance/home/home.dart';
import 'package:release_dance/settings/settings.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockAppStoreReviewBloc
    extends MockBloc<AppStoreReviewEvent, AppStoreReviewState>
    implements AppStoreReviewBloc {}

class _MockCounterBloc extends MockBloc<CounterEvent, int>
    implements CounterBloc {}

class _MockUser extends Mock implements User {}

void main() {
  late AppBloc appBloc;
  late AppStoreReviewBloc appStoreReviewBloc;
  late User user;

  setUp(() {
    appBloc = _MockAppBloc();
    appStoreReviewBloc = _MockAppStoreReviewBloc();
    user = _MockUser();
    when(() => user.email).thenReturn('test@gmail.com');
    when(() => appBloc.state).thenReturn(AppState.authenticated(user));
  });
  group('CounterPage', () {
    test('pageBuilder returns a CounterPage', () {
      expect(HomePage.pageBuilder(null, null), isA<HomePage>());
    });

    testWidgets('renders CounterView', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('CounterView', () {
    const settingsKey = Key('counterPage_settings_iconButton');
    const inAppReviewButtonKey = Key('counterPage_inAppReview_iconButton');
    const logoutButtonKey = Key('counterPage_logout_iconButton');
    const deleteAccountButtonKey = Key('counterPage_deleteAccount_iconButton');
    const incrementButtonKey = Key('counterView_increment_counterButton');
    const decrementButtonKey = Key('counterView_decrement_counterButton');

    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = _MockCounterBloc();
    });

    testWidgets('renders current count', (tester) async {
      const state = 42;
      when(() => counterBloc.state).thenReturn(state);
      when(() => appStoreReviewBloc.state).thenReturn(
        AppStoreReviewState.initial,
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: counterBloc),
            BlocProvider.value(value: appStoreReviewBloc),
          ],
          child: const HomeView(),
        ),
      );
      expect(find.text('$state'), findsOneWidget);
    });

    testWidgets('adds increment when increment button is tapped',
        (tester) async {
      when(() => counterBloc.state).thenReturn(0);
      when(() => appStoreReviewBloc.state).thenReturn(
        AppStoreReviewState.initial,
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: counterBloc),
            BlocProvider.value(value: appStoreReviewBloc),
          ],
          child: const HomeView(),
        ),
      );
      await tester.tap(find.byKey(incrementButtonKey));
      verify(() => counterBloc.add(CounterEvent.increment)).called(1);
    });

    testWidgets('adds decrement when decrement button is tapped',
        (tester) async {
      when(() => counterBloc.state).thenReturn(0);
      when(() => appStoreReviewBloc.state).thenReturn(
        AppStoreReviewState.initial,
      );
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: counterBloc),
            BlocProvider.value(value: appStoreReviewBloc),
          ],
          child: const HomeView(),
        ),
      );
      await tester.tap(find.byKey(decrementButtonKey));
      verify(() => counterBloc.add(CounterEvent.decrement)).called(1);
    });

    testWidgets('adds AppLogoutRequested when logout is pressed',
        (tester) async {
      await tester.pumpApp(const HomePage(), appBloc: appBloc);
      await tester.tap(find.byKey(logoutButtonKey));
      verify(() => appBloc.add(const AppLogoutRequested())).called(1);
    });

    testWidgets(
        'adds AppUserAccountDeleted when deleteAccount button is pressed',
        (tester) async {
      await tester.pumpApp(const HomePage(), appBloc: appBloc);
      await tester.tap(find.byKey(deleteAccountButtonKey));
      verify(() => appBloc.add(const AppUserAccountDeleted())).called(1);
    });

    testWidgets(
      'adds AppStoreReviewRequested when in app review is pressed',
      (tester) async {
        when(() => counterBloc.state).thenReturn(0);
        when(() => appStoreReviewBloc.state).thenReturn(
          AppStoreReviewState.initial,
        );
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: counterBloc),
              BlocProvider.value(value: appStoreReviewBloc),
            ],
            child: const HomeView(),
          ),
          appBloc: appBloc,
        );
        await tester.tap(find.byKey(inAppReviewButtonKey));
        verify(
          () => appStoreReviewBloc.add(const AppStoreReviewRequested()),
        ).called(1);
      },
    );

    testWidgets('navigates to SettingsPage when settings is pressed',
        (tester) async {
      final goRouter = MockGoRouter();
      await tester.pumpApp(
        const HomePage(),
        appBloc: appBloc,
        goRouter: goRouter,
      );
      await tester.tap(find.byKey(settingsKey));
      verify(() => goRouter.goNamed(SettingsPage.routeName)).called(1);
    });

    testWidgets(
      'shows SnackBar when AppStoreReview is unavailable',
      (tester) async {
        when(() => counterBloc.state).thenReturn(0);
        whenListen(
          appStoreReviewBloc,
          Stream.fromIterable(const <AppStoreReviewState>[
            AppStoreReviewState.availabilityCheckInProgress,
            AppStoreReviewState.unavailable,
          ]),
          initialState: AppStoreReviewState.initial,
        );
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: counterBloc),
              BlocProvider.value(value: appStoreReviewBloc),
            ],
            child: const HomeView(),
          ),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );
  });
}
