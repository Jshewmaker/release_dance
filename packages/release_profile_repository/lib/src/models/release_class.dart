import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

/// {@template class}
/// A class that represents a dance class.
/// {@endtemplate}
class ReleaseClass {
  /// {@macro class}
  const ReleaseClass({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    required this.date,
  });

  /// Creates a [ReleaseClass] from a map.
  factory ReleaseClass.fromClient(Class firebaseClass) {
    final date = firebaseClass.date;
    final endTime = firebaseClass.endTime;
    final startTime = firebaseClass.startTime;
    return ReleaseClass(
      id: firebaseClass.id,
      description: firebaseClass.description,
      name: firebaseClass.name,
      startTime: Time(
        year: date.split('-')[0],
        month: date.split('-')[1],
        day: date.split('-')[2],
        hour: startTime,
        minute: startTime,
      ),
      endTime: Time(
        year: date.split('-')[0],
        month: date.split('-')[1],
        day: date.split('-')[2],
        hour: endTime,
        minute: endTime.split(':')[1],
      ),
      instructor: firebaseClass.instructor,
      date: firebaseClass.date,
    );
  }

  /// The id of the class.
  final String id;

  /// The title of the class.
  final String name;

  /// The start time of the class.
  final Time startTime;

  /// The end time of the class.
  final Time endTime;

  /// The description of the class.
  final String description;

  /// The instructor of the class.
  final String instructor;

  /// The date of the class.
  final String date;
}
