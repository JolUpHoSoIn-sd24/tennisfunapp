import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CourtService {
  final String _baseUrl = "https://tennisfun-rrrlqvarua-du.a.run.app/";

  Future<List<Map<String, dynamic>>?> fetchReservations(String courtId) async {
    var url = Uri.parse('$_baseUrl/api/business/courts/reservations?courtId=$courtId');
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
        return List<Map<String, dynamic>>.from(jsonResponse['result']);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  Future<List<Map<String, dynamic>>?> fetchPendingReservations(String courtId) async {
    var url = Uri.parse('$_baseUrl/api/business/courts/reservations/pending?courtId=$courtId');
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
        return List<Map<String, dynamic>>.from(jsonResponse['result']);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load pending reservations');
    }
  }

  Future<String> _getSessionCookie() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionCookie') ?? '';
  }
}
