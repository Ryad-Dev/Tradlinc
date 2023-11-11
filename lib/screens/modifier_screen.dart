import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/models/user.dart' as model;
//import '../widgets/button.dart';
import 'package:tradlinc/providers/user_provider.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class ModifierProfil extends StatefulWidget {
  final String uid;
  final snap;
  const ModifierProfil({super.key, required this.uid, this.snap});


  @override
  State<ModifierProfil> createState() => _ModifierProfilState();
}

class _ModifierProfilState extends State<ModifierProfil> {
  final TextEditingController _newusernameController = TextEditingController();
  final TextEditingController _newBioController = TextEditingController();
  final TextEditingController _newNumController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  var userData = {};


  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  @override
  void dispose() {
    super.dispose();
    _newNumController.dispose();
    _newBioController.dispose();
    _newusernameController.dispose();
  }
  void initState() {
    super.initState();
    getData();
    //fetchCommentLen();
    //  initDynamicLinks();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      Map userData = userSnap.data()! as Map;
       _newNumController.text=userData['contact'];
       _newBioController.text=userData['bio'];
       _newusernameController.text=userData['username'];
       _newusernameController.text=widget.snap['username'];
    //userData['location'];
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }


  imagebottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) {
          return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.3,
              maxChildSize: 0.3,
              minChildSize: 0.3,
              builder: ((context, scrollController) => Column(
                    children: <Widget>[
                      ListTile(
                          leading: const Icon(CupertinoIcons.photo_camera,
                              color: Colors.black),
                          title: const Text("Prendre a photo",
                              style: TextStyle(color: Colors.black)),
                          onTap: () async {
                            Navigator.pop(context);
                            Uint8List file =
                                await pickImage(ImageSource.camera);
                            setState(() {
                              _image = file;
                            });
                          }),
                      ListTile(
                          leading: const Icon(CupertinoIcons.photo,
                              color: Colors.black),
                          title: const Text("Choisir depus galerie",
                              style: TextStyle(color: Colors.black)),
                          onTap: () async {
                            Navigator.of(context).pop();
                            Uint8List file =
                                await pickImage(ImageSource.gallery);
                            setState(() {
                              _image = file;
                            });
                          }),
                      ListTile(
                        leading: const Icon(CupertinoIcons.clear,
                            color: Colors.black),
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

  @override
  Widget build(BuildContext context) {
        final model.User user = Provider.of<UserProvider>(context).getUser;
    Size size = MediaQuery.of(context).size;
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Modifier le profil"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
             onPressed: () {
              Map<String,String> userData= {
                'username': _newusernameController.text,
                'bio': _newBioController.text,
                'contact':_newNumController.text,
              };
              FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid).update(userData).then((value)=>{});
              FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.uid).update(widget.snap).then((value)=>{});
              FirebaseFirestore.instance
          .collection('feedBack')
          .doc(widget.uid).update(widget.snap).then((value)=>{});
              Navigator.pop(context);
            /*  userSnap.data()!.update(students).then((value)=>{
                Navigator.pop(context)
              });*/
            
          },
              icon: const Icon(
                CupertinoIcons.checkmark_alt,
                color: blueColor,size: 30,
              )),
        ],
        // centerTitle:true,
      ),
      body: FutureBuilder(
        future:FirebaseFirestore.instance
                      .collection('uid')
                      //.orderBy('datePublished',descending: true) 
                      //.where('uid', isEqualTo: widget.uid)
                      .get(),
        builder: (context, snapshot) => 
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: imagebottomSheet,
                child: _image != ""
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/defaultprofilepic.jpg"),
                         child: Icon(
                            CupertinoIcons.camera,
                            color: blackColor,
                          ),
                      )
                    :userData['photoUrl']==""? const CircleAvatar(
                        radius: 50,
                        // backgroundColor: Colors.grey.withOpacity(0.1),
                        backgroundImage:
                            AssetImage("assets/defaultprofilepic.jpg"),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.camera,
                            color: blackColor,
                          ),
                        ),
                      ):const CircleAvatar(
                        radius: 50,
                        // backgroundColor: Colors.grey.withOpacity(0.1),
                        backgroundImage:
                            AssetImage("assets/defaultprofilepic.jpg"),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.camera,
                            color: blackColor,
                          ),
                        ),
                      ),
              ),/*
              const SizedBox(
                height: 35,
              ),
              //  EditRow("Nom d'utilisateur","Ryad", {}),
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditUsername())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //padding: const EdgeInsets.all(8),
                      child: Text("Nom d'utilisateur",style: TextStyle(fontSize: 17),),
                    ),
                    Row(
                      children: [
                        Text(userData['username']),
                       
                        Container(child: Icon(CupertinoIcons.chevron_forward)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: blackColor,thickness: 1,),
              const SizedBox(
                height: 35,
              ),
              InkWell(
                 onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Biographie())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //padding: const EdgeInsets.all(8),
                      child: Text("Bio",style: TextStyle(fontSize: 17),),
                    ),
                    Row(
                      children: [
                        Text(userData['bio']),
                        
                        Container(child: Icon(CupertinoIcons.chevron_forward)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: blackColor,thickness: 1,),
              const SizedBox(
                height: 35,
              ),
              InkWell(
                 onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WhatsApp())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //padding: const EdgeInsets.all(8),
                      child: Text("WhatsApp",style: TextStyle(fontSize: 17),),
                    ),
                    Row(
                      children: [
                        Text(userData['contact']),
                     
                        Container(child: Icon(CupertinoIcons.chevron_forward)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: blackColor,thickness: 1,),*/
              const SizedBox(
                height: 35,
              ),
      
              ChampText(
                hintText: "",
                textInputType: TextInputType.text,
                textEditingController: _newusernameController,
                icon: const Icon(CupertinoIcons.person),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                  width: size.width * 0.8,
                  
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    //cursorHeight:2,
                    cursorColor: Colors.black,
                    controller: _newBioController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                    
                     // hintText: userData['bio']==""?"": userData['bio'],
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 234, 234)),
                      prefixIcon: const Icon(CupertinoIcons.pencil),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1, color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1, color: Colors.black)),
                      contentPadding:
                          const EdgeInsets.only(left: 20,right: 20,bottom: 50),
                    ),
                    keyboardType: TextInputType.multiline,
                    obscureText: false,
                  )),
              const SizedBox(
                height: 25,
              ),
              ChampText(
                hintText: userData['contact']==""?"":userData['contact'],
                textInputType: TextInputType.text,
                textEditingController: _newNumController,
                isPass: true,
                icon: const Icon(FontAwesomeIcons.whatsapp),
              ),
      
              const SizedBox(
                height: 25,
              ),
              CSCPicker(
                ///Enable disable state dropdown [OPTIONAL PARAMETER]
                showStates: true,
                showCities: true,
                //flagState: CountryFlag.DISABLE,
      
                dropdownDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
      
                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
      
                ///placeholders for dropdown search field
                countrySearchPlaceholder: "Country",
                stateSearchPlaceholder: "State",
                citySearchPlaceholder: "City",
      
                ///labels for dropdown
                countryDropdownLabel: "Pays",
                stateDropdownLabel: "Region",
                cityDropdownLabel: "Ville",
      
                ///Default Country
                //defaultCountry: DefaultCountry.Benin,
                ///Disable country dropdown (Note: use it with default country)
                //disableCountry: true,
      
                selectedItemStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                dropdownHeadingStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
      
                dropdownItemStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
      
                dropdownDialogRadius: 20.0,
      
                searchBarRadius: 20.0,
      
                onCountryChanged: (country) {
                  setState(() {
                    countryValue = country.toString();
                  });
                },
                onStateChanged: (state) {
                  setState(() {
                    stateValue = state.toString();
                  });
                },
                onCityChanged: (city) {
                  setState(() {
                    cityValue = city.toString();
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (cityValue == "null") {
                        address = countryValue;
                      } else {
                        address = "$countryValue | $cityValue";
                      }
                    });
                  },
                  child: const Text("Print Data")),
              Text(
                address,
                style:
                    const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              /* InkWell(
                onTap:  (){},
                child: Button(
                   
                    text: "Valider"),
                   
              ),*/
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

EditRow(String Label, String value, fonction) {
  return InkWell(
    onTap: fonction,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(
            Label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            Container(
                padding: const EdgeInsets.only(right: 25, top: 10),
                child: const Icon(CupertinoIcons.add)
                // padding: const EdgeInsets.symmetric(vertical: 20),
                ),
          ],
        )),
      ],
    ),
  );
}

