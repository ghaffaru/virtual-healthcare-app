import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
final _firestore = Firestore.instance;


class Chats extends StatefulWidget {


  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {




  List doctorMessages;
  void messagesStream() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String doctorId = prefs.getString('doctor_id');
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        if (message.data['doctor_id'])
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    messagesStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
