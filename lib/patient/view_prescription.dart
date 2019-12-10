import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:v_healthcare/custom/constants.dart';
import 'package:flutter_pdf_renderer/flutter_pdf_renderer.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PrescriptionView extends StatefulWidget {
  final int prescriptionId;
  final String idToken;

  PrescriptionView({this.idToken, this.prescriptionId});

  @override
  _PrescriptionViewState createState() => _PrescriptionViewState();
}

class _PrescriptionViewState extends State<PrescriptionView> {

  Future<String> downloadedFilePath;

  Map<String, dynamic> data;

  Future getPrescription() async {
    final idToken = widget.idToken;
    final prescriptionId = widget.prescriptionId;

    final http.Response response = await http
        .get('$remoteUrl/api/patient/prescription/$prescriptionId', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'
    });

    setState(() {
      data = jsonDecode(response.body)['data'];
    });

//    setState(() {
//      downloadedFilePath = data['file'];
//    });
    print(data['file']);
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

  Future<String> downloadPdfFile(String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$filename');
    bool exist = false;
    try {
      await file.length().then((len) {
        exist = true;
      });
    } catch (e) {
      print(e);
    }
    if (!exist) {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future submitToPharmacist() async {
//    final idToken = widget.idToken;
    final prescriptionId = widget.prescriptionId;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');
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

    final http.Response response =
        await http.get('$remoteUrl/api/patient/pay/$prescriptionId', headers: {
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
                onPressed: () => {Navigator.pop(context)},
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

  void download() {
    setState(() {
      downloadedFilePath = downloadPdfFile(data['file']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription detail'),
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: data != null ? ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Card(
//                    color: Colors.blue[100],
              color: Colors.white,
              margin: EdgeInsets.all(5),
              elevation: 0.7,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Doctor\'s name:  ',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Dr. ' + ((data['doctor_name']))),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
//            Text(
//              'Name of doctor: ',
//              style: TextStyle(
//                  color: Colors.green[400],
//                  fontSize: 22,
//                  fontStyle: FontStyle.normal),
//              textAlign: TextAlign.center,
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            Text(
//              data['doctor_name'],
//              style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontStyle: FontStyle.italic,
//                  fontSize: 30),
//              textAlign: TextAlign.center,
//            ),
//            Divider(
//              color: Colors.blue,
//            ),
//            SizedBox(
//              height: 10,
//            ),
            Card(
//                    color: Colors.blue[100],
              color: Colors.white,
              margin: EdgeInsets.all(5),
              elevation: 0.7,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Case History',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(((data['case_history']))),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
//            Text(
//              'Case history',
//              style: TextStyle(color: Colors.green[400], fontSize: 22),
//              textAlign: TextAlign.center,
//            ),
//            SizedBox(height: 10),
//            Text(
//              data['case_history'],
//              style: TextStyle(
//                  fontStyle: FontStyle.italic,
//                  fontSize: 20,
//                  fontWeight: FontWeight.bold),
//              textAlign: TextAlign.center,
//            ),
//            Divider(
//              color: Colors.green[400],
//            ),
            Card(
//                    color: Colors.blue[100],
              color: Colors.white,
              margin: EdgeInsets.all(5),
              elevation: 0.7,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Medication',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(((data['medication']))),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
//            Text(
//              'Medication',
//              style: TextStyle(color: Colors.green[400], fontSize: 22),
//              textAlign: TextAlign.center,
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            Text(
//              data['medication'],
//              textAlign: TextAlign.center,
//              style: TextStyle(
//                  fontStyle: FontStyle.italic,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 24),
//            ),
//            Divider(
//              color: Colors.green[400],
//            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(child: Text('Download Prescription', style: TextStyle(color: Colors.lightBlueAccent),),onPressed: download, ),
            FutureBuilder<String>(
              future: downloadedFilePath,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                Text text = Text('');
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    text = Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
//                    text = Text('Data: ${snapshot.data}');
//                    return PdfRenderer(pdfFile: snapshot.data, width: 500.0);
                  } else {
                    text = Text('Unavailable');
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  text = Text('Downloading PDF File...');
                } else {
//                  text = Text('Please load a PDF file.');
                }
                return Container(
                  child: text,
                );
              },
            ),
            data['submitted'] == "0"
                ? FlatButton(
                    child: Text(
                      'submit to pharmacist',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    onPressed: confirmSubmission,
                  )
                : Text(
                    'status : submitted ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
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

                      )
                    : Text("")
          ],
        ) : Text(''),
      ),
    );
  }
}
