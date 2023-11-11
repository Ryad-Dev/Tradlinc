
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/resources/auth_methods.dart';
import 'package:tradlinc/responsive/mobile_screen_layout.dart';
import 'package:tradlinc/screens/login_screen.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:tradlinc/widgets/text_field_input.dart';


class Signup_email extends StatefulWidget {
  const Signup_email({super.key});

  @override
  State<Signup_email> createState() => _Signup_emailState();
}

class _Signup_emailState extends State<Signup_email> {
    final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
 
  bool _isLoading = false;
//  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
   
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
         
        username: _usernameController.text,
        //bio: _bioController.text,
        //file: _image!
        );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  const MobileScreenLayout(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }
/*
  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }*/
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Scaffold(
   backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height:150 ,),
            const SizedBox(
              width: 150,
             height:150,
             child: Image(image: AssetImage("assets/logotransparantbleu.png")),
            ),
            const SizedBox(height: 50,),

            TextFieldInput(
                  icon: const Icon(CupertinoIcons.person,color: Colors.black,),
                  hintText: "Nom d'utilisateur",
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  icon: const Icon(CupertinoIcons.mail,color: Colors.black,),
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  icon: const Icon(CupertinoIcons.lock,color: Colors.black,),
                  hintText: ' Mot de passe',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: false,
                ),
                const SizedBox(
                  height: 24,
                ),
           
              /*  TextFieldInput(
                  icon: Icon(CupertinoIcons.search,color: Colors.black,),
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),
                const SizedBox(
                  height: 24,
                ),*/
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                        height: 50,
                        width: size.width * 0.8,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          color: blueColor,
                        ),
                        child:  Center(
                          child: !_isLoading
                      ? const  Text(
                            "S'inscrire",
                            style:
                                TextStyle(color: primaryColor,fontSize: 16, fontWeight: FontWeight.bold),
                          )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                          
                        ),
                        ),
                      ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Compte existant ?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Se Connecter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ]),
      ),
    );
  }
}