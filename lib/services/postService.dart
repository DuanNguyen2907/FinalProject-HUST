import 'dart:core';
import 'dart:io';

import 'package:app_project/domain/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../domain/post.dart';
import './userService.dart';
import './tagService.dart';

class PostService {
  UserService userService = UserService();
  TagService tagService = TagService();

  Future<List<Post>> getPosts() async {
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final postsSnapshot = await postsRef.get();
    final posts = postsSnapshot.docs.map((doc) async {
      final id = doc.id;
      // get num likes
      final likesRef = doc.reference.collection('liked');
      final likesSnapshot = await likesRef.get();
      final numLikes = likesSnapshot.size;

      // get createAt
      final Timestamp createAt;
      createAt = doc["createAt"];
      DateTime createAtDateTime = createAt.toDate();
      DateTime now = DateTime.now();
      Duration difference = now.difference(createAtDateTime);
      String timeAgo = '';
      if (difference.inDays < 31) {
        timeAgo = difference.toString() + " ngày trước";
      } else if (difference.inDays < 365) {
        difference = difference ~/ 30;
        timeAgo = difference.toString() + " tháng trước";
      } else {
        difference = difference ~/ 365;
        timeAgo = difference.toString() + " năm trước";
      }

      // get author info
      final author = await userService.getUserById(doc['authorId']);

      List<Future<Tag>> tagFutures = [];
      for (int i = 0; i < doc['tags'].length; i++) {
        tagFutures.add(tagService.getTagById(doc['tags'][i]));
      }
      final tags = await Future.wait(tagFutures);
      return Post(
        id: id,
        author: author!.username,
        timeAgo: timeAgo,
        content: doc['content'].toString(),
        likes: numLikes,
        comments: doc['comments'],
        shares: 3,
        imageUrl: doc['imageUrls'],
        avatarUrl: author.avatar,
        tags: tags,
      );
    }).toList();

    return await Future.wait(posts);
  }

  Future<List<Post>> searchPosts(String keyword) async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    final posts = await Future.wait(querySnapshot.docs.map((doc) async {
      final likesRef = doc.reference.collection('liked');
      final likesSnapshot = await likesRef.get();
      final numLikes = likesSnapshot.size;
      final author = await userService.getUserById(doc['authorId']);

      final Timestamp createAt;
      createAt = doc["createAt"];
      DateTime createAtDateTime = createAt.toDate();
      DateTime now = DateTime.now();
      Duration difference = now.difference(createAtDateTime);
      String timeAgo = '';
      if (difference.inDays < 31) {
        timeAgo = difference.toString() + " ngày trước";
      } else if (difference.inDays < 365) {
        difference = difference ~/ 30;
        timeAgo = difference.toString() + " tháng trước";
      } else {
        difference = difference ~/ 365;
        timeAgo = difference.toString() + " năm trước";
      }

      List<Future<Tag>> tagFutures = [];
      for (int i = 0; i < doc['tags'].length; i++) {
        tagFutures.add(tagService.getTagById(doc['tags'][i]));
      }
      final tags = await Future.wait(tagFutures);

      return Post(
        id: doc.id,
        author: author!.username,
        timeAgo: timeAgo,
        content: doc['content'].toString(),
        likes: numLikes,
        comments: doc['comments'],
        shares: 3,
        imageUrl: doc['imageUrls'],
        avatarUrl: author.avatar,
        tags: tags,
      );
    }));

    List<Post> result_posts = posts
        .where((element) =>
            element.content.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    return result_posts.toList();
  }

  Future<void> createPosts(
      String content, List<File> imageList, List<String> tags) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      final id = Uuid().v4();
      final postRef = FirebaseFirestore.instance.collection("posts").doc(id);
      final List<String> imageUrlList = [];
      // Tải lên ảnh lên Firebase và lấy URL
      await Future.wait(imageList.map((file) async {
        Reference ref = _storage.ref().child('assets/$id');
        await ref.putFile(file);

        String Url = await ref.getDownloadURL();
        imageUrlList.add(Url);
      }));
      final post = {
        "content": content,
        "authorId": FirebaseAuth.instance.currentUser?.uid,
        "imageUrls": imageUrlList,
        "createAt": Timestamp.now(),
        "updateAt": null,
        "comments": [],
        "tags": tags,
      };
      await postRef.set(post);
    } catch (e) {
      print("Error writing document: $e");
    }
  }

  Future<void> likePost(String postId) async {
    // Get the Firebase Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId == '') {
      return;
    }
    final likedFlag = await isPostLikedByUser(postId, userId);
    if (likedFlag) {
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('liked')
          .doc(userId)
          .delete();
    } else {
      // Get the current user document from the 'users' collection
      final userInfo = await userService.getUserById(userId);

      // Add the user document to the 'likes' subcollection of the post document
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('liked')
          .doc(userId)
          .set({
        'userId': userId,
        'username': userInfo?.username,
        'userAvatarUrl': userInfo?.avatar,
        'timestamp': Timestamp.now(),
      });
    }
  }

  Future<bool> isPostLikedByUser(String postId, String userId) async {
    final DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);
    final DocumentSnapshot postDoc = await postRef.get();
    final CollectionReference likedRef = postDoc.reference.collection('liked');
    final DocumentSnapshot likeDoc = await likedRef.doc(userId).get();
    return likeDoc.exists;
  }

  Future<List<Post>> getPostsByTag(String tagId) async {
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final postsSnapshot =
        await postsRef.where('tags', arrayContains: tagId).get();
    final posts = postsSnapshot.docs.map((doc) async {
      final id = doc.id;
      // get num likes
      final likesRef = doc.reference.collection('liked');
      final likesSnapshot = await likesRef.get();
      final numLikes = likesSnapshot.size;

      // get createAt
      final Timestamp createAt;
      createAt = doc["createAt"];
      DateTime createAtDateTime = createAt.toDate();
      DateTime now = DateTime.now();
      Duration difference = now.difference(createAtDateTime);
      String timeAgo = '';
      if (difference.inDays < 31) {
        timeAgo = difference.toString() + " ngày trước";
      } else if (difference.inDays < 365) {
        difference = difference ~/ 30;
        timeAgo = difference.toString() + " tháng trước";
      } else {
        difference = difference ~/ 365;
        timeAgo = difference.toString() + " năm trước";
      }
      // get author info
      final author = await userService.getUserById(doc['authorId']);

      List<Future<Tag>> tagFutures = [];
      for (int i = 0; i < doc['tags'].length; i++) {
        tagFutures.add(tagService.getTagById(doc['tags'][i]));
      }
      final tags = await Future.wait(tagFutures);
      return Post(
        id: id,
        author: author!.username,
        timeAgo: timeAgo,
        content: doc['content'].toString(),
        likes: numLikes,
        comments: doc['comments'],
        shares: 3,
        imageUrl: doc['imageUrls'],
        avatarUrl: author.avatar,
        tags: tags,
      );
    }).toList();

    return await Future.wait(posts);
  }
}
