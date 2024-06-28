import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template cloud_firestore_client}
/// Cloud Firestore Package
/// {@endtemplate}
class CloudFirestoreClient {
  /// {@macro cloud_firestore_client}
  CloudFirestoreClient();

  final _firestore = FirebaseFirestore.instance;

  /// Get user data from Firestore.
  Future<String> getUser() async {
    final doc = await _firestore.collection('users').get();

    return doc.docs.first.id;
  }
}
