import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:v_healthcare/pusher_service_initial.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_healthcare/custom/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'prescribe.dart';

final _firestore = Firestore.instance;

class Chat extends StatefulWidget {
  final userId;

  Chat(this.userId);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  String messageText;
  String doctorId;

  Future setUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(widget.userId);
    prefs.setString('user_id', widget.userId.toString());
  }

  Future getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorId = prefs.getString('doctor_id');
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
    String userId = prefs.getString('user_id');

    final Map<String, dynamic> data = {
      'user_id': '$userId',
      'message': '$messageText',
      'sender': 'doctor',
    };
    final http.Response response =
        await http.post('$remoteUrl/api/doctor/patient/chat',
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
    setUserId();
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
//            Text('Create Prescription'),
            IconButton(
                icon: Icon(Icons.book),
                tooltip: 'Create prescription',
                onPressed: () {
                  //Implement logout functionality
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (
                        BuildContext context,
                      ) =>
                              Prescribe(userId: widget.userId,)));
                }),
          ],
          title: Text('⚡️Chat'),
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

                        String doctorId = prefs.getString('doctor_id');
                        _firestore.collection("messages").add({
                          'user_id': widget.userId.toString(),
                          'doctor_id': doctorId.toString(),
                          'message': messageText,
                          'sender': 'doctor',
                          'timestamp':
                              DateTime.now().millisecondsSinceEpoch.toString(),
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
      userId = prefs.getString('user_id');
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
      stream: _firestore
          .collection("messages")
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text(''));
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final messageText = message.data['message'];
          final messageSender = message.data['doctor_id'];
          final messageReceiver = message.data['user_id'];
          final currentUser = doctorId;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: message.data['sender'] == 'doctor',
          );
//          print(messageSender);
          print(userId);
          if ((messageSender == currentUser) && (messageReceiver == userId)) {
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
