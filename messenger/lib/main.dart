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
  void read() async {
    await this._readTextFromLocalFile();
  }

  String _localFileContent = "none";

  @override
  void initState() {
    super.initState();
    this.read();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>(
      create: (context) => User(),
      child: MaterialApp(
        title: 'Flutter messenger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: /*_localFileContent != "1" ? Registration() : */ BottomBar(),
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/loged.txt');
  }

  Future _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() {
      this._localFileContent = content;
    });
  }
}
