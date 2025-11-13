import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:live_score_app/app.dart';
import 'package:live_score_app/fcm_services.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  await FcmService.initialize(); // notification er jinno main e aita set kora lagbe
  //flutter error(kono error ashle ta handle korte)
  FlutterError.onError = (errorDetails){
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  //all the uncaught asynchoronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics.instance.setUserId(id: '123');//custom vabe set
  FirebaseCrashlytics.instance.setCustomKey('userd-id', '12345');//custom vabe user id set korte pari
  print(await FcmService.getToken());
  runApp(const FootballLiveScoreApp());
}


