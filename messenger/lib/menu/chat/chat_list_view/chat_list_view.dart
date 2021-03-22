import 'package:flutter/material.dart';
import 'package:messenger/menu/chat/chat_list_view/chat.dart';
import 'package:messenger/menu/chat/chat_list_view/chat_card.dart';
import 'package:messenger/menu/chat/dialog.dart';

class ChatListView extends StatefulWidget {
  ChatListView({Key key}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  List<Chat> chatlist = [Chat("Mediachat Bot")];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: chatlist.length,
        itemBuilder: (BuildContext context, int pos) {
          return Dismissible(
            key: Key(chatlist[pos].title),
            background: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Are you sure wanna delete this?"),
                        actions: <Widget>[
                          FlatButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                return Navigator.of(context).pop();
                              }),
                          FlatButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      );
                    });
              }
            },
            child: GestureDetector(
              child: ChatCard(
                chatlist[pos].title,
                Icon(
                  Icons.adb,
                  color: Colors.grey[600],
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DialogPers()));
              },
            ),
          );
        });
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red[700],
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
