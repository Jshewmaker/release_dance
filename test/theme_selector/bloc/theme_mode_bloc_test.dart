// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:release_dance/theme_selector/theme_selector.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ThemeModeBloc', () {
    setUpAll(mockHydratedStorage);

    test('initial state is ThemeMode.system', () {
      expect(ThemeModeBloc().state, ThemeMode.system);
    });

    blocTest<ThemeModeBloc, ThemeMode>(
      'on ThemeModeChanged sets the ThemeMode',
      build: ThemeModeBloc.new,
      act: (bloc) => bloc.add(const ThemeModeChanged(ThemeMode.dark)),
      expect: () => [ThemeMode.dark],
    );

    test('toJson and fromJson are inverse', () {
      for (final mode in ThemeMode.values) {
        final bloc = ThemeModeBloc();
        expect(bloc.fromJson(bloc.toJson(mode)), mode);
      }
    });
  });
}
