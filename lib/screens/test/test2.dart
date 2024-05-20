import 'package:flutter/material.dart';

class TestScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen 2'),
      ),
      body: Center(
        child: Text(
          'This is a test screen 2.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
