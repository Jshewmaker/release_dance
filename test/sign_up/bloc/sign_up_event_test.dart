// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/sign_up/sign_up.dart';

void main() {
  group('SignUpEvent', () {
    group('SignUpEmailChanged', () {
      test('supports value comparisons', () {
        expect(
          SignUpEmailChanged('test@gmail.com'),
          SignUpEmailChanged('test@gmail.com'),
        );
        expect(
          SignUpEmailChanged(''),
          isNot(SignUpEmailChanged('test@gmail.com')),
        );
      });
    });

    group('SignUpPasswordChanged', () {
      test('supports value comparisons', () {
        expect(SignUpPasswordChanged('pwd'), SignUpPasswordChanged('pwd'));
        expect(
          SignUpPasswordChanged(''),
          isNot(SignUpPasswordChanged('pwd')),
        );
      });
    });

    group('SignUpSubmitted', () {
      test('supports value comparisons', () {
        expect(SignUpSubmitted(), SignUpSubmitted());
      });
    });
  });
}
