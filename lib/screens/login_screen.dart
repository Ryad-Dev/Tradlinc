import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/resources/auth_methods.dart';
import 'package:tradlinc/responsive/mobile_screen_layout.dart';
import 'package:tradlinc/responsive/responsive_layout.dart';
import 'package:tradlinc/responsive/web_screen_layout.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:tradlinc/utils/utils.dart';
import 'package:tradlinc/widgets/text_field_input.dart';
import 'package:tradlinc/screens/signup_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height:150 ,),
            Container(
              width: 150,
             height:150,
             child: const Image(image: AssetImage("assets/logotransparantbleu.png")),
            ),
            const SizedBox(height: 50,),

              TextFieldInput(
                icon: const Icon(CupertinoIcons.mail,color: Colors.black,),
                hintText:" Email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                icon: const Icon(CupertinoIcons.lock,color: Colors.black,),
                hintText:"Mot de passe",
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginUser,
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
                            "Se Connecter",
                            style:
                                TextStyle(color: primaryColor,fontSize: 16, fontWeight: FontWeight.bold),
                          )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                         strokeWidth :2,
                        ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      "Vous n'avez pas de copmte?",
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Signup_email(),
                      ),
                    ),
                    child: Container(
                      child: const Text(
                        " S'inscrire",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
