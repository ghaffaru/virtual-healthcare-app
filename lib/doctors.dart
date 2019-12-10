import 'package:flutter/material.dart';
import 'package:v_healthcare/patient/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'appointments.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io';
import 'custom/drawer.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:v_healthcare/doctor_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Doctors extends StatefulWidget {
  String token;

  Doctors({this.token});

  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  bool showSpinner = false;
  List data;
  String appointmentDate;

  Future getDoctors() async {
    final http.Response response = await http.get('$remoteUrl/api/doctors',
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        });
    setState(() {
      data = json.decode(response.body)['data'];
    });

    print(response.body);
  }

  Future bookAppointment(int id) async {
    final String idToken = widget.token;
    Map<String, dynamic> sendData = {
      'doctor_id': id,
      'appointment_date': appointmentDate
    };
    final http.Response response = await http.post(
        '$remoteUrl/api/patient'
        '/book-appointment',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: json.encode(sendData));

    if (response.statusCode == 200) {
      print(response.statusCode);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Status'),
              content: Text(
                'Appointment pending approval',
                style: TextStyle(color: Colors.green),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Back'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      showSpinner = true;
    });
    getDoctors();
    setState(() {
      showSpinner = false;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(Doctors oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {
      showSpinner = true;
    });
    getDoctors();
    setState(() {
      showSpinner = false;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
//    getDoctors();
    return Scaffold(
//      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Center(child: Text('Doctor List')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(data));
            },
          )
        ],
      ),
      drawer: DrawerWidget(
        token: widget.token,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: data != null
            ? ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DoctorView(data[index])));
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
//              color: Colors.blue[100],
                      elevation: 1,
//              height: 80,
//              padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'images/doctor.jpg',
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Dr. ' + data[index]['name'],
                                    style: TextStyle(fontSize: 20),
                                  ),
//                      Divider(height: 5),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(data[index]['title'] +
                                      ' | ' +
                                      data[index]['specialization']),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              )
                            ],
                          )

//                      FlatButton(
//                        child: Text(
//                          'Book Appointment',
//                          style: TextStyle(color: Colors.lightBlueAccent),
//                        ),
//                        onPressed: () {
////
//                          DatePicker.showDateTimePicker(context,
//                              showTitleActions: true,
//                              minTime: DateTime.now(),
//                              maxTime: DateTime(2019, 6, 7), onChanged: (date) {
//                            print('change $date');
//                          }, onConfirm: (date) {
////                        print('confirm $date');
//                            setState(() {
//                              appointmentDate = date.toString();
//                            });
//                            bookAppointment(data[index]['id']);
//                          },
//                              currentTime: DateTime.now(),
//                              locale: LocaleType.en);
//                        },
//                      ),
//                    SizedBox(height: 10,)
//                    IconButton(icon: Icon(Icons.forward))
                        ],
                      ),
                    ),
                  );
                })
            : Center(
                child: Text('No doctors available'),
              ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List data;

  DataSearch(this.data);

//  Future getDoctors() async {
//    final http.Response response = await http.get('$remoteUrl/api/doctors',
//        headers: {
//          'Content-Type': 'application/json',
//          'accept': 'application/json'
//        });
//
//    return json.decode(response.body)['data'];
//
////    print(response.body);
//  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? this.data
        : this.data.where((p) => p['name'].startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
//          showResults(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DoctorView(suggestionList[index])));
        },
        leading: Icon(Icons.local_hospital),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index]['name'].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: suggestionList[index]['name'].substring(query.length),
                  style: TextStyle(color: Colors.grey)),
                  TextSpan(text: ' | '),
                  TextSpan(text: suggestionList[index]['title'])
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
