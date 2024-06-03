import 'package:flutter/material.dart';
import 'package:tennisfunapp/screens/business/business_home_screen.dart';
import 'package:tennisfunapp/screens/home/home_screen.dart';
import 'package:tennisfunapp/screens/login/login_screen.dart';
import 'package:tennisfunapp/screens/match/request_matching_page.dart';
import 'package:tennisfunapp/screens/signup/sign_up_done_screen.dart';
import 'package:tennisfunapp/screens/signup/sign_up_screen.dart';
import 'package:tennisfunapp/services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tennis Fun App',
      theme: ThemeData(
        primaryColor: const Color(0xFF474EFF),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Remove initialRoute to use home property with FutureBuilder
      home: FutureBuilder(
        future: _authService.isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data == true) {
              // User is logged in, send them to the home screen
              return HomeScreen();
            } else {
              // User is not logged in, send them to the login screen
              return LoginScreen();
              //return HomeScreen();
            }
          } else {
            // While checking the login state, show a loading spinner
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
        '/business/home' : (context) => BusinessHomeScreen(),
      },
    );
  }
}
