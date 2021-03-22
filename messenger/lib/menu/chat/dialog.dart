import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/menu/chat/chat_list_view/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:messenger/menu/database_helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class DialogPers extends StatefulWidget {
  DialogPers({Key key}) : super(key: key);

  @override
  _DialogPersState createState() => _DialogPersState();
}

class _DialogPersState extends State<DialogPers> {
  TextEditingController messContr = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Message> messageList;
  int bot_id = 1;
  bool has_started = true;

  @override
  Widget build(BuildContext context) {
    if (messageList == null) {
      messageList = List<Message>();
      updateListView();
    }
    updateListView();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Mediachat Bot",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 17),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[350],
                child: Icon(
                  Icons.adb,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[850],
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 80),
              child: ListView.builder(
                reverse: true,
                itemCount: messageList.length,
                itemBuilder: (BuildContext context, int pos) {
                  return MessageCard(messageList[pos]);
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: TextField(
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Message",
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[400],
                          ),
                        ),
                        controller: messContr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.send, color: Colors.white),
                    onTap: () async {
                      setState(() {
                        _save(context, Message(messContr.text, 0));
                      });
                      if (messContr.text == '/start') {
                        has_started = true;
                        setState(() {
                          createBot();
                          _save(context, Message('Bot woke up!', 1));
                        });
                      } else if (messContr.text != '/start' && !has_started) {
                        setState(() {
                          _save(
                              context,
                              Message(
                                  'Bot are sleeping. Send "/start" to wake him!',
                                  1));
                        });
                      } else {
                        setState(() {
                          sendMessage(context, messContr.text);
                        });
                      }
                      messContr.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MessageCard(Message message) {
    return Padding(
      padding: message.from_bot == 0
          ? EdgeInsets.only(right: 15, top: 10, left: 60)
          : EdgeInsets.only(left: 15, top: 10, right: 60),
      child: Container(
        alignment: message.from_bot == 0
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
          decoration: BoxDecoration(
            color: message.from_bot == 0 ? Colors.grey[700] : Colors.grey[800],
            borderRadius: message.from_bot == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))
                : BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  void sendMessage(BuildContext context, String mess) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final msg = jsonEncode({
      'message': {
        'bot_id': bot_id,
        'chat_id': 2,
        'from_bot': false,
        'text': mess
      }
    });
    var url =
        Uri.parse('http://mediachatlive.fvds.ru:5000/webgram-api/send_message');
    await http.post(url, body: msg, headers: headers).then((response) {
      dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
      _save(context, Message(jsonObject['text'].toString(), 1));
      print(response.body);
    });
    /*url =
        Uri.parse('http://mediachatlive.fvds.ru:5000/webgram-api/get_history');
    final ms = jsonEncode({'bot_id': bot_id, 'user_id': 2});
    await http.post(url, body: ms, headers: headers).then((response) {
      dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonObject);
    });*/ // Get a history
  }

  void _save(BuildContext context, Message message) async {
    int result;
    result = await databaseHelper.insertMessage(message);
    updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initDb();
    dbFuture.then((database) {
      Future<List<Message>> messageListFuture = databaseHelper.getMessageList();
      messageListFuture.then((messageList) {
        setState(() {
          this.messageList = messageList;
        });
      });
    });
  }

  void createBot() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final msg = jsonEncode({
      'name': 'Mediachat Bot',
      'server_webhook': 'http://mediachatlive.fvds.ru:5000/webgram/webhook'
    });
    var url =
        Uri.parse('http://mediachatlive.fvds.ru:5000/webgram-api/create_bot');
    await http.post(url, body: msg, headers: headers).then((response) {
      dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
      bot_id = jsonObject['id'];
      print(bot_id);
    });
  }
}
