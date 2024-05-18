import 'package:app_project/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<AAA?> getUserById(String id) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    final userDoc = await userRef.doc(id).get();
    if (userDoc.exists) {
      AAA userInfo = AAA(
        address: userDoc['address'],
        username: userDoc['username'],
        dob: userDoc['dob'],
        email: userDoc['email'],
        phone: userDoc['phone'],
        avatar: userDoc['avatar'],
      );
      return userInfo;
    } else {
      return null; // or throw an exception if you prefer
    }
  }
}
