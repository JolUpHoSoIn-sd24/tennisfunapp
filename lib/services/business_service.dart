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
        return null; // null 반환
      }
    } else {
      throw Exception('Failed to load business info');
    }
  }

  Future<Map<String, dynamic>?> fetchCourtReservations() async {
    var url = Uri.parse('$_baseUrl/api/business/courts/reservations');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': await _getSessionCookie(),
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonResponse['isSuccess'] == true && jsonResponse['result'] is List) {
        return {
          'result': jsonResponse['result']
        };
      } else {
        return null; // null 반환
      }
    } else {
      throw Exception('Failed to load court reservations');
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
        throw Exception('Failed to load court settlement info');
      }
    } else {
      throw Exception('Failed to load court settlement info');
    }
  }

  Future<String> _getSessionCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie') ?? '';
  }
}
