import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final String contact;
  final String location;

  //final List followers;
  //final List following;
   final stars;
  


   User(
      {required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.contact,
      required this.location,
      //required this.followers,
      //required this.following, 
      required this.stars,
     
      });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data()! as Map<String, dynamic>;
    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      contact: snapshot["contact"],
      location: snapshot["location"],
      //followers: snapshot["followers"],
      //following: snapshot["following"], 
      stars: snapshot["stars"],

    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "contact":contact,
        //"followers": followers,
        //"following": following,
        "stars":stars,
        "location":location,
      };
}
