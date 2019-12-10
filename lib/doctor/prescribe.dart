import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:v_healthcare/components/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:v_healthcare/custom/constants.dart';
class Prescribe extends StatefulWidget {
  final int userId;

  Prescribe({this.userId});

  @override
  _PrescribeState createState() => _PrescribeState();
}

class _PrescribeState extends State<Prescribe> {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController caseHistoryEditingController = TextEditingController();
  TextEditingController medicationEditingController = TextEditingController();
  String userName;
  bool showSpinner = false;
  String caseHistory;
  String medication;

  void getUser() async {
//    final idToken = widget.token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');
    final userId = widget.userId;
    final http.Response response =
    await http.get('$remoteUrl/api/getPatient/$userId', headers: {
//      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

    print(response.body);
    setState(() {
      userName = json.decode(response.body)['data']['name'];
    });

  }
  void submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');
//    setState(() {
//      showSpinner = true;
//    });

    if (!formKey.currentState.validate()) {
//      setState(() {
//        showSpinner = false;
//      });
      return;
    }
    formKey.currentState.save();
    setState(() {
      showSpinner = true;
    });
    final Map<String, dynamic> data = {
      'user_id': widget.userId,
      'case_history': caseHistory,
      'medication': medication,
    };

    final http.Response response =
        await http.post('http://10.0.2.2:8000/api/doctor/prescription/make',
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $idToken',
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json'
            },
            body: json.encode(data));
    if (response.statusCode == 200) {
      caseHistoryEditingController.clear();
      medicationEditingController.clear();
      setState(() {
        showSpinner = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(
                'Prescription has been sent to the patient',
                style: TextStyle(color: Colors.green),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ],
            );
          });

    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  void didUpdateWidget(Prescribe oldWidget) {
    getUser();
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Prescription'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          padding: EdgeInsets.all(20),
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Patient Name: $userName',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Divider(),
            SizedBox(
              height: 30,
            ),
            Form(

              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(

                    decoration: InputDecoration(

                      hintText: 'Case History',
//                    contentPadding: EdgeInsets.all(20),
//                    border: OutlineInputBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                    ),
                    ),
                    maxLines: 4,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    controller: caseHistoryEditingController,
                    onSaved: (String value) {
                      setState(() {
                        caseHistory = value;
                      });
                    },
                  ),
                  SizedBox(height: 80),
                  TextFormField(
                    controller: medicationEditingController,
                    decoration: InputDecoration(hintText: 'Medication'),
                    maxLines: 4,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'This field is required';
                      }
                    },
                    onSaved: (String value) {
                      setState(() {
                        medication = value;
                      });
                    },
                  ),
                  RoundedButton(
                    title: 'Prescribe',
                    colour: Colors.lightBlueAccent,
                    onPressed: submitForm,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
