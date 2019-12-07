import 'package:flutter/material.dart';
import 'package:v_healthcare/doctor/drawer.dart';
class Account extends StatefulWidget {

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome'),),
      drawer: DrawerWidget(),
    );
  }
}
