import 'package:flutter/material.dart';
import '../../components/court_card.dart';
import '../../services/business_service.dart';
import 'court_reservation_screen.dart'; // 경로를 실제 프로젝트에 맞게 변경하세요

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

  void _navigateToCourtReservation(BuildContext context, String courtId, String courtName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourtReservationScreen(courtId: courtId, courtName: courtName),
      ),
    );
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
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(businessInfo!['address']),
                            SizedBox(height: 8),
                            Text('24시간 운영 | 주차 가능', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ...businessInfo!['courtInfo'].map<Widget>((court) {
                    return CourtCard(
                      courtName: court['courtName'],
                      onTap: () => _navigateToCourtReservation(context, court['courtId'], court['courtName']),
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
