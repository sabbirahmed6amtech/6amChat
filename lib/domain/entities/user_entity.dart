class UserEntity {
  final String uid;
  final String fullName;
  final String email;
  final DateTime? createdAt;

  UserEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    this.createdAt,
  });
}
