import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradlinc/models/feedBack.dart';
import 'package:tradlinc/models/post.dart';
import 'package:tradlinc/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      String name,
      String price,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      String selectCurrency,
      String selectCategorie) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        likes: [],
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        name: name,
        price: price,
        selectCurrency: selectCurrency,
        selectCategorie: selectCategorie,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postFeedBack( String comment, String uid,String myuid,
      String username, String profImage) async {
    String res = "Some error occurred";
    try {
      if (comment.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String feedBackId = const Uuid().v1();
        FeedBack feedBack = FeedBack(
            comment: comment,
            uid: uid,
            myuid: myuid ,
            username: username,
            feedBackId: feedBackId,
            datePublished: DateTime.now(),
            profImage: profImage);
        _firestore
            .collection('feedBack')
            .doc(feedBackId)
            .set(feedBack.toJson());
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> rate(double rating, String uid, List stars) async {
    String res = "Some error occurred";
    try {
      if (stars.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('users').doc(uid).update({
          'stars': FieldValue.arrayRemove([uid]),
          'stars': FieldValue.arrayUnion([uid]),
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('users').doc(uid).update({
          'stars': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  /* FireStoreMethods().rate(
                widget.snap['uid'].toString(),
                user.uid,
                widget.snap['stars'],
              );*/
  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
    Future<String> deleteComment(String feeBackId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('feedBack').doc(feeBackId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}



 /* Future<void> followUser(
    String uid,
    String fedBackId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    //  List feedBack = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(fedBackId).update({
          'retours': FieldValue.arrayRemove([uid])
        });

     /*   await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });*/
      } else {
        await _firestore.collection('users').doc(fedBackId).update({
          'retours': FieldValue.arrayUnion([uid])
        });

      /*  await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });*/
      }

    } catch(e) {
      print(e.toString());
    }
  }*/

