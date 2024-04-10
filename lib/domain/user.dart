import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String avatar;
  final Timestamp dob;
  final String address;
  final String email;
  final String phone;

  User(
      {required this.username,
      required this.address,
      required this.avatar,
      required this.dob,
      required this.email,
      required this.phone});
}
