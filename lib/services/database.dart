import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post.dart';

class DatabaseService {
  Future<List<Post>> getPosts() async {
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final postsSnapshot = await postsRef.get();
    final posts = postsSnapshot.docs.map((doc) async {
      final likesRef = doc.reference.collection('liked');
      final likesSnapshot = await likesRef.get();
      final numLikes = likesSnapshot.size;

      return Post(
        author: 'DuanNC',
        timeAgo: "1 ngày trước",
        content: doc['context'].toString(),
        likes: numLikes,
        comments: 3,
        shares: 3,
        imageUrl: doc['imageUrls'][0],
        avatarUrl:
            'https://vn.images.search.yahoo.com/yhs/view;_ylt=AwrKDyXZ_xFm_b8p232.LIpQ;_ylu=c2VjA3NyBHNsawNpbWcEb2lkA2FhOWIxYWE4YjRmYzRjNDcwM2JkYjdmODg0ZDFkMDUzBGdwb3MDMQRpdANiaW5n?back=https%3A%2F%2Fvn.images.search.yahoo.com%2Fyhs%2Fsearch%3Fp%3D%25E1%25BA%25A3nh%26ei%3DUTF-8%26type%3Dmsff_9373_FFW_ZZ%26fr%3Dyhs-iba-3%26hsimp%3Dyhs-3%26hspart%3Diba%26tab%3Dorganic%26ri%3D1&w=2048&h=1368&imgurl=khoinguonsangtao.vn%2Fwp-content%2Fuploads%2F2022%2F08%2Fhinh-anh-meo-cute-doi-mat-to-tron-den-lay-de-thuong.jpg&rurl=https%3A%2F%2Fcdgdbentre.edu.vn%2Fhinh-nen-hinh-anh-meo-de-thuong-1inhdqp0%2F&size=318.8KB&p=%E1%BA%A3nh&oid=aa9b1aa8b4fc4c4703bdb7f884d1d053&fr2=&fr=yhs-iba-3&tt=Top+v%E1%BB%9Bi+h%C6%A1n+65+v%E1%BB%81+h%C3%ACnh+n%E1%BB%81n+h%C3%ACnh+%E1%BA%A3nh+m%C3%A8o+d%E1%BB%85+th%C6%B0%C6%A1ng+-+cdgdbentre.edu.vn&b=0&ni=160&no=1&ts=&tab=organic&sigr=iBmASqrqkD3p&sigb=HuKA7L7JBVjk&sigi=iEMjpLMxrf7T&sigt=mWYo3COuXEP.&.crumb=QjVZXa3FMM1&fr=yhs-iba-3&hsimp=yhs-3&hspart=iba&type=msff_9373_FFW_ZZ',
      );
    }).toList();

    return await Future.wait(posts);
  }
}
