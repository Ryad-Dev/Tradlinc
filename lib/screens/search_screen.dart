
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/screens/produit_view.dart';
import 'package:tradlinc/utils/colors.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor:primaryColor,
        elevation: 0,
        title: TextFormField(
          controller: searchController,
          decoration:
              const InputDecoration(
                fillColor:Colors.black,
                prefixIcon:Icon(CupertinoIcons.search),
                iconColor: Colors.black,
             //  hoverColor:Colors.black,
              // focusColor:Colors.black,
                prefixIconColor:Colors.black,
                labelText: 'Rechercher...'),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowUsers = true;
            });
            print(_);
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where(
                    'name',
                    isEqualTo: searchController.text,
                  )
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
                    return InkWell(
                      onTap: ()=> Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {

                      
                        return PostView(
                        
                        postId: (snapshot.data! as dynamic).docs[index]['postId']
                        );
                      }

                     
                    ),),
                      child: ListTile(
                        leading: (snapshot.data! as dynamic).docs[index]['postUrl']==""? const CircleAvatar(
                          backgroundImage:AssetImage("assets/defaultprofilepic.jpg"),
                          radius: 18,
                        ):
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['postUrl'],
                          ),
                          radius: 18,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['name'],style: const TextStyle(color:Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  //.orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return  GridView.builder(
                  //    shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 1.5,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: GestureDetector(
                            onTap: ()=> Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>PostView(
                        postId: (snapshot.data! as dynamic).docs[index]['postId']
                        )
                    ),),
                            child: Image.network((snapshot.data! as dynamic).docs[index]['postUrl'],
                                              fit: BoxFit.cover,
                                            ),
                          ),
                        ),
                      ),
                    );
                    
                    
                    
                    
                    /*StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );*/
              },
            ),
    );
  }
}
