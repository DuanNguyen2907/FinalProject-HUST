import 'package:cloud_firestore/cloud_firestore.dart';

class AAA {
  final String username;
  final String avatar;
  final Timestamp dob;
  final String address;
  final String email;
  final String phone;

  AAA(
      {required this.username,
      required this.address,
      required this.avatar,
      required this.dob,
      required this.email,
      required this.phone});

  factory AAA.fromDocumentSnapshot(DocumentSnapshot doc) {
    return AAA(
      username: doc['username'],
      avatar: doc['avatar'],
      dob: doc['dob'],
      address: doc['address'],
      email: doc['email'],
      phone: doc['phone'],
    );
  }
}
