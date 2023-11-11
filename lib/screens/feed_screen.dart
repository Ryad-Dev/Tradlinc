import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tradlinc/screens/search_screen.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/widgets/button.dart';
import 'package:tradlinc/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}


class _FeedScreenState extends State<FeedScreen> {

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

/*
    @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
        /*  if (!isDeviceConnected && isAlertSet == false) {
           // showDialogBox();
            setState(() => isAlertSet = true
            );
          }*/
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar:AppBar(
              backgroundColor:  primaryColor,
              centerTitle: true,
              elevation: 1,
              title: const Image(image: AssetImage("assets/logobleu.png",),
              width: 50,
              height: 50,
              ),
              actions: [
                IconButton(onPressed: (() => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            )), icon: const Icon(CupertinoIcons.search,color: Colors.black,))
              ],
            ),
      body: /*  !isDeviceConnected && isAlertSet == false ?
          //  setState(() => isAlertSet = true):
         Container(

          height:   MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              children: [
                Text("No connection"),
                Text("Verifier votre connection internet puis reessayer"),
                InkWell(
                  onTap: ()async {
                   final result = await Connectivity().checkConnectivity();
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 16,),
                      Container(
                          height:   MediaQuery.of(context).size.width /4,
                           width:  MediaQuery.of(context).size.width /2,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: Text(
                            "Creer un tradlinc",
                            style:
                                TextStyle(color: primaryColor,fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
         ):*/
        
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts')
        .orderBy('datePublished',descending: true)
        .get(),
        builder: (context, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: NewsCardSkelton(),
            );
          }
            return ListView.builder(
           // itemCount: snapshot.data!.docs.length,
            itemCount:  (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > 600 ? width * 0.3 : 0,
                vertical: width > 600 ? 15 : 0,
              ),
              child: PostCard(
                snap: (snapshot.data! as dynamic).docs[index].data(),
              ),
            ),
          );

          
          
        },
      ),
    );
  }
  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
               
               
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
  

class Skeleton extends StatelessWidget {
 Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;
  
//const Color primaryColor = Color(0xFF2967FF);
 Color grayColor = Colors.grey;

 double defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding:  EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius:
              const BorderRadius.all(Radius.circular(16))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          // boundary needed for web
          decoration: BoxDecoration(
            border: Border.all(
              color:Colors.white,
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              // HEADER SECTION OF THE POST
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 18,
                ).copyWith(right: 0),
                child: Row(
                  children: <Widget>[
                   
                   const CircleSkeleton(size: 45,),
                   
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Skeleton(
                 width: 90,
                   height:20,
              ),
                           
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox( height: 10,),
              // IMAGE SECTION OF THE POST
              Skeleton(
                height: 350,
              width: size.width * 0.9,
              ),
              const SizedBox( height: 20,),
              // LIKE, COMMENT SECTION OF THE POST
              Row(
                children: <Widget>[
                  const SizedBox( width: 20,),
                  Skeleton(
                   width: 90,
                   height: 20,
                  ),

                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomRight,
                    child: Skeleton(
                      width: 60,
                   height: 25,
                    ),

                  )
                  ),
                  const SizedBox( width: 20,),
                ],
              ),
              //DESCRIPTION ET DATE DE PUBLICATION

            ],
          ),
        ),
        
      ],
    );
              
  }
}