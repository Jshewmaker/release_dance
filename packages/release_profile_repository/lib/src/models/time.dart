///{@template Time}
/// A class that represents a time.
/// {@endtemplate}
class Time {
  /// {@macro Time}
  Time({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
  });

  /// The year of the time.
  final String year;

  /// The month of the time.
  final String month;

  /// The day of the time.
  final String day;

  /// The hour of the time.
  final String hour;

  /// The minute of the time.
  final String minute;
}
