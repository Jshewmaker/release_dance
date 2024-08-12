import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:intl/intl.dart';
import 'package:release_profile_repository/release_profile_repository.dart';

/// {@template release_profile_repository}
/// Repository for gathering data about a release user.
/// {@endtemplate}
class ReleaseProfileRepository {
  /// {@macro release_profile_repository}
  const ReleaseProfileRepository({
    required CloudFirestoreClient cloudFirestoreClient,
    required FirebaseAuthenticationClient firebaseAuthenticationClient,
  })  : _cloudFirestoreClient = cloudFirestoreClient,
        _firebaseAuthenticationClient = firebaseAuthenticationClient;

  final CloudFirestoreClient _cloudFirestoreClient;
  final FirebaseAuthenticationClient _firebaseAuthenticationClient;

  /// Get the user's profile data.
  Future<ReleaseUser> getUserProfile() async {
    final user = await _firebaseAuthenticationClient.user.first;
    final json = await _cloudFirestoreClient.getUser(user.id);
    return ReleaseUser.fromJson(json);
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
  Future<ReleaseClass> getSingleClass(
    String classId,
    String date,
  ) async {
    final response = await _cloudFirestoreClient.getSingleClass(classId, date);
    return ReleaseClass.fromClient(response);
  }

  /// Use one of the users drop-in classes.
  ///
  /// [classId] is the id of the class to enroll in.
  /// [numberOfDropIns] is the number of drop-ins to use.
  Future<void> enrollInClass(String classId, int numberOfDropIns) async {
    final user = await _firebaseAuthenticationClient.user.first;
    await _cloudFirestoreClient.enrollInDropInClass(
      user.id,
      classId,
      numberOfDropIns,
    );
  }
}
