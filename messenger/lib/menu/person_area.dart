import 'package:flutter/material.dart';
import 'package:messenger/user/user.dart';
import 'package:provider/provider.dart';

class PersonArea extends StatefulWidget {
  PersonArea({Key key}) : super(key: key);

  @override
  _PersonAreaState createState() => _PersonAreaState();
}

class _PersonAreaState extends State<PersonArea> {
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
                    child: Icon(
                      Icons.add,
                      color: Colors.grey[600],
                      size: 60,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Text(
                      Provider.of<User>(context, listen: true).nickname,
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
                      child: Text(
                        "Вкладки",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
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

  /*void updateNickname() {
    Provider.of<User>(context, listen: false).setNickname = nickController.text;
  }*/
}
