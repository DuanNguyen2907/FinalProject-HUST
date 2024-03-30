class Post {
  final String author;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final String imageUrl;
  final String avatarUrl;

  Post({
    required this.author,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.imageUrl,
    required this.avatarUrl,
  });
}
