import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:v_healthcare/custom/drawer.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  final String token;

  Account({this.token});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map<String, dynamic> userData = {};
  List recordsData;

  void getUser() async {
//    final idToken = widget.token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');
    final http.Response response =
        await http.get('$remoteUrl/api/user', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

//    print(response.body);
    setState(() {
      userData = json.decode(response.body);
    });
    print(userData);
    prefs.setString('id', userData['id'].toString());
  }

  Future getRecords() async {
//    final idToken = widget.token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token');
    final http.Response response =
        await http.get('$remoteUrl/api/patient/get-records', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

    setState(() {
      recordsData = json.decode(response.body);
    });
    print(response.body);
  }

  @override
  void initState() {
    getUser();
    getRecords();
    super.initState();
  }

  @override
  void didUpdateWidget(Account oldWidget) {
    getRecords();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
//                userData['name'] != null ? Text(userData['name']) : Text('')
                Text('My Records')),
        drawer: DrawerWidget(
          user: userData,
          token: widget.token,
        ),
        body: recordsData != null
            ? ListView.builder(
                itemCount: recordsData == null ? 0 : recordsData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      color: Colors.blue[100],
                      margin: EdgeInsets.all(20),
                      elevation: 4,
//                      height: 120,
//                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Report type:  ' +
                                recordsData[index]['report_type'],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Description:  ' +
                              recordsData[index]['description'].toString()),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Date: ' + recordsData[index]['created_at'])
                        ],
                      ));
                })
            : Center(
//                mainAxisAlignment: MainAxisAlignment.center,
                child: Text('You have not records yet')));
  }
}
