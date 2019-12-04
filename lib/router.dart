import 'package:flutter/material.dart';
import 'home.dart';
import 'package:v_healthcare/patient/login.dart';
import 'package:v_healthcare/patient/register.dart';
const HomeViewRoute = '/';
const PatientLoginViewRoute = '/patient-login';
const PatientRegisterViewRoute = '/patient-register';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => Home());

    case PatientLoginViewRoute:
      var loginArgument = settings.arguments;
      return MaterialPageRoute(builder: (context) => PatientLogin(message: loginArgument,));

    case PatientRegisterViewRoute:
      return MaterialPageRoute(builder: (context) => PatientRegister());
  }
}