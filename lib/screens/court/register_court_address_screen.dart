import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/geocoding_service.dart';

class RegisterCourtAddressScreen extends StatefulWidget {
  @override
  _RegisterCourtAddressScreenState createState() => _RegisterCourtAddressScreenState();
}

class _RegisterCourtAddressScreenState extends State<RegisterCourtAddressScreen> {
  final TextEditingController _courtAddressController = TextEditingController();
  final GeocodingService _geocodingService = GeocodingService();
  double? _latitude;
  double? _longitude;
  String? _errorMessage;

  @override
  void dispose() {
    _courtAddressController.dispose();
    super.dispose();
  }

  void _searchAddress() async {
    final address = _courtAddressController.text;

    if (address.isEmpty) {
      setState(() {
        _errorMessage = '주소를 입력해주세요.';
      });
      return;
    }

    try {
      final coordinates = await _geocodingService.getCoordinates(address);
      setState(() {
        _latitude = coordinates['latitude'];
        _longitude = coordinates['longitude'];
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '좌표를 가져오지 못했습니다: $e';
      });
    }
  }

  void _confirmLocation() {
    if (_latitude != null && _longitude != null) {
      Navigator.pushNamed(
        context,
        '/businessSignUp',
        arguments: {'latitude': _latitude, 'longitude': _longitude},
      );
    } else {
      setState(() {
        _errorMessage = '좌표를 확인해주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테니스장 등록'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/businessSignUp', (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '테니스장 주소를 입력해주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _courtAddressController,
              decoration: InputDecoration(
                labelText: '테니스장 주소',
                hintText: '테니스장 주소를 입력해주세요',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _searchAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF464EFF), // 버튼 색상
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '검색하기',
                  style: TextStyle(fontSize: 16, color: Colors.white), // 글씨 색상 흰색으로 변경
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_latitude != null && _longitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  '위도: $_latitude, 경도: $_longitude',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF464EFF), // 버튼 색상
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
