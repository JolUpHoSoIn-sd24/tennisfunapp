import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
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
    var url = Uri.parse('http://localhost:8080/api/user/register');
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
}
