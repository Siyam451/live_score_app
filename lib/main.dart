import 'package:flutter/material.dart';

import 'geo_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyMap());
}

class MyMap extends StatelessWidget {
  const MyMap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
