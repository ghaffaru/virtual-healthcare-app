import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:v_healthcare/pusher_service_initial.dart';
import 'package:v_healthcare/custom/constants.dart';
class Chat extends StatefulWidget {
  final idToken;
  final doctorId;

  Chat({this.idToken, this.doctorId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  String messageText;
  List conversation;
  Stream conversation2;
  int userId;
  FocusNode _focusNode = FocusNode();
  AnimationController _controller;

  PusherService pusherService = PusherService();

  final ScrollController _scrollController = ScrollController();

  Future getUser() async {
    final idToken = widget.idToken;
    final doctorId = widget.doctorId;

    final http.Response response =
        await http.get('$remoteUrl/api/user', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

    setState(() {
      userId = jsonDecode(response.body)['id'];
    });
    return jsonDecode(response.body)['email'];
    print('User id $userId');
  }

  Future sendMessage() async {
    final idToken = widget.idToken;
    final doctorId = widget.doctorId;

    Map<String, dynamic> data = {
      'message': messageText,
      'id': doctorId,
      'owner': 'patient'
    };

    final http.Response response =
        await http.post('$remoteUrl/api/patient/doctor/message',
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer $idToken',
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.contentTypeHeader: 'application/json'
            },
            body: jsonEncode(data));

    print(jsonEncode(data));
    print(response.statusCode);
    print(response.body);
  }

  // ignore: missing_return
  Future<Stream> displayMyMessages() async {
    final idToken = widget.idToken;
    final doctorId = widget.doctorId;

    final http.Response response = await http
        .get('$remoteUrl/api/patient/doctor/message', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

    print(response.statusCode);
    print(jsonDecode(response.body)['data'][0]);
    final int conversationId =
        jsonDecode(response.body)['data'][0]['conversation_id'];
    print(conversationId);
    final http.Response response2 = await http
        .get('$remoteUrl/api/$conversationId/conversation', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    print(jsonDecode(response2.body)['data']);

    setState(() {
      conversation = jsonDecode(response2.body)['data'];
    });
    await for (var snapshot in conversation2) {
      for (var message in snapshot.message) {
        print(message);
      }
    }
//    print(conversation[0]['message']);
  }

  @override
  void initState() {
    pusherService = PusherService();
    pusherService.firePusher('chat', 'message');
    getUser();
    displayMyMessages();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(Chat oldWidget) {
    displayMyMessages();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    pusherService.unbindEvent('message');
    _controller.dispose();
    _focusNode.dispose();
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
                  displayMyMessages();
//                _auth.signOut();
//                Navigator.pop(context);
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
//          child: StreamBuilder(
//            stream: pusherService.eventStream,
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              if (!snapshot.hasData) {
//                return CircularProgressIndicator();
//              }
//              final Map<dynamic, dynamic> messages = jsonDecode(snapshot.data);
////              return Container(child: Text(messages.);
//              List<MessageBubble> messageBubbles = [];
//
//              for (var message in messages['message']) {
//                final messageText = message.data['message'];
//                final messageSender = message.data['sender_id'];
//                final currentUser = getUser();
//
//
//
//                final messageBubble =
//                MessageBubble(sender: messageSender,
//                  text: messageText,
//                  isMe: currentUser == messageSender,);
//
//                messageBubbles.add(messageBubble);
//              }
//              return Expanded(
//                child: ListView(
//                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//                  children: messageBubbles,
//                  reverse: true,
//                ),
//              );
//            },
//          ),
          child: KeyboardAvoider(
            autoScroll: true,
            child: ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: conversation == null ? 0 : conversation.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: conversation[index]['owner'] == 'patient'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
//                    Text(sender),
                            Material(
                              elevation: 5.0,
                              borderRadius: conversation[index]['owner'] == 'patient'
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30))
                                  : BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                              color: conversation[index]['owner'] == 'patient'
                                  ? Colors.lightBlueAccent
                                  : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  conversation[index]['message'],
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: conversation[index]['owner'] == 'patient'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
          ),

      ),

      bottomNavigationBar: Container(

        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          ),
        ),
        child: Row(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                scrollController: ScrollController(),
                controller: messageTextController,
                focusNode: _focusNode,
                onChanged: (value) {
                  //Do something with the user input.
                  messageText = value;
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: 'Type your message here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                //Implement send functionality.
                messageTextController.clear();
                sendMessage();
                displayMyMessages();
              },
              child: Text(
                'Send',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
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
        crossAxisAlignment: isMe ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender),
          Material(
            elevation: 5.0,
            borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)) :

            BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
            color: isMe ?  Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 15.0,
                    color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
