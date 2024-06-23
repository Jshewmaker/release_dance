// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_config_repository/app_config_repository.dart';
import 'package:app_support_repository/app_support_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app_store_review/app_store_review.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_dance/theme_selector/theme_selector.dart';
import 'package:user_repository/user_repository.dart';

import 'go_router.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {
  @override
  AppState get state => const AppState.unauthenticated();
}

class MockAppStoreReviewBloc
    extends MockBloc<AppStoreReviewEvent, AppStoreReviewState>
    implements AppStoreReviewBloc {
  @override
  AppStoreReviewState get state => AppStoreReviewState.initial;
}

class MockThemeModeBloc extends MockBloc<ThemeModeEvent, ThemeMode>
    implements ThemeModeBloc {
  @override
  ThemeMode get state => ThemeMode.system;
}

class MockUserRepository extends Mock implements UserRepository {}

class MockAppConfigRepository extends Mock implements AppConfigRepository {}

class MockAppSupportRepository extends Mock implements AppSupportRepository {}

class MockConnectivityRepository extends Mock
    implements ConnectivityRepository {
  @override
  Stream<ConnectivityStatus> get onConnectivityChanged => const Stream.empty();

  @override
  Future<ConnectivityStatus> connectivityStatus() async {
    return ConnectivityStatus.online;
  }
}

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    AppConfigRepository? appConfigRepository,
    AppSupportRepository? appSupportRepository,
    AppBloc? appBloc,
    ConnectivityRepository? connectivityRepository,
    UserRepository? userRepository,
    TargetPlatform? platform,
    ThemeModeBloc? themeModeBloc,
    GoRouter? goRouter,
  }) async {
    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: appConfigRepository ?? MockAppConfigRepository(),
          ),
          RepositoryProvider.value(
            value: appSupportRepository ?? MockAppSupportRepository(),
          ),
          RepositoryProvider.value(
            value: connectivityRepository ?? MockConnectivityRepository(),
          ),
          RepositoryProvider.value(
            value: userRepository ?? MockUserRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc ?? MockAppBloc()),
            BlocProvider.value(value: themeModeBloc ?? MockThemeModeBloc()),
          ],
          child: MockGoRouterProvider(
            goRouter: goRouter ?? MockGoRouter(),
            child: MaterialApp(
              title: 'Release',
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: Theme(
                data: ThemeData(platform: platform),
                child: Scaffold(body: widgetUnderTest),
              ),
            ),
          ),
        ),
      ),
    );
    await pump();
  }
}
