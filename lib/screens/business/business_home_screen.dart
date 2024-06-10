import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../court/court_screen.dart';
import 'business_mypage_screen.dart';
import 'settlement_screen.dart'; // 정산하기 스크린 임포트

class BusinessHomeScreen extends StatefulWidget {
  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    CourtsScreen(),
    SettlementScreen(),
    BusinessMyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테니스 재미쓰'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.sports_tennis), label: '코트'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: '매출'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
