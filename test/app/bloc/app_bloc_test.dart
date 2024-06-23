// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:app_config_repository/app_config_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/app/app.dart';
import 'package:user_repository/user_repository.dart';

class _MockAppConfigRepository extends Mock implements AppConfigRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final forceUpgradeRequired = ForceUpgrade(
      isUpgradeRequired: true,
      upgradeUrl: 'upgrade-url',
    );
    final forceUpgradeNotRequired = ForceUpgrade(isUpgradeRequired: false);
    final user = _MockUser();
    late AppConfigRepository appConfigRepository;
    late UserRepository userRepository;

    setUp(() {
      appConfigRepository = _MockAppConfigRepository();
      userRepository = _MockUserRepository();

      when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
        (_) => Stream.empty(),
      );
      when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
        (_) => Stream.empty(),
      );
      when(() => userRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
    });

    test('initial state is unauthenticated when user is unauthenticated', () {
      expect(
        AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: User.unauthenticated,
        ).state,
        AppState.unauthenticated(),
      );
    });

    group('DownForMaintenanceStatusChanged', () {
      blocTest<AppBloc, AppState>(
        'emits downForMaintenance when isDownForMaintenance is true',
        setUp: () {
          when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
            (_) => Stream.value(true),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: User.unauthenticated,
        ),
        expect: () => [AppState.downForMaintenance()],
      );

      blocTest<AppBloc, AppState>(
        'emits downForMaintenance with user when isDownForMaintenance is true',
        setUp: () {
          when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
            (_) => Stream.value(true),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.authenticated(user),
        expect: () => [AppState.downForMaintenance(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits nothing when downForMaintenance is false '
        'and state is not downForMaintenance',
        setUp: () {
          when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
            (_) => Stream.value(false),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.authenticated(user),
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when downForMaintenance is false '
        'and state is downForMaintenance with no user',
        setUp: () {
          when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
            (_) => Stream.value(false),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.downForMaintenance,
        expect: () => [AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when downForMaintenance is false '
        'and state is downForMaintenance with a user',
        setUp: () {
          when(() => appConfigRepository.isDownForMaintenance()).thenAnswer(
            (_) => Stream.value(false),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.downForMaintenance(user),
        expect: () => [AppState.authenticated(user)],
      );
    });

    group('ForceUpgradeStatusChanged', () {
      blocTest<AppBloc, AppState>(
        'emits forceUpgradeRequired when force upgrade is required',
        setUp: () {
          when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
            (_) => Stream.value(forceUpgradeRequired),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: User.unauthenticated,
        ),
        expect: () => [AppState.forceUpgradeRequired(forceUpgradeRequired)],
      );

      blocTest<AppBloc, AppState>(
        'emits forceUpgradeRequired with user when force upgrade is required',
        setUp: () {
          when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
            (_) => Stream.value(forceUpgradeRequired),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.authenticated(user),
        expect: () => [
          AppState.forceUpgradeRequired(forceUpgradeRequired, user),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits nothing when force upgrade is not required '
        'and state is not forceUpgradeRequired',
        setUp: () {
          when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
            (_) => Stream.value(forceUpgradeNotRequired),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when force upgrade is not required '
        'and state is forceUpgradeRequired with no user',
        setUp: () {
          when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
            (_) => Stream.value(forceUpgradeNotRequired),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.forceUpgradeRequired(forceUpgradeRequired),
        expect: () => [AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when force upgrade is not required '
        'and state is forceUpgradeRequired with a user',
        setUp: () {
          when(() => appConfigRepository.isForceUpgradeRequired()).thenAnswer(
            (_) => Stream.value(forceUpgradeNotRequired),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.forceUpgradeRequired(forceUpgradeRequired, user),
        expect: () => [AppState.authenticated(user)],
      );
    });

    group('UserChanged', () {
      late User returningUser;
      late User newUser;

      setUp(() {
        returningUser = _MockUser();
        newUser = _MockUser();
        when(() => returningUser.isNewUser).thenReturn(false);
        when(() => newUser.isNewUser).thenReturn(true);
      });

      blocTest<AppBloc, AppState>(
        'emits updated ForceUpgradeRequired with user '
        'when state is forceUpgradeRequired',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.forceUpgradeRequired(forceUpgradeRequired),
        expect: () => [
          AppState.forceUpgradeRequired(forceUpgradeRequired, user),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits updated DownForMaintenance with user '
        'when state is downForMaintenance',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.downForMaintenance,
        expect: () => [AppState.downForMaintenance(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and user is unauthenticated',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.unauthenticated),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when '
        'state is onboardingRequired and user is unauthenticated',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.unauthenticated),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.onboardingRequired(user),
        expect: () => <AppState>[AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits onboardingRequired when user is new and authenticated',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(newUser),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.onboardingRequired(newUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when user is returning and authenticated',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when '
        'user is authenticated and onboarding is complete',
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        seed: () => AppState.onboardingRequired(user),
        act: (bloc) => bloc.add(AppOnboardingCompleted()),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when '
        'user is unauthenticated and onboarding is complete',
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: User.unauthenticated,
        ),
        seed: () => AppState.onboardingRequired(User.unauthenticated),
        act: (bloc) => bloc.add(AppOnboardingCompleted()),
        expect: () => [AppState.unauthenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is unauthenticated',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(User.unauthenticated),
          );
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        setUp: () {
          when(() => userRepository.logOut()).thenAnswer((_) async {});
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => userRepository.logOut()).called(1);
        },
      );
    });

    group('UserAccountDeleted', () {
      blocTest<AppBloc, AppState>(
        'invokes deleteAccount',
        setUp: () {
          when(() => userRepository.deleteAccount()).thenAnswer((_) async {});
        },
        build: () => AppBloc(
          appConfigRepository: appConfigRepository,
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppUserAccountDeleted()),
        verify: (_) {
          verify(() => userRepository.deleteAccount()).called(1);
        },
      );
    });
  });
}
