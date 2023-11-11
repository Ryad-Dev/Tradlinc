import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tradlinc/providers/user_provider.dart';
import 'package:tradlinc/resources/dynamic_link.dart';
import 'package:tradlinc/responsive/mobile_screen_layout.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tradlinc/onboarding.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
    await Firebase.initializeApp();
  FlutterNativeSplash.removeAfter(initialization);
   DynamicLinkProvider().initDynaicLink();
  runApp( const MyApp());
}
Future initialization(BuildContext? Context)async{
  await Future.delayed(const Duration(seconds:2));
}



class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);
/*  String? _linkMessage;
  bool _isCreatingLink = false ;
 

 FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
 Future<void> initDynamicLinks(){
  dynamicLinks.onLink.listen((dynamicLinkData) {
    final Uri url
   });
 }*/


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
       
        theme: ThemeData(
          scaffoldBackgroundColor: mobileBackgroundColor,
           primarySwatch: Colors.blue,
        //  primarySwatch:Colors.black
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const  MobileScreenLayout();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth:3,
                ),
              );
            }

            return const Start();
          },
        ),
        //onGenerateRoute: RouteServices.generateRoute,
      ),
    );
  }
}
