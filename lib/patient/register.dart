import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'dart:io';
import 'package:v_healthcare/custom/constants.dart';
import 'package:v_healthcare/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';

class PatientRegister extends StatefulWidget {
  @override
  _PatientRegisterState createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  String name;
  String email;
  String password;

//  String region;
  String residence;
  String phone;
  String date_of_birth;

  String selectedRegion;

  bool showSpinner = false;
  String emailError;

  void submitForm() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      showSpinner = true;
    });
    await register();
  }

  Future register() async {
    final Map<String, dynamic> data = {
      'name': '$name',
      'email': '$email',
      'password': '$password',
      'region': '$selectedRegion',
      'residence': '$residence',
      'phone': '$phone',
      'date_of_birth': '$date_of_birth'
    };

    print(json.encode(data));
    final http.Response response = await http.post(
      '$remoteUrl/api/patient/register',
      body: json.encode(data),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 422) {
      setState(() {
        showSpinner = false;
        emailError = 'Email has already been taken';
      });
    }else {
//      Navigator.popAndPushNamed(context, routeName)
//      Navigator.pop(context);
//      Navigator.pushReplacementNamed(context, '/patient-login',
//          arguments: {'message': 'You can now log in'});
//    }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => PatientLogin(message: 'You can now log in '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          widthFactor: 3.5,
          child: Text('Register'),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (String value) {
                      if (value.isEmpty) return 'This field is required';
                    },
                    onSaved: (String value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (String value) {
                      if (value.isEmpty)
                        return 'This field is required';
                      else if (emailError != null) {
                        return 'The email has already been taken';
                      }else if (!EmailValidator.validate(value))
                        return 'Not a valid email';
                    },
                    onSaved: (String value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: passwordController,
                    validator: (String value) {
                      if (value.isEmpty) return 'This field is required';
                    },
                    onSaved: (String value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (String value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownButtonFormField(
                      validator: (String value) {
                        if (value == null) {
                          return 'The region field is required';
                        }
                      },
                      onChanged: (String value) {
                        setState(() {
                          selectedRegion = value;
                        });
                      },
                      value: selectedRegion,
                      hint: Text('Region'),
                      items: [
                        DropdownMenuItem(
                          child: Text('Greater Accra'),
                          value: 'Greater Accra',
                        ),
                        DropdownMenuItem(
                          child: Text('Ashanti Region'),
                          value: 'Ashanti Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Brong Ahafo Region'),
                          value: 'Brong Ahafo Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Northern Region'),
                          value: 'Northern Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Upper East Region'),
                          value: 'Upper East Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Upper West Region'),
                          value: 'Upper West Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Central Region'),
                          value: 'Central Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Western Region'),
                          value: 'Western Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Volta Region'),
                          value: 'Volta Region',
                        ),
                        DropdownMenuItem(
                          child: Text('Eastern Region'),
                          value: 'Eastern Region',
                        )
                      ]),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Residence'),
                    validator: (String value) {
                      if (value.isEmpty) return 'This field is required';
                    },
                    onSaved: (String value) {
                      setState(() {
                        residence = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (String value) {
                      if (value.isEmpty) return 'This field is required';
                    },
                    onSaved: (String value) {
                      setState(() {
                        phone = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DateTimeField(
                    validator: (DateTime date) {
                      if (date == null) {
                        return 'The date field is required';
                      }
                    },
                    decoration: InputDecoration(labelText: 'Date of birth'),
                    format: format,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    onSaved: (DateTime date) {
                      final new_date = DateFormat('dd-MM-yyyy').format(date);
                      setState(() {
                        date_of_birth = new_date.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.lightBlueAccent,
                    onPressed: submitForm,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
