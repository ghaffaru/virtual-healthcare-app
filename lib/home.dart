import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_healthcare/patient/accounts.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Healthcare',
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20.0),
                child: MaterialButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/doctor-login'),
                  minWidth: 300.0,
                  height: 42.0,
                  child: Text(
                    'Doctor sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
//            RaisedButton(child: Text('Doctor Sign in'),),
//            RaisedButton(child: Text('Patient Sign in'),)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20.0),
                child: MaterialButton(
                  onPressed: () async {
                    final SharedPreferences prefs = await SharedPreferences
                        .getInstance();
                    String token = prefs.getString('token');
                    if (token == null) {
                      Navigator
                          .pushNamed(context, '/patient-login');
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) => Account(),
                      ),);
                    }
                  },
                  minWidth: 300.0,
                  height: 42.0,
                  child: Text(
                    'Patient sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
