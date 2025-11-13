import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_score_app/notification_navigation.dart';

class FcmService{
  static Future<void> initialize()async{
    //app e notification patanor jonno first e permisson newa lage aivabe
    await FirebaseMessaging.instance.requestPermission(
      //egula defult e set thake...amra caile nijer moto o set korte pari
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
//foreground e msg ashar jonno
    FirebaseMessaging.onMessage.listen(_handleNotificatorBar);

    //background e msg ashar jonno

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificatorBar);

    //terminated mane ekdom app close obostai

    FirebaseMessaging.onBackgroundMessage(_handleTerminatedNotification);


  }
//ki ki print korbe ta
static void _handleNotificatorBar(RemoteMessage massege){
    print(massege.data);
    print(massege.notification?.title);
    print(massege.notification?.body);
    // ek screen theke onno screen e jawa notification er maddome
    bool shouldNavigate = massege.data['should_navigate'] ?? false;
    if(shouldNavigate){
        NotificationNavbar.handleNotification(massege.data['route-name']);
      // Navigator.pushNamed(FootballLiveScoreApp.navigator.currentContext!, message.data['route_name']);

    }
}
//single manush k personal vabe pataite caile token dhore pathano lage
  static Future<String?> getToken() async{
   return FirebaseMessaging.instance.getToken();
  }
//jkn ager token ta expire hoi jabe tkn nicher aita nibe
  static void getRefreshToken(){
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken){
      print(newToken);
    });


  }
//terminated msg e ki ki dekhabe ta
 static Future<void> _handleTerminatedNotification(RemoteMessage massege)async{}

}