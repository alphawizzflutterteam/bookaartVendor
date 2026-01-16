import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String? date, {String? format}) {
  DateTime? parseDate = DateTime.tryParse(date ?? '');

  if (parseDate != null) {
    final DateFormat formatter = DateFormat(format ?? 'yyyy-MM-dd');
    final String formatted = formatter.format(parseDate);
    return formatted;
  } else {
    return '';
  }
}

String formatTime(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  return DateFormat('hh:mm').format(dateTime);
}

TimeOfDay parseTimeOfDay(String time) {
  final parts = time.split(':');
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}
