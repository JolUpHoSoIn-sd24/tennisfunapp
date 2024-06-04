import 'package:flutter/material.dart';
import '../../services/business_service.dart'; // 경로를 실제 프로젝트에 맞게 변경하세요

class CourtsScreen extends StatefulWidget {
  @override
  _CourtsScreenState createState() => _CourtsScreenState();
}

class _CourtsScreenState extends State<CourtsScreen> {
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
        title: Text('코트 정보'),
      ),
      body: businessInfo == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/ball.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              businessInfo!['shopName'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(businessInfo!['address']),
                            SizedBox(height: 8),
                            Text('24시간 운영 | 주차 가능',
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ...businessInfo!['courtInfo'].map<Widget>((court) {
                    return CourtCard(
                      courtName: court['courtName'],
                      description: court['description'],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 예약 추가 기능을 구현하세요
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CourtCard extends StatelessWidget {
  final String courtName;
  final String description;

  const CourtCard({
    required this.courtName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // leading: Image.asset('assets/images/ball.png', width: 50, height: 50), // 이미지 경로를 적절히 수정하세요
        title: Text(
          courtName,
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis, // 이름이 잘리지 않도록
        ),
        // subtitle: Text(description),
        trailing: Container(
          width: 120, // 버튼들이 잘리지 않도록 컨테이너에 고정된 너비를 설정
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    // 수정하기 기능을 구현하세요
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // 수정하기 버튼 색상
                    textStyle: TextStyle(fontSize: 12), // 글씨 크기 조정
                    minimumSize: Size(50, 36), // 최소 사이즈 설정
                    padding: EdgeInsets.all(0), // 패딩 조정
                  ),
                  child: FittedBox(
                    child: Text('수정하기'),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    // 예약현황 기능을 구현하세요
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 12), // 글씨 크기 조정
                    minimumSize: Size(50, 36), // 최소 사이즈 설정
                    padding: EdgeInsets.all(0), // 패딩 조정
                  ),
                  child: FittedBox(
                    child: Text('예약현황'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
