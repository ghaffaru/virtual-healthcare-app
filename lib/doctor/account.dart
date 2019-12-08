import 'package:flutter/material.dart';
import 'package:v_healthcare/doctor/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Account extends StatefulWidget {

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic> userData = {};
  void getUser() async {
//    final idToken = widget.token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');
    final http.Response response =
    await http.get('$remoteUrl/api/doctor', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

//    print(response.body);
    setState(() {
      userData = json.decode(response.body);
    });
    print(userData);
    prefs.setString('doctor_id', userData['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome'),),
      drawer: DrawerWidget(),
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }
}
