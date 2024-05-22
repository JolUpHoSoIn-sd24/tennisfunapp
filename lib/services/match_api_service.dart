import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennisfunapp/const/base_url.dart';

class MatchApiService {
  final String _baseUrl = BaseUrl.baseUrl;

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
}
