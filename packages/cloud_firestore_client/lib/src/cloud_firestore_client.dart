import 'package:cloud_firestore/cloud_firestore.dart';

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
      final doc = await _firestore.collection('users').doc('$userId').get();

      return doc.data() ?? {};
    } on Exception catch (e) {
      throw Exception('Error getting user: $e');
    }
  }
}
