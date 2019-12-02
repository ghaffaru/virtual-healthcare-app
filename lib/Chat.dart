import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:keyboard_avoider/keyboard_avoider.dart';
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


  final ScrollController _scrollController = ScrollController();

  Future getUser() async {
    final idToken = widget.idToken;
    final doctorId = widget.doctorId;

    final http.Response response =
        await http.get('http://10.0.2.2:8000/api/user', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json'
    });

    setState(() {
      userId = jsonDecode(response.body)['id'];
    });

    print('User id $userId');
  }

  Future sendMessage() async {
    final idToken = widget.idToken;
    final doctorId = widget.doctorId;

    Map<String, dynamic> data = {'message': messageText, 'id': doctorId, 'owner' : 'patient'};

    final http.Response response =
        await http.post('http://10.0.2.2:8000/api/patient/doctor/message',
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
        .get('http://10.0.2.2:8000/api/patient/doctor/message', headers: {
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
        .get('http://10.0.2.2:8000/api/$conversationId/conversation', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $idToken',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    print(jsonDecode(response2.body)['data']);

    setState(() {
      conversation = jsonDecode(response2.body)['data'];
    });
    await for (var snapshot in conversation2) {
      for (var message in snapshot.message ) {
        print(message);
      }
    }
//    print(conversation[0]['message']);
  }

  @override
  void initState() {
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
