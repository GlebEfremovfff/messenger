import 'package:flutter/material.dart';
import 'package:messenger/menu/database_helper/database_helper.dart';

class PersonArea extends StatefulWidget {
  String name;
  Icon avatar;
  bool isMe;
  PersonArea(this.name, this.avatar, this.isMe);

  @override
  _PersonAreaState createState() => _PersonAreaState(name, avatar, isMe);
}

class _PersonAreaState extends State<PersonArea> {
  String name;
  Icon avatar;
  bool isMe;
  _PersonAreaState(this.name, this.avatar, this.isMe);
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController nickController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[900],
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[350],
                    child: avatar,
                  ),
                ),
              ),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    )),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: isMe
                          ? Text(
                              "Вкладки",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                clearHistory();
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.clear_all,
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        "Clear history",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearHistory() async {
    int result;
    result = await databaseHelper.clearTable();
  }

  /*void updateNickname() {
    Provider.of<User>(context, listen: false).setNickname = nickController.text;
  }*/
}
