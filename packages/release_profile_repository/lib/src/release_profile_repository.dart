import 'package:authentication_client/authentication_client.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:intl/intl.dart';

/// {@template release_profile_repository}
/// Repository for gathering data about a release user.
/// {@endtemplate}
class ReleaseProfileRepository {
  /// {@macro release_profile_repository}
  const ReleaseProfileRepository({
    required CloudFirestoreClient cloudFirestoreClient,
    required User user,
  })  : _cloudFirestoreClient = cloudFirestoreClient,
        _user = user;

  final CloudFirestoreClient _cloudFirestoreClient;
  final User _user;

  /// Get the user's profile data.
  Stream<ReleaseUser> getUserProfile() {
    return _cloudFirestoreClient.getUser(_user.id);
  }

  /// Get this months classes.
  ///
  /// [startDate] is the first day of the month in 'yyyy-MM-dd' format.
  Future<List<ReleaseClass>> getClasses(String startDate) async {
    final dateTime = DateTime.parse(startDate);
    final lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    final endDate = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);
    final response =
        await _cloudFirestoreClient.getAllClassesForMonth(startDate, endDate);
    return response.map(ReleaseClass.fromClient).toList();
  }

  /// Get class information from specific class id.
  Future<ClassInfo> getClassInfo(String classId) async {
    final response = await _cloudFirestoreClient.getClassInfo(classId);
    return response;
  }

  /// Get class information from specific class id.
  Future<ReleaseClass> getSingleClass(String classId) async {
    final response = await _cloudFirestoreClient.getSingleClass(classId);
    return ReleaseClass.fromClient(response);
  }

  /// Use one of the users drop-in classes.
  ///
  /// [classId] is the id of the class to enroll in.
  /// [numberOfDropIns] is the number of drop-ins to use.
  Future<void> enrollInClass(String classId, int numberOfDropIns) async {
    await _cloudFirestoreClient.enrollInDropInClass(
      _user.id,
      classId,
      numberOfDropIns,
    );
  }

  /// Enroll in a course.
  ///
  /// [classId] is the id of the class to enroll in.
  Future<void> enrollInCourse(String classId) async {
    await _cloudFirestoreClient.enrollInCourse(
      _user.id,
      classId,
    );
  }

  /// Buy drop-ins for the user.
  Future<void> buyDropIns(int numberOfDropIns) async {
    await _cloudFirestoreClient.buyDropIns(_user.id, numberOfDropIns);
  }
}
