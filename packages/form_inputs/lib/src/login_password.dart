// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:formz/formz.dart';

/// Login Password Form Input Validation Error
enum LoginPasswordValidationError {
  /// Password is empty (should have at least 1 character)
  empty
}

/// {@template login_password}
/// Reusable login password form input.
/// {@endtemplate}
class LoginPassword extends FormzInput<String, LoginPasswordValidationError> {
  /// {@macro login_password}
  const LoginPassword.pure() : super.pure('');

  /// {@macro login_password}
  const LoginPassword.dirty([super.value = '']) : super.dirty();

  @override
  LoginPasswordValidationError? validator(String value) {
    return value.isEmpty ? LoginPasswordValidationError.empty : null;
  }
}
