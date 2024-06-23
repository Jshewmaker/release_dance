// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class SpacingComponent extends WidgetbookComponent {
  SpacingComponent()
      : super(
          name: 'Spacing',
          useCases: [
            _SpacingUseCase(),
          ],
        );
}

class _SpacingUseCase extends WidgetbookUseCase {
  _SpacingUseCase()
      : super(
          name: 'Spacing',
          builder: (_) => const _Spacing(),
        );
}

class _Spacing extends StatelessWidget {
  const _Spacing();

  static const _spacingList = [
    (AppSpacing.xxxs, 'xxxs'),
    (AppSpacing.xxs, 'xxs'),
    (AppSpacing.xs, 'xs'),
    (AppSpacing.sm, 'sm'),
    (AppSpacing.md, 'md'),
    (AppSpacing.lg, 'lg'),
    (AppSpacing.xlg, 'xlg'),
    (AppSpacing.xxlg, 'xxlg'),
    (AppSpacing.xxxlg, 'xxxlg'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _spacingList.length,
      itemBuilder: (context, index) {
        final (spacing, spacingName) = _spacingList[index];
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: <Widget>[
              Container(
                width: spacing,
                height: AppSpacing.lg,
                color: AppColors.green,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(spacingName),
            ],
          ),
        );
      },
    );
  }
}
