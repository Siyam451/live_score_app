import 'package:flutter/cupertino.dart';
import 'package:live_score_app/app.dart';

class NotificationNavbar{
  static void handleNotification(String path){
    if(path == '/home'){
      Navigator.pushNamed(FootballLiveScoreApp.navigator.currentContext!, '/');// kon notification ashle kon page e jabe ta set kora
    }
  }
}