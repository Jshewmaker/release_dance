// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extension on `WidgetTester` which exposes a method to
/// find a widget by [Type].
extension FindWidgetByTypeExtension on WidgetTester {
  /// Returns a `Widget` of type `T`.
  T findWidgetByType<T extends Widget>() => widget<T>(find.byType(T));
}
