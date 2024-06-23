// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/settings/settings.dart';
import 'package:release_dance/theme_selector/theme_selector.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsView', () {
    testWidgets('renders a ThemeSelector', (tester) async {
      await tester.pumpApp(const SettingsView());
      expect(find.byType(ThemeSelector), findsOneWidget);
    });
  });
}
