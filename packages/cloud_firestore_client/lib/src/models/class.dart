///{@template class}
/// A class that represents a dance class.
/// {@endtemplate}
class Class {
  /// {@macro class}
  const Class({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    required this.description,
    required this.date,
  });

  /// Creates a [Class] from a map.
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as String? ?? '',
      description: (json['description'] as String).trim(),
      name: (json['name'] as String).trim(),
      startTime: (json['start_time'] as String).trim(),
      endTime: (json['end_time'] as String).trim(),
      instructor: (json['instructor'] as String).trim(),
      date: (json['date'] as String).trim(),
    );
  }

  /// The id of the class.
  final String id;

  /// The title of the class.
  final String name;

  /// The start time of the class.
  final String startTime;

  /// The end time of the class.
  final String endTime;

  /// The description of the class.
  final String description;

  /// The instructor of the class.
  final String instructor;

  /// The date of the class.
  final String date;
}
