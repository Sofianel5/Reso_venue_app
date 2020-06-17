import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends DateTimePickerModel {
  String digits(value, int length) {
    return '$value'.padLeft(length, "0");
  }

  List<String> hourStrings = ["12AM", "1AM", "2AM", "3AM", "4AM", "5AM", "6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "12 PM", "1PM", "2PM", "3PM", "4PM", "5PM", "6PM", "7PM", "8PM", "9PM", "10PM", "11PM"];

  CustomPicker({DateTime currentTime, DateTime maxTime, DateTime minTime, LocaleType locale}) : super(locale: locale, minTime: minTime, maxTime: maxTime, currentTime: currentTime);


  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      DateTime time = currentTime.add(Duration(days: super.currentLeftIndex()));
      if (isAtSameDay(minTime, time)) {
        if (index >= 0 && index < 24 - minTime.hour) {
          return hourStrings[minTime.hour + index];
        } else {
          return null;
        }
      } else if (isAtSameDay(maxTime, time)) {
        if (index >= 0 && index <= maxTime.hour) {
          return hourStrings[index];
        } else {
          return null;
        }
      }
      return hourStrings[index];
    }

    return null;
  }

  @override
  List<int> layoutProportions() {
    return [3, 2, 1];
  }
}