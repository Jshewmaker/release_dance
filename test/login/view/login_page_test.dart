// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/login/login.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    test('pageBuilder builds a LoginPage', () {
      expect(LoginPage.pageBuilder(null, null), isA<LoginPage>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpApp(const LoginPage());
      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
