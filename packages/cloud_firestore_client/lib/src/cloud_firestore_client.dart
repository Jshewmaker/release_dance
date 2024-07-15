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

  /// Get user data from Firestore.
  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      return doc.data() ?? {};
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
  Future<Class> getSingleClass(
    String classId,
    String date,
  ) async {
    try {
      final doc = await _firestore
          .collection('classes')
          .where('id', isEqualTo: classId)
          .where('date', isEqualTo: date)
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

  Future<void> enrollInClass(
    String userId,
    String classId,
    int numberOfDropIns,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'classes': FieldValue.arrayUnion([classId]),
        'dropInClasses': FieldValue.increment(numberOfDropIns),
      });
    } on Exception catch (e) {
      throw Exception('Error getting user: $e');
    }
  }
}
