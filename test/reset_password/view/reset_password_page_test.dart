// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/reset_password/reset_password.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ResetPasswordPage', () {
    test('pageBuilder returns a ResetPasswordPage', () {
      expect(
        ResetPasswordPage.pageBuilder(null, null),
        isA<ResetPasswordPage>(),
      );
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpApp(const ResetPasswordPage());
      expect(find.byType(ResetPasswordView), findsOneWidget);
    });
  });
}
