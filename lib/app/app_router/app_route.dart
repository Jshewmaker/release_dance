// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';
import 'package:release_dance/home/home.dart';
import 'package:release_dance/login/login.dart';
import 'package:release_dance/onboarding/onboarding.dart';

extension AppStatusRoute on AppStatus {
  String get route {
    switch (this) {
      case AppStatus.onboardingRequired:
        return OnboardingPage.routeName;
      case AppStatus.authenticated:
        return HomePage.routeName;
      case AppStatus.downForMaintenance:
        return DownForMaintenancePage.routeName;
      case AppStatus.forceUpgradeRequired:
        return ForceUpgradePage.routeName;
      case AppStatus.unauthenticated:
        return LoginPage.routeName;
    }
  }
}

class AppRoute extends GoRoute {
  AppRoute({
    required super.path,
    super.name,
    super.builder,
    super.pageBuilder,
    super.parentNavigatorKey,
    super.routes = const <RouteBase>[],
    this.appStatus = AppStatus.authenticated,
  });

  final AppStatus appStatus;

  @override
  GoRouterRedirect get redirect => (context, state) {
        final currentStatus = context.read<AppBloc>().state.status;
        return currentStatus == appStatus ? null : currentStatus.route;
      };
}
