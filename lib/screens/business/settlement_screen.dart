import 'package:flutter/material.dart';
import '../../services/business_service.dart';
import 'court_settlement_status_screen.dart'; // 경로를 실제 프로젝트에 맞게 변경하세요

class SettlementScreen extends StatefulWidget {
  @override
  _SettlementScreenState createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
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

  void _navigateToCourtSettlement(BuildContext context, String courtId, String courtName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourtSettlementStatusScreen(courtId: courtId, courtName: courtName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('매출 조회'),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(businessInfo!['address']),
                      SizedBox(height: 8),
                      Text('24시간 운영 | 주차 가능', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ...businessInfo!['courtInfo'].map<Widget>((court) {
                return ListTile(
                  title: Text(court['courtName']),
                  trailing: ElevatedButton(
                    onPressed: () => _navigateToCourtSettlement(context, court['courtId'], court['courtName']),
                    child: Text('매출현황'),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
