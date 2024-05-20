import 'package:flutter/material.dart';

class SignUpDoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Completed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Congratulations!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your account has been successfully created.\n이메일 인증 후 로그인해주세요.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => {
                Navigator.pop(context),
                Navigator.pop(context),
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
