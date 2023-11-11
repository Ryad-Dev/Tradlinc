
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/screens/produit_view.dart';


class FirstTab extends StatefulWidget {
  final String uid;

    const FirstTab({Key? key, required this.uid}) : super(key: key);

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      //.orderBy('datePublished',descending: true) 
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                       // mainAxisSpacing :2.0,
                         crossAxisSpacing :3.0,
                       
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                           //  padding: const EdgeInsets.all(1.0);

                        return GestureDetector(
                          onTap:()=> Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {

                      
                        return PostView(
                        
                        postId: (snapshot.data! as dynamic).docs[index]['postId']
                        );
                      }

                     
                    ),),
                          child: Container(
                            decoration: const BoxDecoration(
                        //      borderRadius: BorderRadius.circular(30)
                            ),
                          //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)) ,
                          //  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                            child: Image(
                              image: NetworkImage(snap['postUrl']),
                               fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
  }
}