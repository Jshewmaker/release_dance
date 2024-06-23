// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/sign_up/sign_up.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpPage', () {
    test('pageBuilder returns a SignUpPage', () {
      expect(
        SignUpPage.pageBuilder(null, null),
        isA<SignUpPage>(),
      );
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpApp(SignUpPage());
      expect(find.byType(SignUpForm), findsOneWidget);
    });
  });
}
