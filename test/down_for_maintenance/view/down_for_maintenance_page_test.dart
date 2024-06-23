// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DownForMaintenancePage', () {
    test('pageBuilder returns a DownForMaintenancePage', () {
      expect(
        DownForMaintenancePage.pageBuilder(null, null),
        isA<DownForMaintenancePage>(),
      );
    });

    testWidgets(
      'renders DownForMaintenanceView',
      (WidgetTester tester) async {
        await tester.pumpApp(const DownForMaintenancePage());
        expect(find.byType(DownForMaintenanceView), findsOneWidget);
      },
    );
  });
}
