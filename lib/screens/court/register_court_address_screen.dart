import 'package:flutter/material.dart';

class RegisterCourtAddressScreen extends StatefulWidget {
  @override
  _RegisterCourtAddressScreenState createState() => _RegisterCourtAddressScreenState();
}

class _RegisterCourtAddressScreenState extends State<RegisterCourtAddressScreen> {
  final TextEditingController _courtNameController = TextEditingController();
  final TextEditingController _courtAddressController = TextEditingController();

  @override
  void dispose() {
    _courtNameController.dispose();
    _courtAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테니스장 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '테니스장 정보를 입력해주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _courtNameController,
              decoration: InputDecoration(
                labelText: '테니스장 이름',
                hintText: '테니스장 이름을 입력해주세요',
              ),
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
                onPressed: () {
                  // 테니스장 등록 처리
                },
                child: Text('검색하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
