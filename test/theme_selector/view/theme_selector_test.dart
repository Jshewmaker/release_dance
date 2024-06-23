// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:release_dance/theme_selector/theme_selector.dart';

import '../../helpers/helpers.dart';

class _MockThemeModeBloc extends MockBloc<ThemeModeEvent, ThemeMode>
    implements ThemeModeBloc {}

void main() {
  late ThemeModeBloc themeModeBloc;

  group('ThemeSelector', () {
    setUp(() {
      themeModeBloc = _MockThemeModeBloc();
      when(() => themeModeBloc.state).thenReturn(ThemeMode.system);
    });

    testWidgets('contains all three ThemeMode options', (tester) async {
      await tester.pumpApp(const ThemeSelector(), themeModeBloc: themeModeBloc);
      expect(find.byKey(const Key('themeSelector_dropdown')), findsOneWidget);
      expect(
        find.byKey(const Key('themeSelector_system_dropdownMenuItem')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('themeSelector_light_dropdownMenuItem'),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('themeSelector_dark_dropdownMenuItem'),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('sets the new ThemeMode on change', (tester) async {
      await tester.pumpApp(const ThemeSelector(), themeModeBloc: themeModeBloc);

      await tester.tap(find.byKey(const Key('themeSelector_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('themeSelector_dark_dropdownMenuItem')).last,
      );
      verify(
        () => themeModeBloc.add(const ThemeModeChanged(ThemeMode.dark)),
      ).called(1);
    });
  });
}
