import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessService {
  final String _baseUrl = "https://tennisfun-rrrlqvarua-du.a.run.app/";

  Future<Map<String, dynamic>?> fetchBusinessInfo() async {
    var url = Uri.parse('$_baseUrl/api/business');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': await _getSessionCookie(),
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse['isSuccess'] == true) {
        return jsonResponse['result'];
      } else {
        throw Exception('Failed to load business info: ${jsonResponse['message']}');
      }
    } else {
      String responseBody = utf8.decode(response.bodyBytes);
      throw Exception('Failed to load business info: $responseBody');
    }
  }

  Future<Map<String, dynamic>> fetchCourtSettlementInfo(String courtId) async {
    var url = Uri.parse('$_baseUrl/api/business/sales?courtId=$courtId');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': await _getSessionCookie(),
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse['isSuccess'] == true) {
        return jsonResponse['result'];
      } else {
        throw Exception('Failed to load court settlement info: ${jsonResponse['message']}');
      }
    } else {
      String responseBody = utf8.decode(response.bodyBytes);
      throw Exception('Failed to load court settlement info: $responseBody');
    }
  }

  Future<Map<String, dynamic>> registerBusiness(Map<String, dynamic> requestBody) async {
    var url = Uri.parse('$_baseUrl/api/business/register');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    String responseBody = utf8.decode(response.bodyBytes);
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['isSuccess'] == true) {
        return jsonResponse;
      } else {
        throw Exception('Failed to register business: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to register business: $responseBody');
    }
  }

  Future<String> _getSessionCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie') ?? '';
  }
}
