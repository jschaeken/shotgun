String dateTimeToHumanReadable(DateTime dateTimeToHumanReadable) {
  // Eg May 6th 2021 at 2:30 PM
  final month = dateTimeToHumanReadable.month;
  final day = dateTimeToHumanReadable.day;
  final year = dateTimeToHumanReadable.year;
  final hour = dateTimeToHumanReadable.hour;
  final minute = dateTimeToHumanReadable.minute;
  final period = hour < 12 ? 'AM' : 'PM';
  final hour12 = hour > 12 ? hour - 12 : hour;

  return '${_getMonth(month)} $day, $year at $hour12:$minute $period';
}

const String _months =
    'January February March April May June July August September October November December';

String _getMonth(int month) {
  return _months.split(' ')[month - 1];
}
