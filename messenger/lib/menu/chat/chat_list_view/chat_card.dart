import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  String title;
  Icon icon;
  ChatCard(this.title, this.icon);
  @override
  _ChatCardState createState() => _ChatCardState(title, icon);
}

class _ChatCardState extends State<ChatCard> {
  String title;
  Icon icon;
  _ChatCardState(this.title, this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Column(
        children: <Widget>[
          Container(
            height: 70,
            color: Colors.grey[850],
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Container(
                    child: Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[350],
                        child: icon,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
