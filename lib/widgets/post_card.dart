import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/models/user.dart' as model;
import 'package:tradlinc/providers/user_provider.dart';
import 'package:tradlinc/resources/firestore_methods.dart';
import 'package:tradlinc/screens/profile_screen.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:tradlinc/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
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
            ).copyWith(right:0),
            child: GestureDetector(
              onTap:  ()=> Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>ProfileScreen(
                      uid:widget.snap['uid'],
                        )
                    ),),
              child: Row(
                children: <Widget>[
                  widget.snap['profImage'] == ""
                      ? const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("assets/defaultprofilepic.jpg"),
                          /*backgroundImage: NetworkImage(
                        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fdefault-profile-picture&psig=AOvVaw1ySoLVlhX8Msfb7ownbhVA&ust=1670773204768000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCPDpgK2x7_sCFQAAAAAdAAAAABAEs",
                      )*/
                        )
                      : CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(
                            widget.snap['profImage'],
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      widget.snap['uid'].toString() == user.uid
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: ListView(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shrinkWrap: true,
                                          children: [
                                            'Delete',
                                          ]
                                              .map(
                                                (e) => InkWell(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                    onTap: () {
                                                      deletePost(
                                                        widget.snap['postId']
                                                            .toString(),
                                                      );
                                                      // remove the dialog box
                                                      Navigator.of(context).pop();
                                                    }),
                                              )
                                              .toList()),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      widget.snap['uid'].toString() == user.uid
                          ? Container()
                          : LikeAnimation(
                              isAnimating:
                                  widget.snap['likes'].contains(user.uid),
                              smallLike: true,
                              child: IconButton(
                                icon: widget.snap['likes'].contains(user.uid)
                                    ? const Icon(
                                        CupertinoIcons.bookmark_fill,
                                        color: Colors.orangeAccent,
                                      )
                                    : const Icon(CupertinoIcons.bookmark_fill,
                                        color: Colors.grey),
                                onPressed: () => FireStoreMethods().likePost(
                                  widget.snap['postId'].toString(),
                                  user.uid,
                                  widget.snap['likes'],
                                ),
                              ),
                            ),
                    ],
                  ),
                 const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
             const   Center(
                  child: Text("Chargement..."),
                ),
                Container(
                  height: size.width * 0.9,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              NetworkImage(widget.snap['postUrl'].toString()),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(25)),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      CupertinoIcons.bookmark_fill,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: <Widget>[
              Container(
                padding:const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  ' ${widget.snap['name']}',
                  style: const TextStyle(
                    fontSize:17 ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
               Container(
            
                margin:const EdgeInsets.only(left: 3, top: 10),
                padding:const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                child: Text(
                  '${widget.snap['selectCategorie']}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:const EdgeInsets.only(top: 15),
                    child: Text(
                      '${widget.snap['selectCurrency']}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  Container(
                    padding:const EdgeInsets.only(right: 25, top: 10),
                    child: Text(
                      ' ${widget.snap['price']}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ],
              )),
            ],
          ),
          //DESCRIPTION ET DATE DE PUBLICATION
         
          Container(
            padding:const EdgeInsets.only(left: 25, top: 5, right: 100),
            alignment: Alignment.centerLeft,
            child: Text(
              ' ${widget.snap['description']}',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding:const EdgeInsets.only(left: 25, top: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
