import 'package:flutter/material.dart';

import 'auth/login.dart';

//import 'package:map_view/map_view.dart';

void main() {
//  MapView.setApiKey('AIzaSyAhcJZADKIAEThe8qWVQn6S2f9nBvfF-qo');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),

    );
  }
}
