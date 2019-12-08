import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:v_healthcare/custom/constants.dart';
import 'package:v_healthcare/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorLogin extends StatefulWidget {
  String message;
  bool leading = true;

  DoctorLogin({this.message, this.leading});

  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  @override
  void initState() {
//     autoAuthenticate();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey();

  String email;
  String password;
  Map<String, dynamic> errorMessage = {};
  String error = '';
  String token;
  String message;
  bool showSpinner = false;

  void submitForm() async {
    setState(() {
      showSpinner = true;
    });

    if (!formKey.currentState.validate()) {
      setState(() {
        showSpinner = false;
      });
      return;
    }
    formKey.currentState.save();

    errorMessage = await login();

    if (!errorMessage['success']) {
      setState(() {
        error = 'invalid credentials';
      });
    }

    if (errorMessage['message'] == 'Authentication succeeded') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Account(),
        ),
      );

      setState(() {
        showSpinner = false;
      });
    }
  }

  Future getUser() async {

  }
  Future<Map<String, dynamic>> login() async {
//    try {
//      final result = await InternetAddress.lookup('google.com');
//      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//        print('connected');
//      }
//    } on SocketException catch (_) {
//      setState(() {
//        showSpinner = false;
//        error = 'No connection';
//      });
//    }

    final Map<String, dynamic> data = {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': '$clientSecret',
      'username': '$email',
      'password': '$password',
      'provider': 'doctors'
    };
    print(json.encode(data));
    final http.Response response = await http.post('$remoteUrl/oauth/token',
        body: json.encode(data), headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
//    String message = 'Something went wrong';
    if (responseData.containsKey('access_token')) {
      hasError = false;
      message = 'Authentication succeeded';
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['access_token']);

      setState(() {
        token = responseData['access_token'];
      });
    } else if (responseData['error'] == 'invalid_credentials') {
      message = 'Invalid credentials';
      setState(() {
        showSpinner = false;
      });
    }
    return {'success': !hasError, 'message': message};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        title: Center(
          widthFactor: 4,
          child: Text('Doctor'),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          //        mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
//                  CircleAvatar(child: Image.network('https://cdn2.vectorstock.com/i/1000x1000/36/61/doctor-logo-icon-design-vector-15613661.jpg', height: 200,),),
                  Center(
                    child: Text(
                      widget.message != null ? widget.message : "",
                      style: TextStyle(
                          fontSize: 20, color: Colors.lightBlueAccent),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                      onSaved: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'The email field is required';
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                      obscureText: true,
                      onSaved: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'The password field is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    RoundedButton(
                      title: 'Login',
                      colour: Colors.lightBlueAccent,
                      onPressed: submitForm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          FlatButton(onPressed: null, child: Text('Forgot Password ?')),
    );
  }
}
