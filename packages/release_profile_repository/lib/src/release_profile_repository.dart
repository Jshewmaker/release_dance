import 'package:cloud_firestore_client/cloud_firestore_client.dart';

/// {@template release_profile_repository}
/// Repository for gathering data about a release user.
/// {@endtemplate}
class ReleaseProfileRepository {
  /// {@macro release_profile_repository}
  const ReleaseProfileRepository(
      {required CloudFirestoreClient cloudFirestoreClient})
      : _cloudFirestoreClient = cloudFirestoreClient;

  final CloudFirestoreClient _cloudFirestoreClient;

  /// Get the user's profile data.
  Future<String> getUserProfile() async {
    return _cloudFirestoreClient.getUser();
  }
}
