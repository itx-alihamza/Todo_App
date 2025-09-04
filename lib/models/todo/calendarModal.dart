import 'package:flutter/material.dart';
import 'package:template/widgets/dateRangePicker.dart';
// import 'package:template/widgets/calendarWidget.dart';

export 'calendarModal.dart' show showCalendarDialog;

// Future<Map<String, DateTime?>?> showCalendarDialog(BuildContext context) {
//   return showDialog<Map<String, DateTime?>>(
Future showCalendarDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 300,
            maxHeight: MediaQuery.of(context).size.height * 0.45,
            minWidth: 200,
            maxWidth: 300,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: DateRangePicker(),
            ),
          ),
        ),
      );
    },
  );
}