class ModifierProfile extends StatefulWidget {
  const ModifierProfile({super.key});

  @override
  State<ModifierProfile> createState() => _ModifierProfileState();
}

class _ModifierProfileState extends State<ModifierProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    Uint8List? _image;

    String countryValue = "";
    String stateValue = "";
    String cityValue = "";
    String address = "";

    imagebottomSheet() {
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          builder: (context) {
            return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.3,
                maxChildSize: 0.3,
                minChildSize: 0.3,
                builder: ((context, scrollController) => Column(
                      children: <Widget>[
                        ListTile(
                            leading: const Icon(CupertinoIcons.photo_camera,
                                color: Colors.black),
                            title: const Text("Prendre a photo",
                                style: TextStyle(color: Colors.black)),
                            onTap: () async {
                              Navigator.pop(context);
                              Uint8List file =
                                  await pickImage(ImageSource.camera);
                              setState(() {
                                _image = file;
                              });
                            }),
                        ListTile(
                            leading: const Icon(CupertinoIcons.photo,
                                color: Colors.black),
                            title: const Text("Choisir depus galerie",
                                style: TextStyle(color: Colors.black)),
                            onTap: () async {
                              Navigator.of(context).pop();
                              Uint8List file =
                                  await pickImage(ImageSource.gallery);
                              setState(() {
                                _image = file;
                              });
                            }),
                        ListTile(
                          leading: const Icon(CupertinoIcons.clear,
                              color: Colors.black),
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

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Modifier le profil"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.check,
                color: Colors.black,
              )),
        ],
        // centerTitle:true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: imagebottomSheet,
              child: _image != null
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          //la photo de profile
                          'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                      backgroundColor: Colors.grey,
                    )
                  : const CircleAvatar(
                      radius: 50,
                      // backgroundColor: Colors.grey.withOpacity(0.1),
                      backgroundImage:
                          AssetImage("assets/defaultprofilepic.jpg"),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.camera,
                          color: blackColor,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 25,
            ),
            const TextField(
              decoration: InputDecoration(),
            ),
            EditRow("Nom d'utilisateur", "Ryad", {}),
            const SizedBox(
              height: 25,
            ),
            EditRow("Nom d'utilisateur", "Ryad", {}),
            const SizedBox(
              height: 25,
            ),
            EditRow("Nom d'utilisateur", "Ryad", {}),
            const SizedBox(
              height: 25,
            ),
            CSCPicker(
              ///Enable disable state dropdown [OPTIONAL PARAMETER]
              showStates: true,
              showCities: true,
              //flagState: CountryFlag.DISABLE,

              dropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),

              ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),

              ///placeholders for dropdown search field
              countrySearchPlaceholder: "Country",
              stateSearchPlaceholder: "State",
              citySearchPlaceholder: "City",

              ///labels for dropdown
              countryDropdownLabel: "Pays",
              stateDropdownLabel: "Region",
              cityDropdownLabel: "Ville",

              ///Default Country
              //defaultCountry: DefaultCountry.Benin,
              ///Disable country dropdown (Note: use it with default country)
              //disableCountry: true,

              selectedItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownHeadingStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),

              dropdownItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),

              dropdownDialogRadius: 20.0,

              searchBarRadius: 20.0,

              onCountryChanged: (country) {
                setState(() {
                  countryValue = country.toString();
                });
              },
              onStateChanged: (state) {
                setState(() {
                  stateValue = state.toString();
                });
              },
              onCityChanged: (city) {
                setState(() {
                  cityValue = city.toString();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    if (cityValue == "null") {
                      address = countryValue;
                    } else {
                      address = "$countryValue | $cityValue";
                    }
                  });
                },
                child: const Text("Print Data")),
            Text(
              address,
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            /* InkWell(
              onTap:  (){},
              child: Button(
                 
                  text: "Valider"),
                 
            ),*/
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  EditRow(String Label, String value, fonction) {
    return InkWell(
      onTap: fonction,
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              Label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              Container(
                  padding: const EdgeInsets.only(right: 25, top: 10),
                  child: const Icon(CupertinoIcons.add)
                  // padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
            ],
          )),
        ],
      ),
    );
  }
}
