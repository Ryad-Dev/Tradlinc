
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedBack {
  final String comment;
  final String uid;
  final String myuid;
  final String username;
  // final likes;
  final String feedBackId;
  final DateTime datePublished;
  final String profImage;

  const FeedBack({
    required this.comment,
    required this.uid,
    required this.myuid,
    required this.username,
    // required this.likes,
    required this.feedBackId,
    required this.datePublished,
    required this.profImage,
  });

  static FeedBack fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return FeedBack(
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      profImage: snapshot['profImage'],
      comment: snapshot['comment'],
      feedBackId: snapshot['feedBackId'],
      uid: snapshot['uid'],
      myuid: snapshot['myuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "uid": uid,
        "myuid": myuid,
        // "likes": likes,
        "username": username,

        "datePublished": datePublished,

        'profImage': profImage,
      };
}
