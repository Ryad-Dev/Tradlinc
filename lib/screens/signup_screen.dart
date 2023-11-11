/*import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradlinc/resources/auth_methods.dart';
import 'package:tradlinc/responsive/mobile_screen_layout.dart';
import 'package:tradlinc/responsive/responsive_layout.dart';
import 'package:tradlinc/responsive/web_screen_layout.dart';
import 'package:tradlinc/screens/login_screen.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/utils/global_variable.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:tradlinc/widgets/text_field_input.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:tradlinc/screens/signup_email.dart';
import 'package:tradlinc/screens/signup_phone.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Inscription"),
          centerTitle: true,
          //elevation: 0,
        ),
       // resizeToAvoidBottomInset: false,
        body: Column(
         // crossAxisAlignment: CrossAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
           /* Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),*/
            /*const SizedBox(
              height: 64,
            ),*/
         /*   Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        backgroundImage: M
                        radius: 64,emoryImage(_image!),
                        backgroundColor: Colors.red,
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://i.stack.imgur.com/l60Hf.png'),
                        backgroundColor: Colors.red,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),*/
          /*  const SizedBox(
              height: 24,
            ),*/
            const TabBar(
                      tabs: [
                        Tab(
                           icon: Icon(Icons.menu_rounded, color: Colors.black),
                        ),
                        Tab(
                          icon: Icon(Icons.menu_book, color: Colors.black),
                        ),
                      ],
                    ),
                    Expanded(
                  child: TabBarView(children: [
                      Signup_email(),
                      Signup_phone()
                     
                    ])),
            
          ],
        ),
      ),
    );
  }
}
*/