import 'package:flutter/material.dart';

import 'patient/login.dart';
import 'package:v_healthcare/patient/register.dart';
import 'home.dart';
//import 'package:map_view/map_view.dart';
import 'package:v_healthcare/doctor/login.dart';

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
        '/patient-login' : (context) => PatientLogin(),
        '/patient-register': (context) => PatientRegister(),
        '/doctor-login' : (context) => DoctorLogin(),
      },
//        onGenerateRoute: router.generateRoute,
//        initialRoute: router.HomeViewRoute,
//        home: Home(),

    );
  }
}
