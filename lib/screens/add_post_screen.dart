import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradlinc/providers/user_provider.dart';
import 'package:tradlinc/resources/firestore_methods.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  final snap;
  const AddPostScreen({Key? key, this.snap}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
   Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<String> Categorie = [
    "Chaussures",
    "Jouet",
    "Vetement",
    "Sac",
    "Electronique",
    "Cosmetics",
    "Accessoire",
    "Fourniture",
    "Autres"
  ];
  String selectCategorie = "Chaussures";
  List<String> Currency = [
    "CFA",
    "USD",
    "€",
    "₦",
    "£",
    "R",
    
  ];
  String selectCurrency = "CFA";
 
     imagebottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: const Color(0xFF737373),
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(CupertinoIcons.photo_camera,
                          color: Colors.black),
                      title: const Text("Prendre a photo",
                          style: TextStyle(color: Colors.black)),
                      onTap: () async {
                        Navigator.pop(context);
                        Uint8List file = await pickImage(ImageSource.camera);
                        setState(() {
                          _file = file;
                        });
                      }),
                  ListTile(
                      leading:
                          const Icon(CupertinoIcons.photo, color: Colors.black),
                      title: const Text("Choisir depus galerie",
                          style: TextStyle(color: Colors.black)),
                      onTap: () async {
                        Navigator.of(context).pop();
                        Uint8List file = await pickImage(ImageSource.gallery);
                        setState(() {
                          _file = file;
                        });
                      }),
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
              ),
            ),
          );
        });
  }

 // Future<Uint8List?> cropImage( Uint8List _file)async{
 //     CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: _file);
 // }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _nameController.text,
        _priceController.text,
        _file!,
        uid,
        username,
        profImage,
        selectCurrency,
        selectCategorie
       
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Scaffold(
          backgroundColor: primaryColor,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
            
                SizedBox(
                  height:MediaQuery.of(context).size.width / 1.7,
                  width :MediaQuery.of(context).size.width / 1.7,
                  child: Image.asset("assets/add.png")),
                   const SizedBox(height:30),
                  SizedBox(
                  //  height:MediaQuery.of(context).size.width / 3,
                  width :MediaQuery.of(context).size.width / 1.3,
                    child:
                 const   Text("Creer des Tradlincs et partager avec vos potentiels clients",style: TextStyle(color: Colors.grey,fontSize: 15,),),
                  ),
                   SizedBox(height:MediaQuery.of(context).size.width / 4,),
                InkWell(
                  onTap: () =>imagebottomSheet(),
                  child: Row(
                    children: [
                      const SizedBox(width: 16,),
                      Container(
                        height: 50,
                        width: size.width * 0.9,
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
                const SizedBox(
                  height: 60,
                )
              ],
            ),
        )
        : Scaffold(
          backgroundColor: primaryColor,
            appBar: AppBar(
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  child: const Text(
                    "Publier",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                 /*    widget.snap['profImage']==null?
                   const CircleAvatar(
                  radius: 20,
                  backgroundImage:AssetImage("assets/defaultprofilepic.jpg"),
                      /*  backgroundImage: NetworkImage(
                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fdefault-profile-picture&psig=AOvVaw1ySoLVlhX8Msfb7ownbhVA&ust=1670773204768000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCPDpgK2x7_sCFQAAAAAdAAAAABAEs",
                    )*/):
                CircleAvatar(
                  radius: 20,
                 
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),*/
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Description...",
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                
         /*       Container(
         padding: const EdgeInsets.symmetric(vertical:1, horizontal: 20),
        height: 50,
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withAlpha(50)),
        child: TextField(
          cursorColor: Colors.blue,
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Nom", 
            hintStyle:TextStyle(color: Colors.black),
            iconColor: Colors.black,
            border: InputBorder.none,
            //focusedBorder: inputBorder,
            // enabledBorder: inputBorder,
            //filled: true,
            //contentPadding: const  EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          ),
          keyboardType: TextInputType.text,
          obscureText: false,
        )),
        ),*/
        Container(
            padding: const EdgeInsets.symmetric(vertical:1, horizontal: 24),
      width: size.width * 0.9,
      child: TextField(
        cursorColor: Colors.black,
        controller: _nameController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Nom du produit",
          hintStyle: const TextStyle(color: Colors.black),
          border:InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.black)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        keyboardType:TextInputType.text,
       
      ),
    ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                 margin: const EdgeInsets.symmetric(vertical: 1),
                  child: Row(
                    children: [
                       const SizedBox(
                  width: 25,
                ),
                      Container(
         padding: const EdgeInsets.symmetric(vertical:1, horizontal: 20),
        height: 50,
        width: size.width * 0.6,
       // decoration: BoxDecoration(
       //     borderRadius: BorderRadius.circular(10),
        //    color: Colors.grey.withAlpha(50)),
        child: TextField(
          cursorColor: Colors.blue,
          controller: _priceController,
          decoration: InputDecoration(
            hintText: "Prix", 
            hintStyle:const TextStyle(color: Colors.black),
            iconColor: Colors.black,
            border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.black)),
            //contentPadding: const  EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          ),
          keyboardType: TextInputType.number,
          obscureText: false,
        )),
      //  SizedBox(
      //            width: 5,
       //         ),
        Container(
          height: 50,
                    width: size.width * 0.2,
    
                    child: DropdownButtonFormField<String>(
                      style:const TextStyle(color: Colors.black),
                      dropdownColor:Colors.grey,
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black),
                          iconColor: Colors.black,
                          border: InputBorder.none,
                          focusedBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                             borderSide: const BorderSide(color: Colors.black)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                             borderSide: const BorderSide(color: Colors.black)
                          )),
                      value: selectCurrency,
                      items: Currency.map((item) => DropdownMenuItem<String>(
                          value: item, child: Text(item))).toList(),
                      onChanged: (Currency) =>
                          setState(() => selectCurrency = Currency!),
                    ),
                  ),
                 /*  SizedBox(
                  width: 35,
                ),*/

                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  width: size.width * 0.8,
                 
                  child: DropdownButtonFormField<String>(
                    style:const TextStyle(color: Colors.black),
                    dropdownColor:Colors.grey,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        iconColor: Colors.black,
                        border: InputBorder.none,
                        focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.black)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                           borderSide: const BorderSide(color: Colors.black)
                        )),
                    value: selectCategorie,
                    items: Categorie.map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item))).toList(),
                    onChanged: (Categorie) =>
                        setState(() => selectCategorie = Categorie!),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              /*  InkWell(
                  onTap: (){},
                  child: Button(text: "Post",)
                ),*/
                
              ],
            ),
          /*  body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userProvider.getUser.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),*/
          );
  }
}


