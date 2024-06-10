import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackApiService {
  // final String _baseUrl = 'http://example.com/api';
  String _baseUrl = "https://tennisfun-rrrlqvarua-du.a.run.app";

  Future<Map<String, dynamic>> submitFeedback(
      Map<String, dynamic> feedback) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');
      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Cookie': sessionCookie!,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/api/game/feedback'),
        headers: headers,
        body: jsonEncode(feedback),
      );

      print("Request URL: $_baseUrl/api/game/feedback");
      print("Response: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'isSuccess': false,
          'message': 'Failed to submit feedback',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
