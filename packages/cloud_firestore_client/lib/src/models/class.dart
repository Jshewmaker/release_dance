import 'package:cloud_firestore/cloud_firestore.dart';

///{@template class}
/// A class that represents a dance class.
/// {@endtemplate}
class Class {
  /// {@macro class}
  const Class({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    required this.description,
  });

  /// Creates a [Class] from a map.
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      description: json['description'] as String,
      name: json['name'] as String,
      startTime: json['start_time'] as Timestamp,
      endTime: json['end_time'] as Timestamp,
      instructor: json['instructor'] as String,
    );
  }

  /// The title of the class.
  final String name;

  /// The start time of the class.
  final Timestamp startTime;

  /// The end time of the class.
  final Timestamp endTime;

  /// The description of the class.
  final String description;

  /// The instructor of the class.
  final String instructor;
}
