import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:v_healthcare/pusher_service_initial.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class Chat extends StatefulWidget {
  final doctorId;
  final doctorStatus;
  Chat(this.doctorId,this.doctorStatus);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  String messageText;
  String userId;

  Future setDoctorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(widget.doctorId);
    prefs.setString('doctor_id', widget.doctorId.toString());
  }

  Future getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id');
    });
//      return prefs.getString('id');
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  Future sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idToken = prefs.getString('token');
    String doctorId = prefs.getString('doctor_id');

    final Map<String, dynamic> data = {
      'doctor_id': '$doctorId',
      'message': '$messageText',
      'sender': 'patient',
    };
    final http.Response response =
        await http.post('$remoteUrl/api/patient/doctor/message',
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $idToken',
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json'
            },
            body: json.encode(data));

    print(response.statusCode);
  }

  @override
  void initState() {
    getUserId();
    setDoctorId();
  }

  @override
  void didUpdateWidget(Chat oldWidget) {
//    displayMyMessages();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality
                }),
          ],
          title: widget.doctorStatus ? Text('⚡Online') : Text('Offline'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          //Do something with the user input.
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        //Implement send functionality.
                        messageTextController.clear();
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        String userId = prefs.getString('id');
                        _firestore.collection("messages").add({
                          'user_id': userId.toString(),
                          'doctor_id': widget.doctorId.toString(),
                          'message': messageText,
                          'sender': 'patient',
                          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                        });

                        sendMessage();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class MessagesStream extends StatefulWidget {
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  String userId;
  String doctorId;

  Future getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id');
    });

//      return prefs.getString('id');
  }

  Future getDoctorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorId = prefs.getString('doctor_id');
    });
  }

  @override
  void initState() {
    getDoctorId();
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text(''));
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final messageText = message.data['message'];
          final messageSender = message.data['user_id'];
          final messageReceiver = message.data['doctor_id'];
          final currentUser = userId;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: message.data['sender'] == 'patient',
          );
//          print(messageSender);
          print(doctorId);
          if ((messageSender == currentUser) && (messageReceiver == doctorId)) {
            messageBubbles.add(messageBubble);
          }
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
            reverse: true,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
//          Text(sender),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15.0, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
