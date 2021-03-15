import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'dart:convert';
import 'package:messenger/menu/bottom_bar.dart';
import 'package:path_provider/path_provider.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _nameController = TextEditingController();

  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    "Registration",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[900],
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Icon(
                      Icons.app_registration,
                      color: Colors.white,
                      size: 120,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: TextField(
                        controller: _nameController,
                        obscureText: false,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter name",
                          hintStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[350], width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[200], width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: IconTheme(
                              data: IconThemeData(color: Colors.white),
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: RaisedButton(
                        elevation: 0.0,
                        splashColor: Colors.grey[200],
                        highlightColor: Colors.grey[200],
                        color: Colors.grey[200],
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 30),
                        ),
                        onPressed: () {
                          register_button();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> get_ip() async {
    String ip;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var response =
        await http.get('https://api.ipify.org?format=json', headers: headers);
    dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
    ip = jsonObject['ip'];
    return ip;
  }

  void register_button() async {
    _name = _nameController.text;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    String _ip = await get_ip();
    final msg = jsonEncode({'name': _name, 'client_webhook': _ip});
    var response = await http.post(
        'http://mediachatlive.fvds.ru:5000/webgram-api/create_user',
        body: msg,
        headers: headers);
    dynamic jsonObject = convert.jsonDecode(utf8.decode(response.bodyBytes));
    String id = jsonObject['id'].toString();
    write_id(id);
    write_loged("1");
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => BottomBar()));
  }

  void write_id(String str) async {
    await this._writeTextToLocalFile_id(str);
  }

  void write_loged(String str) async {
    await this._writeTextToLocalFile_loged(str);
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile_id async {
    final path = await _getLocalPath;
    return File('$path/id.txt');
  }

  Future<File> _writeTextToLocalFile_id(String text) async {
    final file = await _getLocalFile_id;
    return file.writeAsString(text);
  }

  Future<File> get _getLocalFile_loged async {
    final path = await _getLocalPath;
    return File('$path/loged.txt');
  }

  Future<File> _writeTextToLocalFile_loged(String text) async {
    final file = await _getLocalFile_loged;
    return file.writeAsString(text);
  }
}
