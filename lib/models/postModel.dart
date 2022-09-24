import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postContent;
  final String postTitle;
  final String uid;
  final String username;
  final String profImage;
  final likes;
  final String postId;
  final String name;
  final DateTime datePublished;

  const Post({
    required this.name, 
    required this.postContent,
    required this.postTitle,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.profImage,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        uid: snapshot["uid"],
        name: snapshot["name"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        profImage: snapshot['profImage'],
        postContent: snapshot['postContent'],
        postTitle: snapshot['postTitle']);
  }

  Map<String, dynamic> toJson() => {
        "postContent" : postContent,
        "postTitle" : postTitle,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'profImage': profImage,
        "name" :name,
      };
}
