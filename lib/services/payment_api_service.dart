import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentApiService {
  //final String _baseUrl = "http://localhost:8080";
  final String _baseUrl = "https://tennisfun-rrrlqvarua-du.a.run.app";

  // Initiate payment and return the redirect URL for the payment gateway
  Future<String?> initiatePayment() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie = prefs.getString('sessionCookie');
      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Cookie': sessionCookie!,
      };

      final response =
          await http.get(Uri.parse('$_baseUrl/api/payment'), headers: headers);

      print("initiatePayment Request URL: $_baseUrl/api/payment");
      print("Response: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isSuccess']) {
          return data['result']['next_redirect_mobile_url'];
        }
      }
      return null;
    } catch (e) {
      print("Error initiating payment: $e");
      return null;
    }
  }
}
