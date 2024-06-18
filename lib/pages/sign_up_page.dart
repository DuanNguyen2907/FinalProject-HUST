import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  String _avatarImagePath = '';
  // ignore: non_constant_identifier_names
  late Timestamp time_dob;

  Future<void> _selectAvatarImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _avatarImagePath = pickedImage.path;
      });
    }
  }

  Future<void> _signUp() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseStorage storage = FirebaseStorage.instance;

      String username = _usernameController.text;
      String email = _emailController.text;
      String address = _addressController.text;
      String phone = _phoneController.text;
      String password = _passwordController.text;
      String rePassword = _rePasswordController.text;

      // validate password
      String message =
          validation(username, email, address, phone, password, rePassword);
      if (message != '' || message.isNotEmpty) {
        _showPopup(context, message);
        return;
      }

      print("hello");
      // create auth user
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // add image to firebase
      File file = File(_avatarImagePath);
      String uid = userCredential.user!.uid;
      Reference ref = storage.ref().child('avatars/$uid');
      await ref.putFile(file);

      // create user info
      String imageURL = await ref.getDownloadURL();
      await firestore.collection('users').doc(uid).set({
        'username': username,
        'address': address,
        'dob': time_dob,
        'email': email,
        'phone': phone,
        'avatar': imageURL,
      });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
    } catch (e) {
      // Handle sign up errors
      print('Sign up failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selectAvatarImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarImagePath.isNotEmpty
                    ? FileImage(File(_avatarImagePath)) as ImageProvider<Object>
                    : const AssetImage('assets/avatar.png'),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'UserName',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: const Icon(Icons.location_pin),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dobController,
              onTap: () async {
                DateTime? dob = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (dob != null) {
                  time_dob = Timestamp.fromDate(dob);
                  setState(() {
                    _dobController.text = dob.toString().split(' ')[0];
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Date of birth',
                prefixIcon: const Icon(Icons.date_range),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_off),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _rePasswordController,
              decoration: InputDecoration(
                labelText: 'Re-enter Password',
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_off),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String validation(String username, String email, String address, String phone,
      String password, String rePassword) {
    String message = '';

    // check null
    if (username.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      message = "Nhập thiếu trường.Vui lòng nhập đầy đủ!";
      return message;
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (password != rePassword) {
      message = "Mật khẩu không khớp! Vui lòng nhập lại mật khẩu";
    } else if (phone.length != 10 || !phone.contains(RegExp(r'^[0-9]+$'))) {
      message = "Số điện thoại phải bao gồm 10 chữ số!";
    } else if (!emailRegex.hasMatch(email)) {
      message = "Email không hợp lệ !";
    }
    return message;
  }
}
