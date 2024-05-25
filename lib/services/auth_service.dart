import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String _baseUrl = "https://localhost:8080";

  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
    required double ntrp,
    required int age,
    required String gender,
  }) async {
    print(json.encode({
      'email': email,
      'name': name,
      'password': password,
      'ntrp': ntrp,
      'age': age,
      'gender': gender,
    }));
    var url = Uri.parse('$_baseUrl/api/user/register');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'name': name,
        'password': password,
        'ntrp': ntrp,
        'age': age,
        'gender': gender,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$_baseUrl/api/user/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('sessionCookie', response.headers['set-cookie']!);
    }
    return json.decode(response.body);
  }

  // Method to check if the user is logged in
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    // Consider user as logged in if there is a token and it's not empty
    return token != null && token.isNotEmpty;
  }
}
