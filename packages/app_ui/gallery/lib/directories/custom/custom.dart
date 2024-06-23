// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:gallery/directories/custom/components/components.dart';
import 'package:widgetbook/widgetbook.dart';

class CustomFolder extends WidgetbookFolder {
  CustomFolder()
      : super(
          name: 'Custom',
          children: [
            ScrollableColumnComponent(),
          ],
        );
}
