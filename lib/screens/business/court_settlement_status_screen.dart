import 'package:flutter/material.dart';
import '../../services/business_service.dart'; // 경로를 실제 프로젝트에 맞게 변경하세요

class CourtSettlementStatusScreen extends StatefulWidget {
  final String courtId;
  final String courtName;

  CourtSettlementStatusScreen({required this.courtId, required this.courtName});

  @override
  _CourtSettlementStatusScreenState createState() => _CourtSettlementStatusScreenState();
}

class _CourtSettlementStatusScreenState extends State<CourtSettlementStatusScreen> {
  final BusinessService _businessService = BusinessService();
  Map<String, dynamic>? courtSettlementInfo;

  @override
  void initState() {
    super.initState();
    _fetchCourtSettlementInfo();
  }

  Future<void> _fetchCourtSettlementInfo() async {
    try {
      final data = await _businessService.fetchCourtSettlementInfo(widget.courtId);
      setState(() {
        courtSettlementInfo = data;
      });
    } catch (e) {
      print('Failed to load court settlement info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코트별 매출 현황'),
      ),
      body: courtSettlementInfo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text('총 매출 (${widget.courtName})', style: TextStyle(fontSize: 18)),
                  Text('${courtSettlementInfo!['totalSales']}원', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: courtSettlementInfo!['saleCustomerDtos'].length,
                itemBuilder: (context, index) {
                  final sale = courtSettlementInfo!['saleCustomerDtos'][index];
                  return Card(
                    child: ListTile(
                      title: Text('예약자 이름: ${sale['userName'].join(', ')}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('예약 일자: ${_formatDate(sale['reservationDate'])}'),
                          Text('예약 시간: ${_formatTime(sale['reservationDate'])}'),
                          Text('총 금액: ${sale['totalPrice'].toInt()}원', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // 세부현황 기능을 구현하세요
                        },
                        child: Text('세부현황'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return '${parsedDate.year}년 ${parsedDate.month.toString().padLeft(2, '0')}월 ${parsedDate.day.toString().padLeft(2, '0')}일';
  }

  String _formatTime(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return '16:00-18:00'; // 예약 시간이 고정되어 있는 경우 이 부분을 조정 필요
  }
}
