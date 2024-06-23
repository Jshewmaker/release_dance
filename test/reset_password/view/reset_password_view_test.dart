// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/reset_password/reset_password.dart';

import '../../helpers/helpers.dart';

class _MockResetPasswordBloc
    extends MockBloc<ResetPasswordEvent, ResetPasswordState>
    implements ResetPasswordBloc {}

class _MockEmail extends Mock implements Email {}

void main() {
  const testEmail = 'test@gmail.com';

  group('ResetPasswordView', () {
    late ResetPasswordBloc resetPasswordBloc;

    setUp(() {
      resetPasswordBloc = _MockResetPasswordBloc();
      when(
        () => resetPasswordBloc.state,
      ).thenReturn(const ResetPasswordState());
    });

    group('adds', () {
      testWidgets('ResetPasswordEmailChanged when email changes',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordView(),
          ),
        );
        await tester.enterText(find.byType(EmailInput), testEmail);
        verify(
          () => resetPasswordBloc.add(
            const ResetPasswordEmailChanged(testEmail),
          ),
        ).called(1);
      });

      testWidgets('ResetPasswordSubmitted when submit button is pressed',
          (tester) async {
        when(() => resetPasswordBloc.state).thenReturn(
          const ResetPasswordState(valid: true),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordView(),
          ),
        );
        await tester.tap(find.byType(SubmitButton));
        verify(
          () => resetPasswordBloc.add(const ResetPasswordSubmitted()),
        ).called(1);
      });
    });

    group('renders', () {
      testWidgets('Sign Up Failure SnackBar when submission fails',
          (tester) async {
        whenListen(
          resetPasswordBloc,
          Stream.fromIterable(const <ResetPasswordState>[
            ResetPasswordState(status: FormzSubmissionStatus.inProgress),
            ResetPasswordState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordView(),
          ),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = _MockEmail();
        when(() => email.displayError).thenReturn(EmailValidationError.invalid);
        when(
          () => resetPasswordBloc.state,
        ).thenReturn(ResetPasswordState(email: email));
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordView(),
          ),
        );
        expect(
          find.text(tester.l10n.invalidEmailInputErrorText),
          findsOneWidget,
        );
      });

      testWidgets('disabled submit button when status is not validated',
          (tester) async {
        when(() => resetPasswordBloc.state).thenReturn(
          const ResetPasswordState(),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordView(),
          ),
        );
        final submitButtonFinder = find.descendant(
          of: find.byType(SubmitButton),
          matching: find.byType(ElevatedButton),
        );
        final submitButton = tester.widget<ElevatedButton>(submitButtonFinder);

        expect(submitButton.enabled, isFalse);
      });

      testWidgets('enabled submit button when status is validated',
          (tester) async {
        when(() => resetPasswordBloc.state).thenReturn(
          const ResetPasswordState(valid: true),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const ResetPasswordView(),
          ),
        );
        final submitButtonFinder = find.descendant(
          of: find.byType(SubmitButton),
          matching: find.byType(ElevatedButton),
        );
        final submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
        expect(submitButton.enabled, isTrue);
      });
    });

    group('navigates', () {
      testWidgets('back to previous page when submission status is success',
          (tester) async {
        final goRouter = MockGoRouter();
        whenListen(
          resetPasswordBloc,
          Stream.fromIterable(const <ResetPasswordState>[
            ResetPasswordState(status: FormzSubmissionStatus.inProgress),
            ResetPasswordState(status: FormzSubmissionStatus.success),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: resetPasswordBloc,
            child: const Scaffold(body: ResetPasswordView()),
          ),
          goRouter: goRouter,
        );
        await tester.pumpAndSettle();
        verify(goRouter.pop).called(1);
      });
    });
  });
}
