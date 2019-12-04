import 'package:flutter/material.dart';

final clientSecret = 'ucciLOxut8kCv175N9UZvRL2WANOq1ott7WVGbac';
//final clientSecret = 'Z74s1YLfKaF3WxRYhO8feG42vY1zqmr7HNCX7Nh8';
final remoteUrl = 'http://10.0.2.2:8000';
//final remoteUrl = 'https://virtual-healthcare.herokuapp.com';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ), 
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);