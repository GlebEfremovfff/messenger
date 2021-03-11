import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:messenger/menu/chat/chat_view.dart';
import 'package:messenger/menu/person_area.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ChatView(),
    PersonArea(),
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
