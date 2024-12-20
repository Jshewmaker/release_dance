import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class EventOptions extends Model {
  EventOptions({
    this.emptyText,
    this.showLoadingForEvent,
    this.loadingWidget,
    this.emptyTextColor = const Color(0xffe5e5e5),
    this.emptyIcon = Icons.reorder,
    this.emptyIconColor = const Color(0xffebebeb),
  });
  String? emptyText;
  Color emptyTextColor;
  IconData emptyIcon;
  Color emptyIconColor;
  bool Function()? showLoadingForEvent;
  Widget Function()? loadingWidget;

  static EventOptions of(BuildContext context) =>
      ScopedModel.of<EventOptions>(context);
}
