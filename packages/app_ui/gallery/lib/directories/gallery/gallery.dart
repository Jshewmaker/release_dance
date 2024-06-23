// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:gallery/directories/gallery/components/components.dart';
import 'package:widgetbook/widgetbook.dart';

class GalleryFolder extends WidgetbookFolder {
  GalleryFolder()
      : super(
          name: 'Gallery',
          children: [
            ColorsComponent(),
            SpacingComponent(),
            TypographyComponent(),
          ],
        );
}
