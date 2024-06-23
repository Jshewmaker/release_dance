// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class TypographyComponent extends WidgetbookComponent {
  TypographyComponent()
      : super(
          name: 'Typography',
          useCases: [
            _TypographyUseCase(),
          ],
        );
}

class _TypographyUseCase extends WidgetbookUseCase {
  _TypographyUseCase()
      : super(
          name: 'Typography',
          builder: (_) => const _Typography(),
        );
}

class _Typography extends StatelessWidget {
  const _Typography();

  static final _textStyleList = [
    ('Headline 1', AppTextStyle.headline1),
    ('Headline 2', AppTextStyle.headline2),
    ('Headline 3', AppTextStyle.headline3),
    ('Headline 4', AppTextStyle.headline4),
    ('Headline 5', AppTextStyle.headline5),
    ('Headline 6', AppTextStyle.headline6),
    ('Subtitle 1', AppTextStyle.subtitle1),
    ('Subtitle 2', AppTextStyle.subtitle2),
    ('Body Text 1', AppTextStyle.bodyText1),
    ('Body Text 2', AppTextStyle.bodyText2),
    ('Button', AppTextStyle.button),
    ('Caption', AppTextStyle.caption),
    ('Overline', AppTextStyle.overline),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _textStyleList.length,
      itemBuilder: (context, index) {
        final (textStyleName, textStyle) = _textStyleList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.lg,
          ),
          child: Text(textStyleName, style: textStyle),
        );
      },
    );
  }
}
