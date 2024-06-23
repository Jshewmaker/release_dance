// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/reset_password/reset_password.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  group('ResetPasswordBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
      when(
        () => userRepository.sendPasswordResetEmail(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is ResetPasswordState', () {
      expect(ResetPasswordBloc(userRepository).state, ResetPasswordState());
    });

    group('ResetPasswordEmailChanged', () {
      blocTest<ResetPasswordBloc, ResetPasswordState>(
        'emits [invalid] when email is invalid',
        build: () => ResetPasswordBloc(userRepository),
        act: (bloc) => bloc.add(ResetPasswordEmailChanged(invalidEmailString)),
        expect: () => const <ResetPasswordState>[
          ResetPasswordState(email: invalidEmail),
        ],
      );

      blocTest<ResetPasswordBloc, ResetPasswordState>(
        'emits [valid] when email is valid',
        build: () => ResetPasswordBloc(userRepository),
        act: (bloc) => bloc.add(ResetPasswordEmailChanged(validEmailString)),
        expect: () => const <ResetPasswordState>[
          ResetPasswordState(email: validEmail, valid: true),
        ],
      );
    });

    group('ResetPasswordSubmitted', () {
      blocTest<ResetPasswordBloc, ResetPasswordState>(
        'does nothing when status is not validated',
        build: () => ResetPasswordBloc(userRepository),
        act: (bloc) => bloc.add(ResetPasswordSubmitted()),
        expect: () => const <ResetPasswordState>[],
      );

      blocTest<ResetPasswordBloc, ResetPasswordState>(
        'calls sendPasswordResetEmail with correct email',
        build: () => ResetPasswordBloc(userRepository),
        seed: () => ResetPasswordState(email: validEmail, valid: true),
        act: (bloc) => bloc.add(ResetPasswordSubmitted()),
        verify: (_) {
          verify(
            () => userRepository.sendPasswordResetEmail(
              email: validEmailString,
            ),
          ).called(1);
        },
      );

      blocTest<ResetPasswordBloc, ResetPasswordState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when sendPasswordResetEmail succeeds',
        build: () => ResetPasswordBloc(userRepository),
        seed: () => ResetPasswordState(email: validEmail, valid: true),
        act: (bloc) => bloc.add(ResetPasswordSubmitted()),
        expect: () => const <ResetPasswordState>[
          ResetPasswordState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            valid: true,
          ),
          ResetPasswordState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            valid: true,
          ),
        ],
      );

      blocTest<ResetPasswordBloc, ResetPasswordState>(
        'emits [submissionInProgress, submissionFailure] '
        'when sendPasswordResetEmail fails',
        setUp: () {
          when(
            () => userRepository.sendPasswordResetEmail(
              email: any(named: 'email'),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => ResetPasswordBloc(userRepository),
        seed: () => ResetPasswordState(email: validEmail, valid: true),
        act: (bloc) => bloc.add(ResetPasswordSubmitted()),
        expect: () => const <ResetPasswordState>[
          ResetPasswordState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            valid: true,
          ),
          ResetPasswordState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            valid: true,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
