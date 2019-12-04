import 'package:flutter/material.dart';

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
                  onPressed: () => Navigator.pushNamed(context, '/doctor-login'),
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
                  onPressed: () => Navigator.pushNamed(context, '/patient-login'),
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
