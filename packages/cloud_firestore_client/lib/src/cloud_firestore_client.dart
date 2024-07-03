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

  /// Get classes data from Firestore.
  Future<List<Class>> getClasses(String date) async {
    try {
      final doc = _firestore.collection('classes').doc(date);

      final classes = await doc.collection('6:00').get();
      final classList =
          classes.docs.map((e) => Class.fromJson(e.data())).toList();

      return classList;
    } on Exception catch (e) {
      throw Exception('Error getting user: $e');
    }
  }
}
