import 'package:flutter/material.dart';
import 'package:v_healthcare/Chat.dart';
class DoctorView extends StatefulWidget {
  Map<String, dynamic> doctor;

  DoctorView(this.doctor);

  @override
  _DoctorViewState createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(widget.doctor['name']),
        widthFactor: 1.7,
      )),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset(
              'images/doctor.jpg',
              height: 200,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Title: ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.doctor['title'],
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Specialization: ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.doctor['specialization'],
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Hospital: ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.doctor['hospital'],
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.lightBlueAccent,
        child: FlatButton(
            color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Chat(widget.doctor['id'],widget.doctor['is_online'])));
            },
            child: Text('CHAT THIS DOCTOR')),
      ),
    );
  }
}
