// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/login/login.dart';
import 'package:release_dance/reset_password/reset_password.dart'
    hide EmailInput;
import 'package:release_dance/sign_up/sign_up.dart';

import '../../helpers/helpers.dart';

class _MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class _MockEmail extends Mock implements Email {}

class _MockPassword extends Mock implements LoginPassword {}

void main() {
  const testEmail = 'test@gmail.com';
  const testPassword = 'testPassw0rd123';

  const email = Email.dirty(testEmail);
  const password = LoginPassword.dirty(testPassword);

  group('LoginView', () {
    late LoginBloc loginBloc;

    setUp(() {
      loginBloc = _MockLoginBloc();
      when(() => loginBloc.state).thenReturn(const LoginState());
    });

    group('adds', () {
      testWidgets('LoginEmailChanged when email changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.enterText(find.byType(EmailInput), testEmail);
        verify(
          () => loginBloc.add(const LoginEmailChanged(testEmail)),
        ).called(1);
      });

      testWidgets('LoginPasswordChanged when password changes', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.enterText(find.byType(PasswordInput), testPassword);
        verify(
          () => loginBloc.add(const LoginPasswordChanged(testPassword)),
        ).called(1);
      });

      testWidgets('LoginCredentialsSubmitted when login button is pressed',
          (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(email: email, password: password, valid: true),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.ensureVisible(find.byType(LoginButton));
        await tester.tap(find.byType(LoginButton));
        verify(() => loginBloc.add(const LoginCredentialsSubmitted()))
            .called(1);
      });

      testWidgets(
          'LoginGoogleSubmitted when sign in with google button is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.ensureVisible(find.byType(GoogleLoginButton));
        await tester.tap(find.byType(GoogleLoginButton));
        verify(() => loginBloc.add(const LoginGoogleSubmitted())).called(1);
      });

      testWidgets(
          'LoginAppleSubmitted when sign in with apple button is pressed',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
          platform: TargetPlatform.iOS,
        );
        await tester.ensureVisible(find.byType(AppleLoginButton));
        await tester.tap(find.byType(AppleLoginButton));
        verify(() => loginBloc.add(const LoginAppleSubmitted())).called(1);
      });
    });

    group('renders', () {
      testWidgets('Sign in with Google and Apple on iOS', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
          platform: TargetPlatform.iOS,
        );
        expect(find.byType(AppleLoginButton), findsOneWidget);
        expect(find.byType(GoogleLoginButton), findsOneWidget);
      });

      testWidgets('only Sign in with Google on Android', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
          platform: TargetPlatform.android,
        );
        expect(find.byType(AppleLoginButton), findsNothing);
        expect(find.byType(GoogleLoginButton), findsOneWidget);
      });

      testWidgets('AuthenticationFailure SnackBar when submission fails',
          (tester) async {
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('nothing when login is canceled', (tester) async {
        whenListen(
          loginBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.canceled),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsNothing);
      });

      testWidgets('invalid email error text when email is invalid',
          (tester) async {
        final email = _MockEmail();
        when(() => email.displayError).thenReturn(EmailValidationError.invalid);
        when(() => loginBloc.state).thenReturn(
          LoginState(email: email, password: password),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(tester.l10n.invalidEmailInputErrorText),
          findsOneWidget,
        );
      });

      testWidgets('invalid password error text when password is invalid',
          (tester) async {
        final password = _MockPassword();
        when(
          () => password.displayError,
        ).thenReturn(LoginPasswordValidationError.empty);
        when(() => loginBloc.state).thenReturn(LoginState(password: password));
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        expect(
          find.text(tester.l10n.invalidPasswordInputErrorText),
          findsOneWidget,
        );
      });

      testWidgets('disabled login button when status is not validated',
          (tester) async {
        when(() => loginBloc.state).thenReturn(const LoginState());
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        final loginButtonFinder = find.descendant(
          of: find.byType(LoginButton),
          matching: find.byType(ElevatedButton),
        );
        final loginButton = tester.widget<ElevatedButton>(loginButtonFinder);
        expect(loginButton.enabled, isFalse);
      });

      testWidgets('enabled login button when email and password are valid',
          (tester) async {
        when(() => loginBloc.state).thenReturn(
          const LoginState(
            email: email,
            password: password,
            valid: true,
          ),
        );
        await tester.pumpApp(
          BlocProvider.value(value: loginBloc, child: const LoginView()),
        );
        final loginButtonFinder = find.descendant(
          of: find.byType(LoginButton),
          matching: find.byType(ElevatedButton),
        );
        final loginButton = tester.widget<ElevatedButton>(loginButtonFinder);
        expect(loginButton.enabled, isTrue);
      });
    });

    group('navigates', () {
      late GoRouter goRouter;

      setUp(() {
        goRouter = MockGoRouter();
      });

      testWidgets(
        'to SignUpPage when Create Account is pressed',
        (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginView(),
            ),
            goRouter: goRouter,
          );
          await tester.ensureVisible(find.byType(SignUpButton));
          await tester.tap(find.byType(SignUpButton));
          verify(() => goRouter.goNamed(SignUpPage.routeName)).called(1);
        },
      );

      testWidgets(
        'to ResetPasswordPage when Forgot Password is pressed',
        (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: loginBloc,
              child: const LoginView(),
            ),
            goRouter: goRouter,
          );
          await tester.ensureVisible(find.byType(ResetPasswordButton));
          await tester.tap(find.byType(ResetPasswordButton));
          verify(() => goRouter.goNamed(ResetPasswordPage.routeName)).called(1);
        },
      );
    });
  });
}
