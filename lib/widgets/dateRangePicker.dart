import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({super.key});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateRange? selectedDateRange;

  void onDateRangeChanged(DateRange? range) {
    setState(() {
      selectedDateRange = range;
      print(selectedDateRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateRangePickerWidget(
          firstDayOfWeek: 1, // 1 = Monday
          doubleMonth: false,
          initialDateRange: selectedDateRange,
          disabledDates: [DateTime(2023, 11, 20)],
          maxDate: DateTime.now(),
          initialDisplayedDate: DateTime.now(),
          onDateRangeChanged: onDateRangeChanged,
          // Remove height so it expands naturally
          theme: const CalendarTheme(
            selectedColor: Color(0xFF9395D3),
            dayNameTextStyle: TextStyle(color: Colors.black45, fontSize: 10),
            inRangeColor: Color(0xFFD9EDFA),
            inRangeTextStyle: TextStyle(color: Colors.blue),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayTextStyle: TextStyle(fontWeight: FontWeight.w800),

            // todayColor: Color(0xFF9395D3),
            defaultTextStyle: TextStyle(color: Colors.black, fontSize: 12),
            radius: 10,
            tileSize: 42,
            disabledTextStyle: TextStyle(color: Colors.grey),
            quickDateRangeBackgroundColor: Color(0xFFFFF9F9),
            selectedQuickDateRangeColor: Colors.blue,
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            ElevatedButton(
                onPressed: () async {
                  print(
                      'Start ${selectedDateRange?.start} End ${selectedDateRange?.end}');
                  Navigator.of(context).pop({
                    'startDate': selectedDateRange?.start,
                    'endDate': selectedDateRange?.end,
                  });
                  // Navigator.pop(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MyHomePage(
                  //       startDate: selectedDateRange?.start,
                  //       endDate: selectedDateRange?.end,
                  //     ),
                  //   ),
                  // );
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        )
      ],
    );
  }
}
