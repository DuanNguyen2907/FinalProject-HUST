import 'dart:io';

import 'package:app_project/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUserInfoPage extends StatefulWidget {
  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final UserService userService = UserService();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Declare variables to store user information
  String username = '';
  String email = '';
  String phone = '';
  String address = '';
  String avatar = '';
  String _avatarImagePath = '';

  @override
  void initState() {
    super.initState();
    // Fetch user information and update the variables
    _fetchUserInfo();
  }

  Future<void> _selectAvatarImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _avatarImagePath = pickedImage.path;
      });
    }
  }

  Future<void> _fetchUserInfo() async {
    final user = await userService.getUserById(currentUserId);
    if (user != null) {
      setState(() {
        avatar = user.avatar;
        username = user.username;
        email = user.email;
        phone = user.phone;
        address = user.address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAvatarField(),
            _buildTextField('Username', username),
            _buildTextField('Email', email),
            _buildTextField('Phone', phone),
            _buildTextField('Address', address),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _saveUserInfo(currentUserId, _avatarImagePath, address,
                    username, phone, email);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarField() {
    return Column(
      children: [
        GestureDetector(
          onTap: _selectAvatarImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _avatarImagePath.isNotEmpty
                ? FileImage(File(_avatarImagePath)) as ImageProvider<Object>
                : NetworkImage(avatar),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (newValue) {
        setState(() {
          if (label == 'Username') {
            username = newValue;
          } else if (label == 'Email') {
            email = newValue;
          } else if (label == 'Phone') {
            phone = newValue;
          } else if (label == 'Address') {
            address = newValue;
          }
        });
      },
      controller: TextEditingController(text: value),
    );
  }

  Future<void> _saveUserInfo(String id, String newAvatarPath, String address,
      String username, String phone, String email) async {
    UserService userService = UserService();
    final FirebaseStorage _storage = FirebaseStorage.instance;

    if (newAvatarPath != "") {
      Reference ref = _storage.ref().child('avatars/$id');
      await ref.delete();
      await ref.putFile(File(newAvatarPath));
      String newAvatarUrl = await ref.getDownloadURL();
      userService.updateUser(id, newAvatarUrl, address, username, phone, email);
    } else {
      String newAvatarUrl = "";
      userService.updateUser(id, newAvatarUrl, address, username, phone, email);
    }

    // Show a success message or navigate back to the user info page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User information saved')),
    );
  }
}
