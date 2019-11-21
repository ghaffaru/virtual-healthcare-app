import 'package:flutter/material.dart';
import 'package:v_healthcare/auth/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'appointments.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io';
import 'custom/drawer.dart';

class Doctors extends StatefulWidget {
  String token;

  Doctors({this.token});

  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  List data;
  String appointmentDate;

  Future getDoctors() async {
    final http.Response response = await http
        .get('http://10.0.2.2:8000/api/doctors', headers: {
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
    final http.Response response =
        await http.post('http://10.0.2.2:8000/api/patient/book-appointment',
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
    getDoctors();
    super.initState();
  }

  @override
  void didUpdateWidget(Doctors oldWidget) {
    // TODO: implement didUpdateWidget
    getDoctors();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
//    getDoctors();
    return Scaffold(
//      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text('List of Doctors')),
      drawer: DrawerWidget(token: widget.token,),
      body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(10),
              color: Colors.blue[100],
              elevation: 4,
//              height: 80,
//              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Text(
                    data[index]['name'],
                    style: TextStyle(fontSize: 25),
                  ),
                  Divider(),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    child: Text(
                      'Book Appointment',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
//
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
//                        print('confirm $date');
                        setState(() {
                          appointmentDate = date.toString();
                        });
                        bookAppointment(data[index]['id']);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
