// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'dart:collection';

import 'package:app_ui/app_ui.dart';
import 'package:gallery/addons/accessibility_addon.dart';
import 'package:widgetbook/widgetbook.dart' hide AccessibilityAddon;

final addons = UnmodifiableListView<WidgetbookAddon>([
  AlignmentAddon(),
  AccessibilityAddon(),
  DeviceFrameAddon(
    devices: [
      Devices.ios.iPhoneSE,
      Devices.ios.iPhone13,
      Devices.macOS.macBookPro,
    ],
  ),
  MaterialThemeAddon(
    themes: [
      WidgetbookTheme(
        name: 'Light',
        data: const AppTheme().themeData,
      ),
      WidgetbookTheme(
        name: 'Dark',
        data: const AppDarkTheme().themeData,
      ),
    ],
  ),
  TextScaleAddon(
    scales: [1.0, 2.0],
    initialScale: 1,
  ),
]);
