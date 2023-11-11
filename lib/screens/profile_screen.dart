import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:tradlinc/resources/auth_methods.dart';
import 'package:tradlinc/resources/dynamic_link.dart';
import 'package:tradlinc/screens/enregistrement.dart';
import 'package:tradlinc/screens/login_screen.dart';
import 'package:tradlinc/screens/parametres.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:tradlinc/widgets/follow_button.dart';
import 'package:tradlinc/screens/profile_tab_1.dart';
import 'package:tradlinc/screens/profile_tab_2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments_screen.dart';
import 'modifier_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  // final snap;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int feedBackLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  double rating = 0;
//String? get commentId {return commentId;}

  profilmenuSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.4,
              maxChildSize: 0.7,
              minChildSize: 0.3,
              builder: ((context, scrollController) => Column(
                    children: <Widget>[
                      const Icon(
                        CupertinoIcons.minus,
                        size: 50,
                        color: Colors.grey,
                      ),
                      ListTile(
                        leading: const Icon(CupertinoIcons.settings_solid,
                            color: Colors.black),
                        title: const Text("Parametres",
                            style: TextStyle(color: Colors.black)),
                        onTap: (() => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Parametres(),
                              ),
                            )),
                      ),
                      ListTile(
                        leading: const Icon(CupertinoIcons.person_crop_circle,
                            color: Colors.black),
                        title: const Text("Modifier le Profil",
                            style: TextStyle(color: Colors.black)),
                        onTap: (() => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>  ModifierProfil(uid:userData['uid'],),
                              ),
                            )),
                      ),
                      ListTile(
                        leading: const Icon(CupertinoIcons.bookmark_fill,
                            color: Colors.black),
                        title: const Text("Enregistrements",
                            style: TextStyle(color: Colors.black)),
                        onTap: (() => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Enregistrement(uid: userData['uid'],),
                              ),
                            )),
                      ),
                       ListTile(
                   leading:
                       const Icon(CupertinoIcons.link, color: Colors.black),
                   title: const Text("Lien du compte",
                       style: TextStyle(color: Colors.black)),
                   onTap:   () => DynamicLinkProvider()
                     .createLink("profile")
                     .then((value) {
                 //  Share.share(value);
                 }),),
                    ],
                  )));
        });
  }

  profilSignOutSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.3,
              maxChildSize: 0.5,
              minChildSize: 0.3,
              builder: ((context, scrollController) => Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  const Icon(
                    CupertinoIcons.minus,
                    size: 70,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      userData['photoUrl'] == null
                          ? const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  "assets/defaultprofilepic.jpg"),
                              /*  backgroundImage: NetworkImage(
               "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fdefault-profile-picture&psig=AOvVaw1ySoLVlhX8Msfb7ownbhVA&ust=1670773204768000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCPDpgK2x7_sCFQAAAAAdAAAAABAEs",
                   )*/
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                userData['photoUrl'],
                              ),
                            ),
                      const Icon(CupertinoIcons.check_mark),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.square_arrow_left,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: const Text("Deconnexion",
                        style: TextStyle(color: Colors.black)),
                    onTap: () async {
                      await AuthMethods().signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              )));
        });
  }

  @override
  void initState() {
    super.initState();
    getData();
    //fetchCommentLen();
    //  initDynamicLinks();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      var feedBackSnap = await FirebaseFirestore.instance
          .collection('feedBack')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      feedBackLen = feedBackSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
/*
  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('feedBack')
          .doc(widget.uid[feedBackId])
          .collection('feedBack')
          .get();
      feedBackLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
          child: CircularProgressIndicator(
            value: 10,
            color: blueColor,
            backgroundColor:primaryColor,
          ),
        )
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: primaryColor,
              appBar: AppBar(
                elevation: 0,
                foregroundColor: blackColor,
                backgroundColor: primaryColor,
                title: InkWell(
                  onTap: profilSignOutSheet,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userData['username'],
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_down,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                ),
                centerTitle: true,
                actions: [
                   userData['uid']==FirebaseAuth.instance.currentUser!.uid ?
                  IconButton(
                      onPressed: profilmenuSheet,
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.black,
                      )):
                      IconButton(
                      onPressed:(){},
                      icon: const Icon(
                        CupertinoIcons.bell,
                        color: Colors.black,
                      )),

                  /* FollowButton(
                          text: 'Sign',
                          backgroundColor: primaryColor,
                          textColor: Colors.black,
                          borderColor: Colors.grey,
                          function: () async {
                            await AuthMethods().signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        )*/
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  userData['photoUrl'] == ""
                      ? const CircleAvatar(
                          // backgroundColor: Colors.grey,
                          backgroundImage:
                              AssetImage("assets/defaultprofilepic.jpg"),
                          //  NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'
                          // userData['photoUrl'],
                          //     ),
                          radius: 47,
                        )
                      : CircleAvatar(
                          // backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userData['photoUrl']),
                          radius: 45,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      userData['username'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    //   mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildStatColumn("$postLen", "Posts"),
                   //   const SizedBox(
                   //     width: 24,
                    //  ),
                   //   buildStatColumn('$rating', "Stars"),
                      const SizedBox(
                        width: 16,
                      ),
                      buildStatColumn("$feedBackLen", "Retours"),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const profileButton(
                        function: openWhatsApp,
                        color: Color.fromRGBO(37, 211, 102, 1),
                        borderColor: Color.fromRGBO(37, 211, 102, 1),
                        icon: Icon(
                          FontAwesomeIcons.whatsapp,
                          size: 25,
                          color: primaryColor,
                        ),
                      ),
                    
                      const SizedBox(
                        width: 15,
                      ),
                      profileButton(
                        function: () {},
                        borderColor: Colors.blue,
                        color: blueColor,
                        icon: const Icon(
                          CupertinoIcons.phone_fill,
                          size: 23,
                          color: primaryColor,
                        ),
                      ),

                    userData['uid']==FirebaseAuth.instance.currentUser!.uid ?
                    Container():
                    Row(children: [
const SizedBox(
                        width: 15,
                      ),
 profileButton(
                        function: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                    myuid: userData['uid'],
                                  )),
                        ),
                        borderColor: Colors.orangeAccent,
                        color: Colors.orangeAccent,
                        icon: const Icon(
                          CupertinoIcons.pen,
                          size: 25,
                          color: primaryColor,
                        ),
                      ),
                    ],),
                      
                      
                    ],
                  ),
               /*   const SizedBox(
                    height: 10,
                  ),
                  RatingBar.builder(
                      minRating: 0,
                      itemSize: 30,
                      maxRating: 3,
                      itemCount : 3,
                      glowColor:Colors.orangeAccent,
                      unratedColor: Colors.grey,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                      updateOnDrag: true,
                      itemBuilder: (Context, _) => const Icon(
                            CupertinoIcons.star_fill,
                            color: Colors.orangeAccent,
                            size: 30,
                          ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          this.rating = rating;
                          //  ${widget.snap['stars'].length}
                        });
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 15,
                    child: Text('$rating'),
                  ),*/
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['bio'],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.map_pin,
                        color: Colors.red,
                      ),
                      const Text("Localisation")
                    ],
                  ),


                  //TabBar
                  const TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.grid_on_outlined,
                          color: Colors.black,
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.menu_rounded, color: Colors.black),
                      ),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    FirstTab(
                      uid: userData['uid'],
                    ),
                    SecondTab(
                      uid: userData['uid'],
                      //widget.snap['feedid'].toString(),
                    ),
                  ])),
                ],
              ),
            ),
          );
  }

  Column buildStatColumn(String num, String label) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.w400,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

void openWhatsApp() async {
  String phoneNumber = '+229 52825612';
  var url =
      'https://wa.me/$phoneNumber?text=Je suis interesse par vos produits sur Tradlinc';
  await launch(url);
}

class Skeleton extends StatelessWidget {
  Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

//const Color primaryColor = Color(0xFF2967FF);
  Color grayColor = const Color(0xFF8D8D8E);

  double defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 110}) : super(key: key);

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

class ProfilCardSkelton extends StatelessWidget {
  const ProfilCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryColor,
        width: width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const CircleSkeleton(),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              width: 110,
              height: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              width: 200,
              height: 35,
            ),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              width: 200,
              height: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              width: 200,
              height: 25,
            ),
          ],
        ));
  }
}
