import 'package:app_project/domain/post.dart';
import 'package:app_project/domain/user.dart';
import 'package:app_project/pages/login_page.dart';
import 'package:app_project/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: Column(
        children: [
          UserInfoPart(),
          // UserPosts(),
          SignOutButton(),
        ],
      ),
    );
  }
}

class UserInfoPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return FutureBuilder<AAA?>(
      future: userService.getUserById(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildUserDetails(snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildUserDetails(AsyncSnapshot<AAA?> snapshot) {
    if (snapshot.hasData) {
      final AAA user = snapshot.data!;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatar(user.avatar),
          SizedBox(height: 20),
          ..._buildUserInfo(user),
        ],
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Text('User not found');
    }
  }

  Widget _buildAvatar(String avatarUrl) {
    return CircleAvatar(backgroundImage: NetworkImage(avatarUrl));
  }

  List<Widget> _buildUserInfo(AAA user) {
    return [
      _buildInfoRow('Username: ', user.username),
      _buildInfoRow('Email: ', user.email),
      _buildInfoRow('Phone: ', user.phone),
      _buildInfoRow('Address: ', user.address),
      _buildInfoRow('Date of Birth: ',
          DateFormat('dd/MM/yyyy').format(user.dob.toDate())),
    ];
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// class UserPosts extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final UserService userService = Provider.of<UserService>(context);
//     final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return FutureBuilder<List<Post>>(
//       future: userService.getUserPosts(currentUserId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             List<Post> posts = snapshot.data!;
//             return ListView.builder(
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(posts[index].author),
//                   subtitle: Text(posts[index].content),
//                 );
//               },
//             );
//           } else {
//             return Text('Error: ${snapshot.error}');
//           }
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: const Text("Sign Out"),
    );
  }
}
