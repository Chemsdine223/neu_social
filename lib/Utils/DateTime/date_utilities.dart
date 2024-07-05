import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
  final DateFormat formatter = DateFormat(format);

  return formatter.format(dateTime);
}

String formatTimeOfDay(TimeOfDay timeOfDay, {bool is24HourFormat = true}) {
  final now = DateTime.now();
  final dt =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

  final format = is24HourFormat ? 'HH:mm' : 'hh:mm a';
  final timeFormatter = DateFormat(format);

  return timeFormatter.format(dt);
}

String yesterDayChecker(String item) {
  DateTime date = DateTime.parse(item);
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));

  String displayDate;
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    displayDate = 'Yesterday';
  } else {
    displayDate = DateFormat('dd-MM-yyyy').format(date);
  }

  return displayDate;
}
