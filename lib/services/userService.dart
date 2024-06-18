import 'package:app_project/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      return null;
    }
  }

  Future<AAA?> getUserByEmail(String email) async {
    final userRef = FirebaseFirestore.instance.collection('users');
    final userQuery = await userRef.where('email', isEqualTo: email).get();
    if (userQuery.docs.isNotEmpty) {
      final userDoc = userQuery.docs.first;
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
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      AAA? user = await getUserByEmail(email);
      if (user != null) {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } catch (e) {
      print('Login failed: $e');
    }
  }

  Future<void> updateUser(String id, String newAvatarUrl, String address,
      String username, String phone, String email) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Upload ảnh mới với tên là id
    if (newAvatarUrl != "") {
      // Update thông tin user
      await firestore.collection('users').doc(id).update({
        'avatar': newAvatarUrl,
        'address': address,
        'username': username,
        'phone': phone,
        'email': email,
      });
    } else {
      // Update thông tin user nếu không có ảnh mới
      await firestore.collection('users').doc(id).update({
        'address': address,
        'username': username,
        'phone': phone,
        'email': email,
      });
    }
  }
}
