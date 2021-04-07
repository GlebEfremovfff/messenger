import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:messenger/menu/chat/chat_view.dart';
import 'package:messenger/menu/person_area.dart';
import 'package:messenger/user/user.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  String id;
  BottomBar(this.id);
  @override
  _BottomBarState createState() => _BottomBarState(this.id);
}

class _BottomBarState extends State<BottomBar> {
  String id;
  _BottomBarState(this.id);
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ChatView(),
    PersonArea(
        "Misha",
        Icon(
          Icons.add,
          color: Colors.grey[600],
          size: 60,
        ),
        true)
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<User>(context, listen: false).setId = int.parse(id);
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        color: Colors.black,
        backgroundColor: Colors.black87,
        items: <Widget>[
          _selectedIndex == 0
              ? Icon(
                  Icons.chat,
                  color: Colors.red[900],
                  size: 35,
                )
              : Icon(Icons.chat, color: Colors.white),
          _selectedIndex == 1
              ? Icon(Icons.person, color: Colors.red[900], size: 35)
              : Icon(Icons.person, color: Colors.white),
        ],
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
