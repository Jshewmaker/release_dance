// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

part of 'theme_mode_bloc.dart';

abstract class ThemeModeEvent extends Equatable {
  const ThemeModeEvent();
}

/// The app's [ThemeMode] has been changed
class ThemeModeChanged extends ThemeModeEvent {
  const ThemeModeChanged(this.themeMode);

  final ThemeMode? themeMode;

  @override
  List<Object?> get props => [themeMode];
}
