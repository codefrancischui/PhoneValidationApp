import 'package:flutter/material.dart';

import 'package:phone_validation_app/src/screens/phone_verify_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Validation App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: PhoneVerify(),
    );
  }
}

