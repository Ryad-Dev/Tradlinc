
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradlinc/models/user.dart' as model;
import 'package:tradlinc/providers/user_provider.dart';
import 'package:tradlinc/resources/firestore_methods.dart';
import 'package:tradlinc/screens/comments_screen.dart';
import 'package:tradlinc/utils/colors.dart';

import 'package:tradlinc/utils/utils.dart';
import 'package:tradlinc/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'feed_screen.dart';

class PostView extends StatefulWidget {
  final postId;
  const PostView({
    Key? key,
      required this.postId
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLikeAnimating = false;
  var postData = {};
  final controller = ScreenshotController();

@override
  void initState() {
    super.initState();
    getData();
  }

    getData() async {
    setState(() {
      var isLoading = true;
    });
    try {
    
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();
     postData=postSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
   
    setState(() {
      var isLoading = false;
    });
  }

     deletebottomSheet() {
    return showModalBottomSheet(
        context: context,
         isScrollControlled: true,
        
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.15,
            maxChildSize: 0.7,
            minChildSize: 0.1,
            builder: ((context, scrollController) => Column(
                  children: <Widget>[
                  ListTile(
                    leading: const Icon(CupertinoIcons.trash,
                        color: Colors.black),
                    title: const Text("Supprimer",
                        style: TextStyle(color: Colors.black)),
                    onTap:  () {
                                  deletePost(
                                    postData['postId'].toString(),
                                  );
                                   Navigator.of(context).pop();}),

                ListTile(
                  leading:
                      const Icon(CupertinoIcons.clear, color: Colors.black),
                  title: const Text("Annuler",
                      style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                  ],
                )));
      
        });
     }

  

     sharebottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.15,
              maxChildSize: 0.7,
              minChildSize: 0.1,
              builder: ((context, scrollController) => Column(
                    children: <Widget>[
                    
                      ListTile(
                        leading: const Icon(CupertinoIcons.share,
                            color: Colors.black),
                        title: const Text("Partager",
                            style: TextStyle(color: Colors.black)),
                        onTap: () async {
                final image = await controller.capture();
                if (image == null) return;

                //await saveImage(image);
               // saveAndShare(image);
              },
                      ),
                       ListTile(
                   leading:
                       const Icon(CupertinoIcons.arrow_down, color: Colors.black),
                   title: const Text("Enregistrer",
                       style: TextStyle(color: Colors.black)),
                   onTap:    () async {
                final image = await controller.capture();
                if (image == null) return;

                await saveImage(image);
              },
                 ),
                    ],
                  )));
        });
     }



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
    var RandomColors ={
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
     };
    var  defaultColor = Colors.blue;
   
     applyRandomColor(){
      var rndColor = Random().nextInt(RandomColors.length);
      setState((){
    //    defaultColor = RandomColors[rndColor].;
      });
     }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:Colors.blue,
      appBar: AppBar(
        backgroundColor:Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // snap['uid'].toString() == user.uid
          // ?
          IconButton(
            onPressed: deletebottomSheet,
            icon: const Icon(
              CupertinoIcons.trash,
              //size: 30,
              //color: Colors.blue,
            ),
          )
        ],
      ),
      body: 
           /*  snapshot.connectionState == ConnectionState.waiting ?
             Center(
              child: NewsCardSkelton(),
            ):*/
      
       Screenshot(
        controller:controller,
         child: Container(
            width: size.width ,
            height: size.width * 1.5,
            color: Colors.red,
           child: Center(
            child: 
                Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40,),
                    Container(
                      width: size.width * 0.8,
                      height: size.width * 1.2,
                      // boundary needed for web
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                       // color: Colors.grey.withOpacity(0.5),
                       color: Colors.white
                      
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // HEADER SECTION OF THE POST
              
             
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 18,
                            ).copyWith(right: 0),
                            child: Row(
                              children: <Widget>[
                                postData['photoUrl']==null?
                                CircleAvatar(
                                  radius: 17,
                                  backgroundImage: AssetImage("assets/defaultprofilepic.jpg"),
                                      /*  backgroundImage: NetworkImage(
                                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fdefault-profile-picture&psig=AOvVaw1ySoLVlhX8Msfb7ownbhVA&ust=1670773204768000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCPDpgK2x7_sCFQAAAAAdAAAAABAEs",
                                    )*/):
                                CircleAvatar(
                                  radius: 17,
                                  backgroundImage: NetworkImage(
                                   postData['photoUrl']
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                         postData['username'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // IMAGE SECTION OF THE POST
                          Container(
                            height: size.width * 0.7,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                                image:  DecorationImage(
                                    image: NetworkImage(postData['postUrl']
                                     
                                       ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          // LIKE, COMMENT SECTION OF THE POST
                            Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20,top : 10),
                      child: Text(
                        postData['name'],
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),),
                   Container(
                  margin: EdgeInsets.only(left: 5,top : 15),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  
                    child: Text(postData['selectCategorie'],style: TextStyle(fontSize: 10),),
                   ),
       
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        
                          Container(
                          padding: EdgeInsets.only(top : 15),
                            child: Text(
                               postData['selectCurrency'],
                              style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                           // padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          Container(
                          padding: EdgeInsets.only(right: 25,top : 10),
                            child: Text(
                               postData['price'],
                              style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                           // padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                        ],
                      )
                  ),
                ],
              ),
                          //DESCRIPTION ET DATE DE PUBLICATION
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 5,right: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              postData['description'],
                              style: const TextStyle(fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, top: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                               DateFormat.yMMMd().format(postData['datePublished'].toDate()),
                            
                              style: const TextStyle(fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
           
            
            
             ),
         ),
       ),
      
      floatingActionButton: Column(
       // crossAxisAlignment: CrossAxisAlignment.end,
       mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox.fromSize(
            size: Size.square(45),
            child: FloatingActionButton(onPressed: applyRandomColor,
                elevation: 10,
                backgroundColor:primaryColor,
                child:Icon( Icons.palette_rounded,size: 25,color:blueColor ,
               )
                ),
          ),
      SizedBox(height: 10,),
          FloatingActionButton(onPressed: sharebottomSheet,
      elevation: 10,
      backgroundColor: Colors.blue,
      child:Icon( CupertinoIcons.arrowshape_turn_up_right_fill,size: 30,
             )
      ),
        ],
      )
    );
  }

   /* Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    final text="";
    /await Share.shareFiles([image.path],text: text);
  }*/

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = "Tradlinc_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }

 /* Widget buildImage() => Image.network(
    postData['postUrl'],
        fit: BoxFit.cover,
      );*/
}
