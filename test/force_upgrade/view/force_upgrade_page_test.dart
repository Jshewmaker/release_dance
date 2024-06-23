// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/force_upgrade/force_upgrade.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ForceUpgradePage', () {
    test('pageBuilder returns a ForceUpgradePage', () {
      expect(
        ForceUpgradePage.pageBuilder(null, null),
        isA<ForceUpgradePage>(),
      );
    });

    testWidgets(
      'renders ForceUpgradeView',
      (WidgetTester tester) async {
        await tester.pumpApp(const ForceUpgradePage());
        expect(find.byType(ForceUpgradeView), findsOneWidget);
      },
    );
  });
}
