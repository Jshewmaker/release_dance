///{@template release_user}
/// Release User
/// {@endtemplate}
class ReleaseUser {
  ///{@macro release_user}
  ReleaseUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    this.dropInClasses = 0,
    this.courses = const [],
  });

  /// Creates a [ReleaseUser] from a map.
  factory ReleaseUser.fromJson(Map<String, dynamic> json) {
    return ReleaseUser(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String,
      dropInClasses: json['drop_in_classes'] as int? ?? 0,
      courses: json['classes'] == null
          ? <String>[]
          : List<String>.from(json['classes'] as List),
    );
  }

  /// The user's unique id.
  final String id;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// The user's email.
  final String email;

  /// The user's avatar URL.
  final String avatarUrl;

  /// Classes user is enrolled in.
  final List<String> courses;

  /// The number of drop in classes the user has.
  final int dropInClasses;

  /// Converts the [ReleaseUser] to a map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'drop_in_classes': dropInClasses,
      'avatar_url': avatarUrl,
      'classes': courses,
    };
  }
}
