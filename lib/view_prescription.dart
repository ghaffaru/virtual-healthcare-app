import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:v_healthcare/custom/constants.dart';
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
        '$remoteUrl/api/patient/prescription/$prescriptionId',
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

  void confirmSubmission() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text(
              'Are you sure you want to submit this prescription',
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: submitToPharmacist,
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

  Future submitToPharmacist() async {
    final idToken = widget.idToken;
    final prescriptionId = widget.prescriptionId;

    final http.Response response = await http.put(
        '$remoteUrl/api/patient/prescription/$prescriptionId/submit',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $idToken',
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json'
        },
        body: json.encode({'submitted': '1'}));
    print(json.encode({'submitted': '1'}));
    print(response.statusCode);
    if (response.statusCode == 200) {
      getPrescription();
      Navigator.pop(context);
    }
  }

  Future payForDrug() async {
    final idToken = widget.idToken;
    final prescriptionId = widget.prescriptionId;

    final http.Response response = await http.get('$remoteUrl/api/patient/pay/$prescriptionId',
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    });


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text(
              'Please accept the transaction on your phone',
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => {
                  Navigator.pop(context)
                },
              ),

            ],
          );
        });
    print(response.statusCode);
    print(response.body);
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
            SizedBox(
              height: 10,
            ),
            data['submitted'] == "0"
                ? FlatButton(
                    child: Text(
                      'submit to pharmacist',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: confirmSubmission,
                  )
                : Text(
                    'status : submitted ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
            SizedBox(
              height: 10,
            ),
            data['submitted'] == "1" && data['drug_issued'] == "1"
                ? RaisedButton(
//                   disabledColor: Color(10),
                   elevation: 4,
                    color: Colors.lightBlueAccent,
                    child: Text(
                      'pay for drug',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black),

                    ),
                    onPressed: payForDrug,
                  )
                : data['submitted'] == "1" && data['drug_issued'] == "0"
                    ? Text(
                        "drug issued : pending",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )
                    : Text("")
          ],
        ),
      ),
    );
  }
}
