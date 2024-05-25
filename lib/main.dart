import 'package:flutter/material.dart';
import 'package:tennisfunapp/screens/home/home_screen.dart';
import 'package:tennisfunapp/screens/login/login_screen.dart';
import 'package:tennisfunapp/screens/match/request_matching_page.dart';
import 'package:tennisfunapp/screens/signup/sign_up_done_screen.dart';
import 'package:tennisfunapp/screens/signup/sign_up_screen.dart';
import 'package:tennisfunapp/services/auth_service.dart';

void main() {
  runApp(
     MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tennis Fun App',
      home: FutureBuilder(
        future: _authService.isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data == true) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/signupSuccess': (context) => SignUpDoneScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/match-request': (context) => const RequestMatchingPage(),
      },
    );
  }
}

