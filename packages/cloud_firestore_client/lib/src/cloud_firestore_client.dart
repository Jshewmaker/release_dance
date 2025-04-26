import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_client/cloud_firestore_client.dart';

/// {@template cloud_firestore_client}
/// Cloud Firestore Package
/// {@endtemplate}
class CloudFirestoreClient {
  /// {@macro cloud_firestore_client}
  CloudFirestoreClient({
    required FirebaseFirestore firebaseFirestore,
  }) : _firestore = firebaseFirestore;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Get user data from Firestore.
  Stream<ReleaseUser> getUser(String userId) {
    try {
      return _usersCollection.doc(userId).snapshots().map(
            (e) => ReleaseUser.fromJson(e.data()!),
          );
    } on Exception catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  /// Get all classes for a specific month.
  ///
  /// [startDate] is the first day of the month in 'yyyy-MM-dd' format.
  Future<List<Class>> getAllClassesForMonth(
    String startDate,
    String endDate,
  ) async {
    final classList = <Class>[];
    try {
      final doc = await _firestore
          .collection('classes')
          .orderBy(
            'date',
          )
          .startAt([startDate]).endAt([endDate]).get();

      final releaseClass = doc;
      classList.addAll(releaseClass.docs.map((e) => Class.fromJson(e.data())));

      return classList;
    } on Exception catch (e) {
      throw Exception('Error getting classes for month: $startDate $e');
    }
  }

  /// Get class information from specific class id.
  Future<Class> getSingleClass(String classId) async {
    try {
      final doc = await _firestore
          .collection('classes')
          .where('id', isEqualTo: classId)
          .get();

      return Class.fromJson(doc.docs.first.data());
    } on Exception catch (e) {
      throw Exception('Error getting class: $classId $e');
    }
  }

  /// Get class information from specific class id.
  Future<ClassInfo> getClassInfo(String classId) async {
    try {
      final doc = await _firestore.collection('class_info').doc(classId).get();

      return ClassInfo.fromJson(doc.data() ?? {});
    } on Exception catch (e) {
      throw Exception('Error getting class info:$classId $e');
    }
  }

  /// Enroll in a drop-in class. This will update the user's classes and drop-in classes.
  ///
  /// [userId] is the user's id from firebase.
  /// [classId] is the class id from firebase.
  /// [numberOfDropIns] is the number of drop-ins the user is using.
  Future<void> enrollInDropInClass(
    String userId,
    String classId,
    int numberOfDropIns,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'classes': FieldValue.arrayUnion([classId]),
        'drop_in_classes': FieldValue.increment(numberOfDropIns * -1),
      });
    } on Exception catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  /// Enroll in a course. This will update the user's courses.
  ///
  /// [userId] is the user's id from firebase.
  /// [courseId] is the course id from firebase.
  Future<void> enrollInCourse(
    String userId,
    String courseId,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'courses': FieldValue.arrayUnion([courseId]),
      });
    } on Exception catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  /// Buy drop-ins for a user.
  Future<void> buyDropIns(String userId, int numberOfDropIns) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'drop_in_classes': FieldValue.increment(numberOfDropIns),
      });
    } on Exception catch (e) {
      throw Exception('Error buying drop-ins: $e');
    }
  }
}
