import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/utils/colors.dart';

class Parametres extends StatelessWidget {
  const Parametres({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Parametres"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(CupertinoIcons.person_crop_circle,
                color: Colors.black,size: 30,),
            title: const Text("Informations du compte",style: TextStyle(color: Colors.black)),
            onTap: (){},
          ),
      
          ListTile(
            leading: const Icon(CupertinoIcons.bold,
                color: Colors.black,size: 30),
            title: const Text("Langue",style: TextStyle(color: Colors.black)),
            onTap: (){}
          ),
          ListTile(
              leading:
                  const Icon(CupertinoIcons.flag, color: Colors.black,size: 30),
              title: const Text("Signaler un probleme",style: TextStyle(color: Colors.black)),
              onTap: () {}),
               ListTile(
              leading:
                  const Icon(CupertinoIcons.link, color: Colors.black,size: 30),
              title: const Text("Aide",style: TextStyle(color: Colors.black)),
              onTap: () {}),
               ListTile(
              leading:
                  const Icon(CupertinoIcons.info, color: Colors.black,size: 30),
              title: const Text("A propos",style: TextStyle(color: Colors.black)),
              onTap: () {}),
             
        ],
      ),
    );
  }
}