
import 'package:intl/intl.dart';

String formatDate(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

String formatTime(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  return DateFormat('HH:mm').format(dateTime);
}