// Copyright (c) 2024, Very Good Ventures
// https://verygood.ventures

import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:widgetbook/widgetbook.dart';

class ColorsComponent extends WidgetbookComponent {
  ColorsComponent()
      : super(
          name: 'Colors',
          useCases: [
            _ColorsUseCase(),
          ],
        );
}

class _ColorsUseCase extends WidgetbookUseCase {
  _ColorsUseCase()
      : super(
          name: 'Colors',
          builder: (_) => const _Colors(),
        );
}

class _Colors extends StatelessWidget {
  const _Colors();

  static const _colorItems = [
    ('Black', Colors.black),
    ('White', Colors.white),
    ('Transparent', Colors.transparent),
    ('Blue', Colors.blue),
    ('Sky Blue', Colors.lightBlueAccent),
    ('Ocean Blue', Colors.blueAccent),
    ('Light Blue', Colors.lightBlue),
    ('Yellow', Colors.yellow),
    ('Red', Colors.red),
    ('Grey', Colors.grey),
    ('Green', Colors.green),
    ('Teal', Colors.teal),
  ];

  static const _shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

  @override
  Widget build(BuildContext context) {
    return TableView.builder(
      columnCount: _colorItems.length,
      rowCount: _shades.length + 1,
      columnBuilder: (i) => const TableSpan(extent: FixedTableSpanExtent(150)),
      rowBuilder: (i) => const TableSpan(extent: FixedTableSpanExtent(150)),
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: (context, vicinity) {
        final (colorName, someColor) = _colorItems[vicinity.column];

        if (vicinity.row == 0) {
          return Center(child: Text(colorName));
        }

        final color = someColor is MaterialColor
            ? someColor[_shades[vicinity.row - 1]]!
            : someColor;

        final hexCode = color.value.toRadixString(16).padLeft(8, '0');

        return DecoratedBox(
          decoration: BoxDecoration(color: color),
          child: Center(
            child: SelectableText(
              '#${hexCode.toUpperCase()}',
              style: TextStyle(
                color: color.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
