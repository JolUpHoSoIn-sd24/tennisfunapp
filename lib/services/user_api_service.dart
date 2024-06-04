import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennisfunapp/models/user.dart';

class UserApiService {
  final String _baseUrl = "https://tennisfun-rrrlqvarua-du.a.run.app";

  Future<User?> fetchUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');
      var headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (sessionCookie != null) {
        headers['Cookie'] = sessionCookie;
      }
      final response =
          await http.get(Uri.parse('$_baseUrl/api/user'), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['isSuccess']) {
          return User.fromJson(jsonResponse['result']);
        }
      }

      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
