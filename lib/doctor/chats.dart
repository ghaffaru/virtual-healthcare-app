import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:v_healthcare/custom/constants.dart';
import 'dart:io';
import 'dart:convert';
import 'drawer.dart';
import 'chat.dart';
final _firestore = Firestore.instance;

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List patients;
  List userIds = [];
  Map<String, dynamic> user = {};

  Future getPatients() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');

    final http.Response response = await http.get(
      '$remoteUrl/api/doctor/patients',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $idToken',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        patients = jsonDecode(response.body);
      });
    }

    print(patients);
  }

//  void messagesStream() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    String doctorId = prefs.getString('doctor_id');
//    print(doctorId);
//    await for (var snapshot in _firestore.collection('messages').snapshots()) {
//      for (var message in snapshot.documents) {
//        if (message.data['doctor_id'] == doctorId) print(message.data);
//        userIds.add(int.parse(message.data['user_id']));
//      }
//
//      userIds = userIds.toSet().toList();
//      print(userIds);
//
//      for (int i = 0; i < userIds.length; i++) {
//        int id = userIds[i];
//
//        final http.Response response =
//            await http.get('$remoteUrl/api/getPatient/$id', headers: {
//          HttpHeaders.contentTypeHeader: 'application/json',
//          HttpHeaders.acceptHeader: 'application/json'
//        });
////        patients.addAll(json.decode(response.body));
//        setState(() {
//          user = json.decode(response.body);
//        });
//        patients.add(user);
//
////        print(users);
////        print(json.decode(response.body));
////        print(patients);
////        print(users);
//
//      }
////      print(patients);
////      patients = users;
//      print(user);
//    }
//  }

  @override
  void initState() {
//    messagesStream();
    getPatients();
    super.initState();
  }

  @override
  void didUpdateWidget(Chats oldWidget) {
    getPatients();
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Chats'),
      ),
      drawer: DrawerWidget(),
      body: patients != null
          ? ListView.builder(
//              reverse: true,

              itemCount: patients == null ? 0 : patients.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Chat(patients[index][0]['id'])));
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
//              color: Colors.blue[100],
                    elevation: 0.3,
//              height: 80,
//              padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
//                            CircleAvatar(
//                              child: Image.asset(
//                                'images/patient.jpg',
//                                height: 100,
//                                width: 100,
//                                
//                              ),
//                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '' + patients[index][0]['name'],
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                ),
//                      Divider(height: 5),
                                SizedBox(
                                  height: 10,
                                ),
//                                Text(patients[index]['region'] +
//                                    ' | ' +
//                                    patients[index]['residence']),
                                Text(patients[index][1]['message'], style: TextStyle(fontWeight: FontWeight.w100),),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text('No Patients available'),
            ),
    );
  }
}
