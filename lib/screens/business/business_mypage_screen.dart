import 'package:flutter/material.dart';
import '../../services/business_service.dart'; // 경로를 실제 프로젝트에 맞게 변경하세요

class BusinessMyPageScreen extends StatefulWidget {
  @override
  _BusinessMyPageScreenState createState() => _BusinessMyPageScreenState();
}

class _BusinessMyPageScreenState extends State<BusinessMyPageScreen> {
  final BusinessService _businessService = BusinessService();
  Map<String, dynamic>? businessInfo;

  @override
  void initState() {
    super.initState();
    _fetchBusinessInfo();
  }

  Future<void> _fetchBusinessInfo() async {
    try {
      final data = await _businessService.fetchBusinessInfo();
      setState(() {
        businessInfo = data;
      });
    } catch (e) {
      print('Failed to load business info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: businessInfo == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  leading: Image.asset('assets/images/ball.png'),
                  title: Text(
                    businessInfo!['shopName'],
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(businessInfo!['address']),
                      SizedBox(height: 8),
                      Text('24시간 운영 | 주차 가능',
                          style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('계정 정보 수정'),
                onTap: () {},
              ),
              ListTile(
                title: Text('테니스 재미쓰 이용 약관'),
                onTap: () {},
              ),
              ListTile(
                title: Text('테니스 재미쓰 개인정보처리방침'),
                onTap: () {},
              ),
              ListTile(
                title: Text('테니스 재미쓰 고객센터'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
