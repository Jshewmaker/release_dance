import 'package:cloud_firestore_client/cloud_firestore_client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
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
  Future<List<ReleaseClass>> getClasses(String date) async {
    final response = await _cloudFirestoreClient.getClasses(date);
    return response.map(ReleaseClass.fromClient).toList();
  }
}
