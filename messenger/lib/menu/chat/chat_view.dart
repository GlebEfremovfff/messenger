import 'package:flutter/material.dart';
import 'package:messenger/menu/chat/app_search.dart';

class ChatView extends StatefulWidget {
  ChatView({Key key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Chats",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    AppSearch(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
