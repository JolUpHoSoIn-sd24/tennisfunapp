import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennisfunapp/models/game.dart';

class MatchApiService {
  final String _baseUrl = "http://localhost:8080";

  Future<http.Response> createMatchRequest(
      Map<String, dynamic> matchRequestData) async {
    Uri uri = Uri.parse("$_baseUrl/api/match/request");
    String requestBody = jsonEncode(matchRequestData);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('sessionCookie');

    var headers = {
      'Content-Type': 'application/json',
    };
    if (sessionCookie != null) {
      headers['Cookie'] = sessionCookie;
    }

    print("Request URL: $uri");
    print("Request Body: $requestBody");

    var response = await http.post(
      uri,
      headers: headers,
      body: requestBody,
    );

    return response;
  }

  Future<List<dynamic>?> fetchMatchResults() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');
      var headers = <String, String>{};
      if (sessionCookie != null) {
        headers['Cookie'] = sessionCookie;
      }
      final response = await http.get(
        Uri.parse("$_baseUrl/api/match/results"),
        headers: headers,
      );
      print("Request URL: $_baseUrl/api/match/results");
      print("Response: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['isSuccess'] == true) {
          return jsonResponse['result'];
        } else {
          return []; // 빈 배열 반환
        }
      } else {
        return null; // 응답 상태 코드가 200이 아닌 경우 null 반환
      }
    } catch (e) {
      print("Error: $e");
      return null; // 예외 발생 시 null 반환
    }
  }

  Future<bool> fetchMatchRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');
      var headers = <String, String>{};
      if (sessionCookie != null) {
        headers['Cookie'] = sessionCookie;
      }
      final response = await http.get(
        Uri.parse("$_baseUrl/api/match/request"),
        headers: headers,
      );
      print("Request URL: $_baseUrl/api/match/request");
      print("Response: ${response.statusCode}");
      print("Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to fetch match requests');
    }
  }

  Future<bool> submitMatchFeedback(String matchId, String feedback) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');
      var headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (sessionCookie != null) {
        headers['Cookie'] = sessionCookie;
      }

      var requestBody = jsonEncode({
        'feedback': feedback,
      });

      final response = await http.post(
        Uri.parse("$_baseUrl/api/match/results/$matchId/feedback"),
        headers: headers,
        body: requestBody,
      );
      print("Request URL: $_baseUrl/api/match-results/$matchId/feedback");
      print("Request Body: $requestBody");
      print("Response: ${response.statusCode}");
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<Game?> fetchGameDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');

      var headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (sessionCookie != null) {
        headers['Cookie'] = sessionCookie;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/api/game'),
        headers: headers,
      );

      print("Request URL: $_baseUrl/api/game");
      print("Response: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['isSuccess']) {
          return Game.fromJson(jsonResponse['result']);
        }
      }

      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
