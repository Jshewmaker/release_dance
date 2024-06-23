// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/settings/settings.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsPage', () {
    test('pageBuilder returns a SettingsPage', () {
      expect(
        SettingsPage.pageBuilder(null, null),
        isA<SettingsPage>(),
      );
    });

    testWidgets(
      'renders SettingsView',
      (WidgetTester tester) async {
        await tester.pumpApp(const SettingsPage());
        expect(find.byType(SettingsView), findsOneWidget);
      },
    );
  });
}
