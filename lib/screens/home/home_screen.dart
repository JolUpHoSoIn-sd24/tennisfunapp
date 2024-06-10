import 'package:flutter/material.dart';
import 'package:tennisfunapp/screens/match/match_history_screen.dart';
import 'package:tennisfunapp/screens/match/match_info_screen.dart';
import 'package:tennisfunapp/screens/referee/ai_referee_streaming.dart';
import 'package:tennisfunapp/screens/referee/streaming_test.dart';
import 'package:tennisfunapp/screens/test/test1.dart';
import 'package:tennisfunapp/screens/test/test2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    MatchInfoScreen(),
    // AiRefereeStreaming(),
    StreamingTest(),
    MatchHistoryScreen(),
    TestScreen1(),
    TestScreen2(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_tennis), label: '매칭찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: '무인심판'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
