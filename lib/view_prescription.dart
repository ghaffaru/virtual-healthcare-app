import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class PrescriptionView extends StatefulWidget {
  final int prescriptionId;
  final String idToken;

  PrescriptionView({this.idToken, this.prescriptionId});

  @override
  _PrescriptionViewState createState() => _PrescriptionViewState();
}

class _PrescriptionViewState extends State<PrescriptionView> {
  Map<String, dynamic> data;

  Future getPrescription() async {
    final idToken = widget.idToken;
    final prescriptionId = widget.prescriptionId;

    final http.Response response = await http.get(
        'http://10.0.2.2:8000/api/patient/prescription/$prescriptionId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json'
        });

    setState(() {
      data = jsonDecode(response.body)['data'];
    });

    print(data);
  }

  Future submitToPharmacist() async {
    final idToken = widget.idToken;
    final prescriptionId = widget.prescriptionId;

    final http.Response response = await http.post(
        'http://10.0.2.2:8000/api/patient/prescription/$prescriptionId/submit',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json'
        },
        body: jsonEncode({'submitted': "1"}));

    if (response.statusCode == 200) {

    }
  }

  @override
  void initState() {
    getPrescription();
    super.initState();
  }

  @override
  void didUpdateWidget(PrescriptionView oldWidget) {
    getPrescription();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription detail'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              'Name of doctor: ',
              style: TextStyle(
                  color: Colors.green[400],
                  fontSize: 22,
                  fontStyle: FontStyle.normal),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              data['doctor_name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 30),
              textAlign: TextAlign.center,
            ),
            Divider(
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Case history',
              style: TextStyle(color: Colors.green[400], fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              data['case_history'],
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(
              color: Colors.green[400],
            ),
            Text(
              'Medication',
              style: TextStyle(color: Colors.green[400], fontSize: 22),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              data['medication'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            Divider(
              color: Colors.green[400],
            ),
            FlatButton(
              child: Text(
                'submit to pharmacist',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
