import 'dart:io';

import 'package:messenger/menu/chat/chat_list_view/message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String messageTable = 'note_table';
  String colId = 'id';
  String colMessage = 'message';
  String colFromBot = 'fromBot';
  String colIsButton = 'isButton';
  String colIsVisible = 'isVisible';
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'messages.db';

    var messagesDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return messagesDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $messageTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colMessage TEXT, $colFromBot INTEGER, $colIsButton INTEGER, $colIsVisible INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getMessageMapList() async {
    Database db = await this.database;

    var result = await db.query(messageTable, orderBy: '$colId DESC');
    return result;
  }

  Future<int> insertMessage(Message message) async {
    Database db = await this.database;
    var result = await db.insert(messageTable, message.toMap());
    return result;
  }

  Future<int> updateMessage(Message message) async {
    var db = await this.database;
    var result = await db.update(messageTable, message.toMap(),
        where: '$colId = ?', whereArgs: [message.id]);
    return result;
  }

  Future<int> deleteMessage(int id) async {
    var db = await this.database;
    var result = db.delete(messageTable, where: '$colId = $id');
    return result;
  }

  Future<int> getCount() async {
    var db = await this.database;
    List<Map<String, dynamic>> m =
        await db.rawQuery('SELECT COUNT (*) FROM $messageTable');
    int result = Sqflite.firstIntValue(m);
    return result;
  }

  Future<List<Message>> getMessageList() async {
    var messageMapList = await getMessageMapList();
    int count = messageMapList.length;
    List<Message> messageList = List<Message>();
    for (int i = 0; i < count; i++) {
      messageList.add(Message.fromMapObject(messageMapList[i]));
    }
    return messageList;
  }

  Future<int> clearTable() async {
    var db = await this.database;
    var result = db.delete(messageTable);
    return result;
  }

  Future<int> deleteButtons() async {
    var db = await this.database;
    var result = db.delete(messageTable, where: '$colIsButton = 1');
    return result;
  }

  Future<int> hideButtons() async {
    var db = await this.database;
    var result = await db.rawUpdate(
        'UPDATE $messageTable SET $colIsVisible = ? WHERE $colIsButton = ?',
        [0, 1]);
    return result;
  }
}
