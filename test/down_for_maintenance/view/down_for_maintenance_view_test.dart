// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/down_for_maintenance/down_for_maintenance.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DownForMaintenanceView', () {
    testWidgets('renders a DownForMaintenanceCard', (tester) async {
      await tester.pumpApp(const DownForMaintenanceView());
      expect(find.byType(DownForMaintenanceCard), findsOneWidget);
    });

    testWidgets('contains PopScope which prevents pops', (tester) async {
      await tester.pumpApp(const DownForMaintenanceView());

      final popScope = tester.findWidgetByType<PopScope>();
      expect(popScope.onPopInvoked, isNull);
    });
  });
}
