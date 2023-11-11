import 'package:flutter/material.dart';
import 'package:tradlinc/models/user.dart';
import 'package:tradlinc/providers/user_provider.dart';
import 'package:tradlinc/resources/firestore_methods.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final myuid;
  const CommentsScreen({Key? key, required this.myuid}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController feedController =
      TextEditingController();
      


  void postFeedBack(String uid,String myuid, String username, String profImage) async {
    try {
      String res = await FireStoreMethods().postFeedBack(

        feedController.text,
        myuid,
        uid,
        username,
        profImage,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        feedController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("Add feedback"),
      ),
    
      body: Column(
        children: [
          Container(
            height: 100,
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 20,
                ),
                
                Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text( '${user.username}',style: TextStyle(fontSize: 25),),
              ),
            ),
                
                InkWell(
                  onTap: () => postFeedBack(
                    user.uid,
                    widget.myuid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Publier',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: feedController,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    hintStyle: const TextStyle(fontSize: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
