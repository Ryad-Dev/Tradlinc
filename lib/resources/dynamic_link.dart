
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//import 'package:share_plus/share_plus.dart';


class DynamicLinkProvider {
  //Create a link
  Future <String> createLink(String refcode) async{
    final String url = "https://tradlink.com/@$refcode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: const AndroidParameters(
          packageName: "com.example.app.android",
          minimumVersion: 0,
        ),
      /*  iosParameters: IOSParameters(bundleId: "bundleId",minimumVersion: "0",),*/
        link: Uri.parse(url),
        uriPrefix: "https://tradlinc.page.link");
        final FirebaseDynamicLinks link =  FirebaseDynamicLinks.instance;

        final refLink = await link.buildShortLink(parameters);
        return refLink.shortUrl.toString();
  }

  //Initialiser lien dynamique
  void initDynaicLink()async{
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if(instanceLink != null){
      final Uri refLink = instanceLink.link ;
    //  Share.share("tradlinc/${refLink.queryParameters["refcode"]}");
    }
  }
}

/*
class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings){
    final agrs = RouteSettings().arguments;
    switch(routeSettings.name){
      case "/Home":
      return CupertinoPageRoute(builder: (_){
        return FeedScreen();
      });
      case"/Profile":
      if(agrs is Map){
        return CupertinoPageRoute(builder: (_){
        return ProfileScreen(uid: agrs['uid'],);
      });
      }
      return _errorRoute();


      default:
      return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
  return Scaffold(appBar: AppBar(title: Text("Page Not Found"),),);
    });
  }
}
*/