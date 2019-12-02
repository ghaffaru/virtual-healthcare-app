import 'package:flutter/material.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'accounts.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:v_healthcare/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class Login extends StatefulWidget {
  String message;

  Login({this.message});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  bool showSpinner = false;

  void submitForm() async {
    setState(() {
      showSpinner = true;
    });
    if (!formKey.currentState.validate()) {
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
          builder: (BuildContext context) => Account(token: token),
        ),
      );

      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<Map<String, dynamic>> login() async {
    final Map<String, dynamic> data = {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': '$clientSecret',
      'username': '$email',
      'password': '$password',
      'provider': 'users'
    };
    print(json.encode(data));
    final http.Response response = await http.post(
        'http://10.0.2.2:8000/oauth/token',
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('access_token')) {
      hasError = false;
      message = 'Authentication succeeded';
//      final SharedPreferences prefs = await SharedPreferences.getInstance();
//      prefs.setString('token', responseData['access_token']);

      setState(() {
        token = responseData['access_token'];
      });
    } else if (responseData['error'] == 'invalid_credentials') {
      message = 'Invalid credentials';
    }
    return {'success': !hasError, 'message': message};
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Patient'),
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
              Row(
                children: <Widget>[
                  Center(
                    child: Text(widget.message != null ? widget.message : ""),
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
                    Text(error),
                    RoundedButton(
                      title: 'Login',
                      colour: Colors.blueAccent,
                      onPressed: submitForm,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Text('Already have an account ?'),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    child: Text('Register'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Register(),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
