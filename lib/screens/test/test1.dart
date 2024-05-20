import 'package:flutter/material.dart';

class TestScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen 1'),
      ),
      body: Center(
        child: Text(
          'This is a test screen 1.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
