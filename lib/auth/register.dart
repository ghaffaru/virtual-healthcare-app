import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'dart:io';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController passwordController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  String name;
  String email;
  String password;
  String region;
  String residence;
  String phone;
  String date_of_birth;

  void submitForm() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    await register();
  }

  Future register() async {
    final Map<String, dynamic> data = {
      'name': '$name',
      'email': '$email',
      'password': '$password',
      'region': '$region',
      'residence': '$residence',
      'phone': '$phone',
      'date_of_birth': '$date_of_birth'
    };

    print(json.encode(data));
    final http.Response response = await http.post(
        'http://10.0.2.2:8000/api/patient/register',
        body: json.encode(data),
        headers: {HttpHeaders.acceptHeader : 'application/json',HttpHeaders.contentTypeHeader: 'application/json'},
        );

    print(response.statusCode);
    print(response.body);
    Navigator.of(context).pushReplacement(

      MaterialPageRoute(
        builder: (BuildContext context) => Login(message: 'You can now log in',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Register'),
        ),
      ),
      body: Container(
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
                    if (value.isEmpty) return 'This field is required';
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Region'),
                  validator: (String value) {
                    if (value.isEmpty) return 'This field is required';
                  },
                  onSaved: (String value) {
                    setState(() {
                      region = value;
                    });
                  },
                ),
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
                    final new_date= DateFormat('dd-MM-yyyy').format(date);
                    setState(() {

                      date_of_birth = new_date.toString();
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                RaisedButton(
                  child: Text('Register'),
                  onPressed: submitForm,
                )
              ],
            )),
      ),
    );
  }
}


