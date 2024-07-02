class firestoreUser {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;

  firestoreUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
  });

  factory firestoreUser.fromMap(Map<String, dynamic> data) {
    return firestoreUser(
      uid: data['uid'] as String,
      email: data['email'] as String,
      displayName: data['displayName'] as String,
      photoURL: data['photoURL'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
