// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:release_dance/reset_password/reset_password.dart';

void main() {
  const email = Email.dirty('email');
  group('ResetPasswordState', () {
    test('supports value comparisons', () {
      expect(ResetPasswordState(), ResetPasswordState());
    });

    test('returns same object when no properties are passed', () {
      expect(ResetPasswordState().copyWith(), ResetPasswordState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        ResetPasswordState().copyWith(status: FormzSubmissionStatus.initial),
        ResetPasswordState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        ResetPasswordState().copyWith(email: email),
        ResetPasswordState(email: email),
      );
    });
  });
}
