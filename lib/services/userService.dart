import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user.dart';

class UserService {
  Future<User> getUserById(String id) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    final userDoc = await userRef.doc(id).get();
    if (userDoc.exists) {
      return User(
        address: userDoc['address'],
        username: userDoc['username'],
        dob: userDoc['dob'],
        email: userDoc['email'],
        phone: userDoc['phone'],
        avatar: userDoc['avatar'],
      );
    } else {
      throw Exception('User not found');
    }
  }
}
