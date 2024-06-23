// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/l10n/l10n.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LocalizationsX', () {
    testWidgets('performs localizations lookup', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Text(context.l10n.loginButtonText),
        ),
      );
      expect(find.text('LOGIN'), findsOneWidget);
    });
  });
}
