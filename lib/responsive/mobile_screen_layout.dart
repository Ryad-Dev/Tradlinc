
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradlinc/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_provider.dart';
import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';


class MobileScreenLayout extends StatefulWidget {
  final snap ; 
  const MobileScreenLayout({Key? key, this.snap}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
 // int currentIndex=0;
  int index = 0;

  //FirebaseAuth.instance.currentUser!.uid,
 



  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

 /*  List<IconData>ListOfIcons =[
    CupertinoIcons.app_fill,
   CupertinoIcons.plus_app_fill,
   CupertinoIcons.bubble_middle_bottom_fill,
    CupertinoIcons.person_crop_circle_fill,
  ];*/
    List<Widget> widgetOptions = [
    const FeedScreen(),
   // const SearchScreen(),
    const AddPostScreen(),
   // const Notifications(),
     ProfileScreen(uid:FirebaseAuth.instance.currentUser!.uid),
  ];
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: widgetOptions.elementAt(index),
      ),
    bottomNavigationBar: NavigationBarTheme(
      data: NavigationBarThemeData(indicatorColor: Colors.blueAccent.withOpacity(.2)),
      child: NavigationBar(
        selectedIndex: index ,
        animationDuration: const Duration(seconds: 1),
        onDestinationSelected: (index) =>setState(() {
          this.index=index;
        }),
        height: 50,
        backgroundColor: primaryColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
       NavigationDestination(selectedIcon:Icon(CupertinoIcons.app_fill,size: 25,color:Colors.blueAccent) ,icon: Icon(CupertinoIcons.app,size:  25,color:Colors.grey) , label: 'Home',),
       NavigationDestination(selectedIcon: Icon(CupertinoIcons.plus_app_fill,size:  25,color:Colors.blueAccent),icon: Icon(CupertinoIcons.plus_app,size: 25,color:Colors.grey) , label: 'Add',),
        NavigationDestination(selectedIcon:Icon(CupertinoIcons.person_crop_circle_fill,size: 25,color:Colors.blueAccent),icon: Icon(CupertinoIcons.person_crop_circle,size: 25,color:Colors.grey) , label: 'Profile',)
          
        ],
      ),
    ),
                   
    /* bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,

        
          items: const <BottomNavigationBarItem>[
          
            BottomNavigationBarItem(activeIcon: Icon(CupertinoIcons.app_fill,size: 30,),icon: Icon(CupertinoIcons.app,size: 30,) , label: 'Search',),
           // BottomNavigationBarItem(activeIcon: Icon(CupertinoIcons.search,size: 27,),icon: Icon(CupertinoIcons.search,size: 27,), label: 'Search',),
             BottomNavigationBarItem(activeIcon: Icon(CupertinoIcons.plus_app_fill,size: 30,),icon:Icon(CupertinoIcons.plus_app,size: 30,),label: 'Add',),
             // BottomNavigationBarItem(activeIcon: Icon(CupertinoIcons.bubble_middle_bottom_fill,size:27,),icon:Icon(CupertinoIcons.bubble_middle_bottom,size:27 ,),label:'Notifications',),
            BottomNavigationBarItem(activeIcon: Icon(CupertinoIcons.person_crop_circle_fill,size:30,),icon:Icon(CupertinoIcons.person_crop_circle,size:30  ,),label: 'Profile',)
          ]),*/
    );
  }


  /*List<IconData>ListOfIcons =[
    CupertinoIcons.app_fill,
   CupertinoIcons.plus_app_fill,
   CupertinoIcons.bubble_middle_bottom_fill,
    CupertinoIcons.person_crop_circle_fill,
  ];*/
  
  
 
}
