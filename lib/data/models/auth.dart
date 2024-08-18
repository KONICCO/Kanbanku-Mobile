class UserAuth {
  final int id;
  final String email;

  UserAuth({
    required this.id,
    required this.email,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      id: json['id'],
      email: json['email'],
    );
  }
}
