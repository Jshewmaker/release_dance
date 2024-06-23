// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/login/login.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = LoginPassword.dirty(invalidPasswordString);

  const validPasswordString = 'password';
  const validPassword = LoginPassword.dirty(validPasswordString);

  group('LoginBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
      when(
        () => userRepository.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => userRepository.logInWithGoogle(),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => userRepository.logInWithApple(),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is LoginState', () {
      expect(LoginBloc(userRepository).state, LoginState());
    });

    group('EmailChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginEmailChanged(invalidEmailString)),
        expect: () => const <LoginState>[
          LoginState(email: invalidEmail),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(password: validPassword),
        act: (bloc) => bloc.add(LoginEmailChanged(validEmailString)),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );
    });

    group('PasswordChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginPasswordChanged(invalidPasswordString)),
        expect: () => const <LoginState>[
          LoginState(password: invalidPassword),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(email: validEmail),
        act: (bloc) => bloc.add(LoginPasswordChanged(validPasswordString)),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );
    });

    group('LogInWithCredentialsSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'does nothing when status is not validated',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        expect: () => const <LoginState>[],
      );

      blocTest<LoginBloc, LoginState>(
        'calls logInWithEmailAndPassword with correct email/password',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          valid: true,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        verify: (_) {
          verify(
            () => userRepository.logInWithEmailAndPassword(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithEmailAndPassword succeeds',
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          valid: true,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithEmailAndPassword fails',
        setUp: () {
          when(
            () => userRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        seed: () => LoginState(
          valid: true,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(LoginCredentialsSubmitted()),
        expect: () => const <LoginState>[
          LoginState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
          LoginState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('LogInWithGoogleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithGoogle succeeds',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithGoogle fails',
        setUp: () {
          when(
            () => userRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'with error when logInWithGoogle is canceled',
        setUp: () {
          when(
            () => userRepository.logInWithGoogle(),
          ).thenThrow(LogInWithGoogleCanceled(Exception()));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginGoogleSubmitted()),
        expect: () => <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.canceled),
        ],
      );
    });

    group('GoogleSignInWebInitialized', () {
      blocTest<LoginBloc, LoginState>(
        'calls onGoogleUserAuthorized',
        build: () => LoginBloc(userRepository, isWeb: true),
        act: (bloc) => bloc.add(GoogleSignInWebInitialized()),
        verify: (_) {
          verify(() => userRepository.onGoogleUserAuthorized()).called(1);
        },
      );
    });

    group('LogInWithAppleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'calls logInWithApple',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        verify: (_) {
          verify(() => userRepository.logInWithApple()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when logInWithApple succeeds',
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [submissionInProgress, submissionFailure] '
        'when logInWithApple fails',
        setUp: () {
          when(
            () => userRepository.logInWithApple(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(userRepository),
        act: (bloc) => bloc.add(LoginAppleSubmitted()),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
