
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradlinc/utils/colors.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';



class CommentCard extends StatefulWidget {
  final snap;
  
  const CommentCard({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  deleteComment(String feedBackId) async {
    try {
      await FireStoreMethods().deletePost(feedBackId);
    } catch (err) {
      
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width,
      //  height: MediaQuery.of(context).size.width / 3 ,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  widget.snap['profImage'] == null
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/defaultprofilepic.png'),
                          radius: 20,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            widget.snap['profImage'],
                          ),
                          radius: 20,
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.snap['username'],
                      style: const TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child:  IconButton(
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
                                                    deleteComment(
                                                      widget.snap['feedBackId']
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
              )
            ],
          ),
          
          Text(widget.snap['comment'],
              style: const TextStyle(color: blackColor, fontSize: 18)),
          const SizedBox(
            height: 10,
          ),
          Text(
            DateFormat.yMMMd().format(
              widget.snap['datePublished'].toDate(),
            ),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
