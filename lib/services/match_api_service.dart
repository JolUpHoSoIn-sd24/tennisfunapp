import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<bool> fetchMatchRequestStatus() async {
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
      if (response.statusCode == 200) {
        return false; // 예를 들어 API가 특정 조건을 충족하는 경우
      } else {
        return true; // 오류 상태 또는 다른 조건
      }
    } catch (e) {
      // 네트워크 오류 등의 예외 처리
      return true;
    }
  }
}
