import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:v_healthcare/custom/drawer.dart';

class Account extends StatefulWidget {
  final String token;

  Account({this.token});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic> userData = {};

  void getUser() async {
    final idToken = widget.token;

    final http.Response response =
        await http.get('http//10.0.2.2:8000/api/user', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

//    print(response.body);
    setState(() {
      userData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                userData['name'] != null ? Text(userData['name']) : Text('')),
        drawer: DrawerWidget(
          token: widget.token,
        ));
  }
}
