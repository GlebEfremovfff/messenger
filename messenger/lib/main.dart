import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/menu/bottom_bar.dart';
import 'package:messenger/registation/registration.dart';
import 'package:messenger/user/user.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void read_logged() async {
    await this._readTextFromLocalFile_logged();
  }

  void read_id() async {
    await this._readTextFromLocalFile_id();
  }

  String _localFileContent_logged = "none";
  String _localFileContent_id = "none";

  @override
  void initState() {
    super.initState();
    this.read_logged();
    this.read_id();
  }

  @override
  Widget build(BuildContext context) {
    //print(_localFileContent_id);
    return ChangeNotifierProvider<User>(
      create: (context) => User(),
      child: MaterialApp(
        title: 'Flutter messenger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          body: _localFileContent_logged != "1"
              ? Registration()
              : BottomBar(_localFileContent_id),
        ),
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile_logged async {
    final path = await _getLocalPath;
    return File('$path/loged.txt');
  }

  Future _readTextFromLocalFile_logged() async {
    String content;
    try {
      final file = await _getLocalFile_logged;
      content = await file.readAsString();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() {
      this._localFileContent_logged = content;
    });
  }

  Future<File> get _getLocalFile_id async {
    final path = await _getLocalPath;
    return File('$path/id.txt');
  }

  Future _readTextFromLocalFile_id() async {
    String content;
    try {
      final file = await _getLocalFile_id;
      content = await file.readAsString();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() {
      this._localFileContent_id = content;
    });
  }
}
