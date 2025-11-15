import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/home_screen.dart';
import 'package:live_score_app/sign_in.dart';

class StudentDatabaseApp extends StatefulWidget {
  const StudentDatabaseApp({super.key});

  @override
  State<StudentDatabaseApp> createState() => _StudentDatabaseAppState();
}

class _StudentDatabaseAppState extends State<StudentDatabaseApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,asyncsnapshots){
        if(asyncsnapshots.hasData){
          return HomeScreen();
        }else{
          return SignIn();
        }
          })
    );
  }
}
