class ReleaseUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;

  ReleaseUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
  });

  factory ReleaseUser.fromJson(Map<String, dynamic> json) {
    return ReleaseUser(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}
