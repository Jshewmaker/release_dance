import 'package:flutter/material.dart';

import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_event_calendar/src/handlers/calendar_utils.dart';
import 'package:flutter_event_calendar/src/handlers/translator.dart';
import 'package:flutter_event_calendar/src/models/style/select_month_options.dart';

class SelectMonth extends StatelessWidget {
  SelectMonth({required this.onHeaderChanged, this.monthStyle});
  late List<String> months;

  Function(int selectedMonth) onHeaderChanged;

  MonthOptions? monthStyle;

  late BoxDecoration selectedDecoration;

  final int currentMonth = CalendarUtils.getPartByInt(format: PartFormat.MONTH);

  @override
  Widget build(BuildContext context) {
    selectedDecoration = BoxDecoration(
      color: monthStyle?.selectedColor,
      borderRadius: BorderRadius.circular(8),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        color: monthStyle?.backgroundColor,
      ),
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              Translator.getTranslation('month_selector'),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: monthStyle?.font,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Table(
                      border: const TableBorder(
                        horizontalInside:
                            BorderSide(color: Colors.black12, width: 0.2),
                        verticalInside:
                            BorderSide(color: Colors.black12, width: 0.2),
                      ),
                      children: monthsWidgetMaker(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TableRow> monthsWidgetMaker(BuildContext context) {
    months = Translator.getFullMonthNames();

    List<Widget> buildRowCells(int rowIndex) {
      var widgets = <TableCell>[];
      for (var j = 0; j < 3; j++) {
        final mMonth = (rowIndex * 3) + j + 1;
        widgets.add(
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onHeaderChanged.call(mMonth);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration:
                      mMonth == currentMonth ? selectedDecoration : null,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        months[(rowIndex * 3) + j].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: mMonth == currentMonth ? Colors.white : null,
                          fontFamily: monthStyle?.font,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return widgets;
    }

    var monthsWidget = <TableRow>[];
    for (var i = 0; i < 4; i++) {
      monthsWidget.add(TableRow(children: buildRowCells(i)));
    }

    return monthsWidget;
  }
}
