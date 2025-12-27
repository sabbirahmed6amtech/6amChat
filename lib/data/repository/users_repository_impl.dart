import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/users_repository.dart' as domain;

class UsersRepositoryImpl implements domain.UsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return _firestore.collection('users').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        return UserEntity(
          uid: doc.id,
          fullName: doc['fullName'] ?? 'Unknown',
          email: doc['email'] ?? '',
          createdAt: (doc['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList(),
    );
  }
}
