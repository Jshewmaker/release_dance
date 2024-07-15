// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app/app_router/app_route.dart';
import 'package:release_dance/app/app_router/go_router_refresh_stream.dart';
import 'package:release_dance/app/app_router/scaffold_with_nested_navigation.dart';
import 'package:release_dance/checkout/checkout.dart';
import 'package:release_dance/class_info/view/class_info_page.dart';
import 'package:release_dance/classes/view/classes_page.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';
import 'package:release_dance/home/home.dart';
import 'package:release_dance/login/login.dart';
import 'package:release_dance/my_release/view/my_release_page.dart';
import 'package:release_dance/onboarding/onboarding.dart';
import 'package:release_dance/reset_password/reset_password.dart';
import 'package:release_dance/settings/settings.dart';
import 'package:release_dance/sign_up/sign_up.dart';

// private navigators
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'settings',
);
final _shellNavigatorYouKey = GlobalKey<NavigatorState>(debugLabel: 'you');
final _shellNavigatorEventKey = GlobalKey<NavigatorState>(debugLabel: 'event');

class AppRouter {
  AppRouter({
    required AppBloc appBloc,
    required GlobalKey<NavigatorState> navigatorKey,
    String? initialLocation = OnboardingPage.routeName,
    List<NavigatorObserver> navigatorObservers = const [],
  }) {
    _currentStatus = appBloc.state.status;
    _goRouter = _routes(
      initialLocation,
      navigatorObservers,
      appBloc,
      navigatorKey,
    );
  }

  late final GoRouter _goRouter;
  late AppStatus _currentStatus;

  GoRouter get routes => _goRouter;

  GoRouter _routes(
    String? initialLocation,
    List<NavigatorObserver> navigatorObservers,
    AppBloc appBloc,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return GoRouter(
      initialLocation: initialLocation,
      refreshListenable: GoRouterRefreshStream(appBloc.stream),
      observers: navigatorObservers,
      navigatorKey: navigatorKey,
      onException: (context, state, router) {
        router.go(_currentStatus.route);
      },
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNestedNavigation(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellNavigatorHomeKey,
              routes: [
                AppRoute(
                  name: HomePage.routeName,
                  path: HomePage.routeName,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: HomePage.routeName,
                    child: HomePage.pageBuilder(context, state),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorYouKey,
              routes: [
                AppRoute(
                  name: MyReleasePage.routeName,
                  path: MyReleasePage.routeName,
                  builder: MyReleasePage.pageBuilder,
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorEventKey,
              routes: [
                AppRoute(
                    name: ClassesPage.routeName,
                    path: ClassesPage.routeName,
                    builder: ClassesPage.pageBuilder,
                    routes: [
                      AppRoute(
                        name: ClassInfoPage.routeName,
                        path: ClassInfoPage.routePath,
                        pageBuilder: (context, state) => NoTransitionPage(
                          name: ClassInfoPage.routeName,
                          child: ClassInfoPage.pageBuilder(context, state),
                        ),
                        routes: [
                          AppRoute(
                            name: CheckoutPage.routeName,
                            path: CheckoutPage.routePath,
                            pageBuilder: (context, state) => NoTransitionPage(
                                child:
                                    CheckoutPage.pageBuilder(context, state)),
                          ),
                        ],
                      ),
                    ]),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorSettingsKey,
              routes: [
                AppRoute(
                  name: SettingsPage.routeName,
                  path: SettingsPage.routePath,
                  builder: SettingsPage.pageBuilder,
                ),
              ],
            ),
          ],
        ),
        AppRoute(
          name: OnboardingPage.routeName,
          path: OnboardingPage.routeName,
          appStatus: AppStatus.onboardingRequired,
          pageBuilder: (context, state) => NoTransitionPage(
            name: OnboardingPage.routeName,
            child: OnboardingPage.pageBuilder(context, state),
          ),
        ),
        AppRoute(
          name: DownForMaintenancePage.routeName,
          path: DownForMaintenancePage.routeName,
          appStatus: AppStatus.downForMaintenance,
          pageBuilder: (context, state) => NoTransitionPage(
            name: DownForMaintenancePage.routeName,
            child: DownForMaintenancePage.pageBuilder(context, state),
          ),
        ),
        AppRoute(
          name: ForceUpgradePage.routeName,
          path: ForceUpgradePage.routeName,
          appStatus: AppStatus.forceUpgradeRequired,
          pageBuilder: (context, state) => NoTransitionPage(
            name: ForceUpgradePage.routeName,
            child: ForceUpgradePage.pageBuilder(context, state),
          ),
        ),
        AppRoute(
          name: LoginPage.routeName,
          path: LoginPage.routeName,
          appStatus: AppStatus.unauthenticated,
          pageBuilder: (context, state) => NoTransitionPage(
            name: LoginPage.routeName,
            child: LoginPage.pageBuilder(context, state),
          ),
          routes: [
            AppRoute(
              name: SignUpPage.routeName,
              path: SignUpPage.routeName,
              appStatus: AppStatus.unauthenticated,
              builder: SignUpPage.pageBuilder,
            ),
            AppRoute(
              name: ResetPasswordPage.routeName,
              path: ResetPasswordPage.routeName,
              appStatus: AppStatus.unauthenticated,
              builder: ResetPasswordPage.pageBuilder,
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final status = appBloc.state.status;

        if (status != _currentStatus) {
          _currentStatus = status;
          return _currentStatus.route;
        } else {
          return null;
        }
      },
    );
  }
}
