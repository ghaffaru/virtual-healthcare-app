import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:v_healthcare/patient/view_prescription.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prescriptions extends StatefulWidget {
  final String token;

  Prescriptions({this.token});

  @override
  _PrescriptionsState createState() => _PrescriptionsState();
}

class _PrescriptionsState extends State<Prescriptions> {
  List data;

  Future getMyPrescriptions() async {
//    final idToken = widget.token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('token');
    final http.Response response =
        await http.get('$remoteUrl/api/patient/prescriptions', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    });
    setState(() {
      data = json.decode(response.body)['data'];
    });
    print(response.body);
  }

  @override
  void initState() {
    getMyPrescriptions();
    super.initState();
  }

  @override
  void didUpdateWidget(Prescriptions oldWidget) {
    getMyPrescriptions();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Prescriptions'),
        ),
        body: data != null
            ? ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
//                    color: Colors.blue[100],
                    color: Colors.white,
                    margin: EdgeInsets.all(20),
                    elevation: 1,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Doctor\'s name:  ' + data[index]['doctor_name'],
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Prescription Date: ' +
                            ((data[index]['created_at']))),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          child: Text(
                            'view',
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PrescriptionView(
                                          idToken: widget.token,
                                          prescriptionId: data[index]['id'],
                                        )));
                          },
                        )
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text('You have no prescriptions'),
              ));
  }
}
