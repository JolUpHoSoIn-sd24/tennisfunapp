import 'package:http/http.dart' as http;
import 'dart:convert';

class GeocodingService {
  final String _apiKey = 'AIzaSyDXJGzhrCSMvpuFGIogSB-SBEsMKWbtaIM'; // 여기에 API 키를 입력하세요

  Future<Map<String, dynamic>> getCoordinates(String address) async {
    final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_apiKey');

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'OK') {
        final location = jsonResponse['results'][0]['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      } else {
        throw Exception('Failed to get coordinates: ${jsonResponse['status']}');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }
}
