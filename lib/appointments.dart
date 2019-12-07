import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:v_healthcare/Chat.dart';
import 'package:v_healthcare/custom/constants.dart';
class Appointments extends StatefulWidget {
  final String token;

  String condition;

  Appointments(this.token);

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  List data;

  Future getAppointments() async {
    final idToken = widget.token;

    final http.Response response = await http
        .get('$remoteUrl/api/patient/appointments', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    });

    setState(() {
      data = json.decode(response.body)['data'];
    });
    print(response.body);
  }

  Future cancelAppointment(int id) async {
    final idToken = widget.token;

    final http.Response response = await http.delete(
        '$remoteUrl/api/patient/cancel-appointment/$id',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json'
        });

    if (response.statusCode == 200) {
      print('cancelled');
      getAppointments();
      Navigator.pop(context);
    }
  }

  Future confirmCancel(int id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text(
              'Are you sure you want to cancel the appointment',
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () => cancelAppointment(id),
              ),
              FlatButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  @override
  void didUpdateWidget(Appointments oldWidget) {
    getAppointments();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Appointments'),
        ),
        body: data != null
            ? ListView.builder(
                itemCount: data == null ? 0 : data.length,
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
                            'Doctor\'s name:  ' + data[index]['doctor'],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Appointment Date:  ' +
                              DateTime.parse(data[index]['appointment_date'])
                                  .toString()),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Status: '),
                              SizedBox(
                                width: 10,
                              ),
                              Text(data[index]['approved'] == "0"
                                  ? 'Not approved'
                                  : 'Approved'),
//                              SizedBox(width: 5,),
                              MaterialButton(
                                  child: Text(data[index]['approved'] == "0"
                                      ? "Cancel"
                                      : ""),
                                  onPressed: () => confirmCancel(
                                        data[index]['id'],
                                      )),
                              MaterialButton(
                                child: Text(data[index]['approved'] == "0"
                                    ? ""
                                    : "Chat"),
                                onPressed: () {

                                }
                              )
                            ],
                          ),
                        ],
                      ));
                })
            : Center(
//                mainAxisAlignment: MainAxisAlignment.center,
                child: Text('You have no appointments')));
  }
}
