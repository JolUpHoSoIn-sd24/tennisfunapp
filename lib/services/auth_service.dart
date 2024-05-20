import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String _baseUrl = "http://localhost:8080";
  String _sessionCookies = '';

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

    if (response.statusCode == 201) {
      try {
        return json.decode(response.body);
      } catch (e) {
        print('JSON Decode Error: $e');
        throw FormatException('Failed to decode response: $e');
      }
    } else {
      return {'isSuccess': false, 'message': 'Failed to register'};
    }
  }

  // Login method
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

    // Check the response status and parse the body
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['isSuccess']) {
        // If login is successful, save the session cookies (if any)
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Assuming the token is saved as a cookie
        if (response.headers['set-cookie'] != null) {
          prefs.setString('sessionCookie', response.headers['set-cookie']!);
        }
        return {'isSuccess': true, 'message': data['message']};
      } else {
        // Handle cases where login is successful but the session creation fails
        return {
          'isSuccess': false,
          'message':
              data['message'] ?? 'Login successful but session not created'
        };
      }
    } else {
      // Handle errors
      var data = json.decode(response.body);
      return {
        'isSuccess': false,
        'message': data['message'] ?? 'Unknown error'
      };
    }
  }

  // Method to check if the user is logged in
  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    // Consider user as logged in if there is a token and it's not empty
    return token != null && token.isNotEmpty;
  }
}
