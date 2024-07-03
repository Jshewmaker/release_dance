import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:release_profile_repository/release_profile_repository.dart';
import 'package:intl/intl.dart';

/// {@template class}
/// A class that represents a dance class.
/// {@endtemplate}
class ReleaseClass {
  /// {@macro class}
  const ReleaseClass({
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.instructor,
  });

  /// Creates a [ReleaseClass] from a map.
  factory ReleaseClass.fromClient(Class firebaseClass) {
    final startTime = firebaseClass.startTime.toDate();
    final endTime = firebaseClass.endTime.toDate();
    return ReleaseClass(
      description: firebaseClass.description,
      name: firebaseClass.name,
      startTime: Time(
        year: DateFormat.y().format(startTime),
        month: DateFormat.M().format(startTime),
        day: DateFormat.d().format(startTime),
        hour: DateFormat.j().format(startTime),
        minute: DateFormat.M().format(startTime),
      ),
      endTime: Time(
        year: DateFormat.y().format(endTime),
        month: DateFormat.M().format(endTime),
        day: DateFormat.d().format(endTime),
        hour: DateFormat.j().format(endTime),
        minute: DateFormat.M().format(endTime),
      ),
      instructor: firebaseClass.instructor,
    );
  }

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
}
