import 'package:flutter/material.dart';
import 'package:v_healthcare/auth/login.dart';
import 'package:v_healthcare/appointments.dart';
import 'package:v_healthcare/doctors.dart';
import 'package:v_healthcare/ambulance.dart';
import 'package:v_healthcare/prescriptions.dart';

class DrawerWidget extends StatelessWidget {
  final String token;

  DrawerWidget({this.token});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Choose'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: Text('Consult a doctor'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Doctors(
                            token: token,
                          )));
            },
          ),
          ListTile(
            title: Text('My Appointments'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Appointments(token)));
            },
          ),
//          ListTile(
//            title: Text('Request an ambulance'),
//            onTap: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => Login()));
//            },
//          ),
          ListTile(
            title: Text('My Prescriptions'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Prescriptions(token: token)));
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ),
              );
//
            },
          ),
        ],
      ),
    );
  }
}
