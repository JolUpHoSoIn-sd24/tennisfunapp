import 'package:flutter/material.dart';
import 'screens/signup/sign_up_screen.dart';
import 'screens/signup/sign_up_done_screen.dart'; // Assuming this exists

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tennis Fun App',
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpScreen(),
        '/signupSuccess': (context) => SignUpDoneScreen(),
      },
    );
  }
}
