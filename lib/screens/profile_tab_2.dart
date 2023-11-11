import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/comment_card.dart';


class SecondTab extends StatefulWidget {
  final String? uid;
  final feedBaackId;
  const SecondTab({super.key, required this.uid, this.feedBaackId});

  @override
  State<SecondTab> createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('feedBack')
           // .orderBy('datePublished',descending: true)
           .where('uid', isEqualTo: widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
              return CommentCard(snap:snap);
            },
          ); 


          
        });
  }
}
