///{@template firestore_user}
/// Firestore User
/// {@endtemplate}
class FirestoreUser {
  ///{@macro firestore_user}
  FirestoreUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photoURL,
  });

  /// Creates a [FirestoreUser] from a map.
  factory FirestoreUser.fromMap(Map<String, dynamic> data) {
    return FirestoreUser(
      uid: data['uid'] as String,
      email: data['email'] as String,
      firstName: data['first_name'] as String,
      lastName: data['last_name'] as String,
      photoURL: data['photoURL'] as String,
    );
  }

  /// The user's unique id.
  final String uid;

  /// The user's email.
  final String email;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// The user's photo URL.
  final String photoURL;

  /// Converts the [FirestoreUser] to a map.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'photoURL': photoURL,
    };
  }
}
