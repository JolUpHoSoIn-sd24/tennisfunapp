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
}
