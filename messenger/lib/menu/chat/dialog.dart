import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/menu/chat/chat_list_view/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:messenger/menu/database_helper/database_helper.dart';
import 'package:messenger/menu/person_area.dart';
import 'package:messenger/user/user.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class DialogPers extends StatefulWidget {
  DialogPers({Key key}) : super(key: key);

  @override
  _DialogPersState createState() => _DialogPersState();
}

class _DialogPersState extends State<DialogPers> {
  TextEditingController messContr = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  FocusNode fnode = FocusNode();
  List<Message> messageList;
  List<String> keyList;
  String _localFileContent = '';
  int bot_id = 1;
  bool has_started = true;
  int id;
  bool isKeyboard = true;
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    id = Provider.of<User>(context, listen: true).id;

    if (messageList == null) {
      messageList = List<Message>();
      updateListView();
    }
    if (keyList == null) {
      keyList = List<String>();
    }
    updateListView();
    return Scaffold(
      key: scaffoldState,
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PersonArea(
                            "Mediachat Bot",
                            Icon(
                              Icons.adb,
                              color: Colors.grey[600],
                              size: 60,
                            ),
                            false)));
              },
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
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  isKeyboard = true;
                  if (FocusScope.of(context).hasFocus) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (BuildContext context, int pos) {
                      if (messageList[pos].is_visible == 1 &&
                          messageList[pos].text.isNotEmpty) {
                        if (messageList[pos].is_button == 0) {
                          return MessageCard(messageList[pos]);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isKeyboard = true;
                          });
                        },
                        focusNode: fnode,
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
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      child: Icon(
                        isKeyboard ? Icons.apps_outlined : Icons.keyboard,
                        color: Colors.white,
                      ),
                      onTap: () {
                        if (isKeyboard) {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          }
                        } else {
                          FocusScope.of(context).requestFocus(fnode);
                        }
                        setState(() {
                          isKeyboard = !isKeyboard;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.send, color: Colors.white),
                    onTap: () async {
                      setState(() {
                        _save(context, Message(messContr.text, 0, 0, 1));
                        sendMessage(context, messContr.text);
                      });
                      messContr.clear();
                    },
                  ),
                ],
              ),
            ),
            !isKeyboard
                ? Container(
                    height: 200,
                    color: Colors.black,
                    child: ListView.builder(
                      itemCount: keyList.length,
                      itemBuilder: (context, int pos) {
                        return GestureDetector(
                          onTap: () async {
                            int result;
                            result = await databaseHelper.deleteButtons();
                            _sendButtonData(context, keyList[pos]);
                          },
                          child: ButtonsCard(keyList[pos]),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: 1,
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

  Widget ButtonsCard(String data) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 40,
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1),
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(1),
              bottomLeft: Radius.circular(1),
            ),
          ),
          child: Center(
            child: Text(
              data,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
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
        'chat_id': id,
        'from_bot': false,
        'text': mess
      }
    });
    var url =
        Uri.parse('http://mediachatlive.fvds.ru:5000/webgram-api/send_message');
    await http.post(url, body: msg, headers: headers).then((response) {
      dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
    });
    url = Uri.parse(
        'http://mediachatlive.fvds.ru:5000/webgram-api/get_bot_update');
    int msg_id = await databaseHelper.getCount();
    msg_id -= 1;
    var par =
        jsonEncode({'bot_id': bot_id, 'user_id': id, 'message_id': msg_id});
    bool new_getted = false;
    int cnt = 0;

    while (!new_getted) {
      cnt += 1;
      if (cnt > 5) {
        break;
      }
      await Future.delayed(Duration(seconds: 2));
      await http.post(url, body: par, headers: headers).then((response) {
        dynamic jsonObject =
            convert.jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonObject['reply_keyboard'] != null) {
          dynamic btns = jsonObject['reply_keyboard'];
          List<String> bnts_list = List<String>();
          btns.forEach((btn) {
            bnts_list.add(btn.toString());
          });
          setState(() {
            this.keyList = bnts_list;
          });
        }
        if (jsonObject['messages'] != null) {
          print(jsonObject['messages']);
          dynamic msgs = jsonObject['messages'];
          msgs.forEach((obj) {
            if (obj != null) {
              _save(context, Message.fromJsonObject(obj));
            }
          });
          new_getted = true;
        }
      });
    }
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

  void _sendButtonData(BuildContext context, String data) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final button_info = jsonEncode({
      'callback_query': {'bot_id': bot_id, 'chat_id': id, 'data': data}
    });
    var url =
        Uri.parse('http://mediachatlive.fvds.ru:5000/webgram-api/click_button');
    await http.post(url, body: button_info, headers: headers).then((response) {
      dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
    });
    url = Uri.parse(
        'http://mediachatlive.fvds.ru:5000/webgram-api/get_bot_update');
    int msg_id = await databaseHelper.getCount();
    msg_id -= 1;
    var par =
        jsonEncode({'bot_id': bot_id, 'user_id': id, 'message_id': msg_id});
    bool new_getted = false;
    int cnt = 0;
    while (!new_getted) {
      cnt += 1;
      if (cnt > 5) {
        break;
      }
      await Future.delayed(Duration(seconds: 2));
      await http.post(url, body: par, headers: headers).then((response) {
        dynamic jsonObject =
            convert.jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonObject['reply_keyboard'] != null) {
          dynamic btns = jsonObject['reply_keyboard'];
          List<String> bnts_list = List<String>();
          btns.forEach((btn) {
            bnts_list.add(btn.toString());
          });
          setState(() {
            this.keyList = bnts_list;
          });
        }
        if (jsonObject['messages'] != null) {
          dynamic msgs = jsonObject['messages'];
          msgs.forEach((obj) {
            if (obj != null) {
              _save(context, Message.fromJson(obj));
            }
          });
          new_getted = true;
        }
      });
    }
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
