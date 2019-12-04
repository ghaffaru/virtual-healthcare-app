import 'package:flutter/material.dart';

import 'patient/login.dart';
import 'home.dart';
//import 'package:map_view/map_view.dart';

void main() async {

//  MapView.setApiKey('AIzaSyAhcJZADKIAEThe8qWVQn6S2f9nBvfF-qo');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//      home: Home(),
      theme: ThemeData(fontFamily: 'Raleway', primaryColor: Colors.lightBlueAccent),
      routes: {
        '/' : (context)  => Home(),
        '/patient-login' : (context) => PatientLogin()
      },
    );
  }
}
