// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class ScrollableColumnComponent extends WidgetbookComponent {
  ScrollableColumnComponent()
      : super(
          name: 'ScrollableColumn',
          useCases: [
            _ScrollableColumnUseCase(),
          ],
        );
}

class _ScrollableColumnUseCase extends WidgetbookUseCase {
  _ScrollableColumnUseCase()
      : super(
          name: 'ScrollableColumn',
          builder: (BuildContext context) {
            return ScrollableColumn(
              children: [
                for (final i in Iterable<int>.generate(100)) Text('$i'),
              ],
            );
          },
        );
}
