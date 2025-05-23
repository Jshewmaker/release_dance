// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColors.yellow,
      canvasColor: AppColors.yellow,
      scaffoldBackgroundColor: _backgroundColor,
      iconTheme: _iconTheme,
      appBarTheme: _appBarTheme,
      dividerTheme: _dividerTheme,
      bottomNavigationBarTheme: _navigationBarTheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      buttonTheme: _buttonTheme,
      splashColor: AppColors.transparent,
      snackBarTheme: _snackBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      colorScheme: _colorScheme.copyWith(surface: _backgroundColor),
      listTileTheme: _listTileTheme,
    );
  }

  ColorScheme get _colorScheme {
    return const ColorScheme.light(
      primary: AppColors.white,
      secondary: AppColors.white,
    );
  }

  ListTileThemeData get _listTileTheme {
    return ListTileThemeData(
      tileColor: AppColors.white,
      selectedTileColor: AppColors.greyTernary,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }

  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: AppTextStyle.bodyText1.copyWith(
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.black,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  Color get _backgroundColor => AppColors.black;

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      iconTheme: _iconTheme,
      surfaceTintColor: AppColors.transparent,
      titleTextStyle: _textTheme.displayMedium,
      elevation: 0,
      backgroundColor: AppColors.transparent,
    );
  }

  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.greyPrimary);
  }

  BottomNavigationBarThemeData get _navigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: AppColors.black,
      selectedItemColor: AppColors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: _textTheme.labelLarge,
      unselectedLabelStyle: _textTheme.labelLarge,
      unselectedItemColor: AppColors.greySecondary,
    );
  }

  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.greySecondary,
      space: AppSpacing.xxxs,
      thickness: AppSpacing.xxxs,
      indent: 56,
      endIndent: AppSpacing.lg,
    );
  }

  TextTheme get _textTheme {
    return TextTheme(
      displayLarge: AppTextStyle.headline1,
      displayMedium: AppTextStyle.headline2,
      displaySmall: AppTextStyle.headline3,
      headlineMedium: AppTextStyle.headline4,
      headlineSmall: AppTextStyle.headline5,
      headlineLarge: AppTextStyle.headline1,
      titleLarge: AppTextStyle.headline6,
      titleMedium: AppTextStyle.subtitle1,
      titleSmall: AppTextStyle.subtitle2,
      bodyLarge: AppTextStyle.bodyText1,
      bodyMedium: AppTextStyle.bodyText2,
      labelLarge: AppTextStyle.button,
      bodySmall: AppTextStyle.caption,
      labelSmall: AppTextStyle.overline,
    ).apply(
      bodyColor: AppColors.greyPrimary,
      displayColor: AppColors.greyPrimary,
      decorationColor: AppColors.greyPrimary,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.greyPrimary),
    );
  }

  ButtonThemeData get _buttonTheme {
    return ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      colorScheme: _colorScheme.copyWith(primary: AppColors.green),
      buttonColor: AppColors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        textStyle: _textTheme.labelLarge,
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
      ),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        foregroundColor: AppColors.white,
      ),
    );
  }
}

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  ColorScheme get _colorScheme {
    return const ColorScheme.dark().copyWith(
      primary: AppColors.white,
      secondary: AppColors.lightBlue.shade300,
    );
  }

  @override
  TextTheme get _textTheme {
    return super._textTheme.apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
          decorationColor: AppColors.white,
        );
  }

  @override
  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: AppTextStyle.bodyText1.copyWith(
        color: AppColors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.greyPrimary,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  @override
  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        foregroundColor: AppColors.white,
      ),
    );
  }

  @override
  Color get _backgroundColor => AppColors.black;

  @override
  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.white);
  }

  @override
  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.white,
      space: AppSpacing.xxxs,
      thickness: AppSpacing.xxxs,
      indent: 56,
      endIndent: AppSpacing.lg,
    );
  }
}
