// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_config_repository/app_config_repository.dart';
import 'package:app_support_repository/app_support_repository.dart';
import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:release_dance/app/app.dart';
import 'package:release_dance/app/app_router/app_router.dart';
import 'package:release_dance/connectivity/connectivity.dart';
import 'package:release_dance/l10n/l10n.dart';
import 'package:release_dance/notification/bloc/notification_bloc.dart';
import 'package:release_dance/theme_selector/theme_selector.dart';
import 'package:release_profile_repository/release_profile_repository.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    required AppConfigRepository appConfigRepository,
    required AppSupportRepository appSupportRepository,
    required ConnectivityRepository connectivityRepository,
    required UserRepository userRepository,
    required CloudFirestoreClient cloudFirestoreClient,
    required ReleaseProfileRepository releaseProfileRepository,
    required NotificationRepository notificationRepository,
    required User user,
    super.key,
  })  : _appConfigRepository = appConfigRepository,
        _releaseProfileRepository = releaseProfileRepository,
        _appSupportRepository = appSupportRepository,
        _connectivityRepository = connectivityRepository,
        _userRepository = userRepository,
        _cloudFirestoreClient = cloudFirestoreClient,
        _notificationRepository = notificationRepository,
        _user = user;

  final AppConfigRepository _appConfigRepository;
  final ReleaseProfileRepository _releaseProfileRepository;
  final CloudFirestoreClient _cloudFirestoreClient;
  final AppSupportRepository _appSupportRepository;
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final ConnectivityRepository _connectivityRepository;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _appConfigRepository),
        RepositoryProvider.value(value: _appSupportRepository),
        RepositoryProvider.value(value: _cloudFirestoreClient),
        RepositoryProvider.value(value: _releaseProfileRepository),
        RepositoryProvider.value(value: _connectivityRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _notificationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              appConfigRepository: _appConfigRepository,
              userRepository: _userRepository,
              user: _user,
            ),
          ),
          BlocProvider(
            create: (_) => NotificationBloc(
              notificationRepository: _notificationRepository,
            ),
          ),
          BlocProvider(create: (_) => ThemeModeBloc()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @visibleForTesting
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AppRouter _appRouter;
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalKey<NavigatorState>();
    _appRouter = AppRouter(
      openedNotificationsStream:
          context.read<NotificationRepository>().openedNotifications,
      appBloc: context.read<AppBloc>(),
      navigatorKey: _navigatorKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: context.watch<ThemeModeBloc>().state,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => ConnectivityOverlay(
        navigatorKey: _navigatorKey,
        child: child!,
      ),
      routerConfig: _appRouter.routes,
    );
  }
}
