// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:gallery/directories/material/buttons/buttons.dart';
import 'package:widgetbook/widgetbook.dart';

class MaterialFolder extends WidgetbookFolder {
  MaterialFolder()
      : super(
          name: 'Material',
          children: [
            MaterialButtonsFolder(),
          ],
        );
}
