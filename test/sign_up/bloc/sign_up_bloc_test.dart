// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/sign_up/sign_up.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = SignUpPassword.dirty(invalidPasswordString);

  const validPasswordString = 't0pS3cret1234';
  const validPassword = SignUpPassword.dirty(validPasswordString);

  group('SignUpBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
      when(
        () => userRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is SignUpState', () {
      expect(SignUpBloc(userRepository).state, SignUpState());
    });

    group('SignUpEmailChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when email/password are invalid',
        build: () => SignUpBloc(userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(invalidEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(email: invalidEmail),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [valid] when email/password are valid',
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(password: validPassword),
        act: (bloc) => bloc.add(SignUpEmailChanged(validEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );
    });

    group('SignUpPasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when email/password are invalid',
        build: () => SignUpBloc(userRepository),
        act: (bloc) => bloc.add(SignUpPasswordChanged(invalidPasswordString)),
        expect: () => const <SignUpState>[
          SignUpState(password: invalidPassword),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [valid] when email/password are valid',
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(email: validEmail),
        act: (bloc) => bloc.add(SignUpPasswordChanged(validPasswordString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );
    });

    group('SignUpSubmitted', () {
      blocTest<SignUpBloc, SignUpState>(
        'does nothing when status is not validated',
        build: () => SignUpBloc(userRepository),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => const <SignUpState>[],
      );

      blocTest<SignUpBloc, SignUpState>(
        'calls signUp with correct email/password',
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(
          valid: true,
          email: validEmail,
          password: validPassword,
        ),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        verify: (_) {
          verify(
            () => userRepository.signUp(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when signUp succeeds',
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
          SignUpState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [submissionInProgress, submissionFailure] '
        'when signUp fails',
        setUp: () {
          when(
            () => userRepository.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => SignUpBloc(userRepository),
        seed: () => SignUpState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(SignUpSubmitted()),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
          SignUpState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
