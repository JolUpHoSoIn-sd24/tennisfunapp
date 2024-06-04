import 'package:flutter/material.dart';
import '../../services/business_service.dart';
import 'court_reservation_detail_screen.dart';

class CourtReservationScreen extends StatefulWidget {
  @override
  _CourtReservationScreenState createState() => _CourtReservationScreenState();
}

class _CourtReservationScreenState extends State<CourtReservationScreen> {
  final BusinessService _businessService = BusinessService();
  List<Map<String, dynamic>> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    try {
      var result = await _businessService.fetchCourtReservations();
      if (result != null && result['result'] is List) {
        setState(() {
          _reservations = List<Map<String, dynamic>>.from(result['result'].map((item) => item as Map<String, dynamic>)); // 서버에서 받아온 예약 데이터를 사용합니다.
          _isLoading = false;
        });
      }
    } catch (e) {
      // 에러 처리
      print('Failed to load reservations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코트별 예약 현황'),
        leading: BackButton(),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {},
                child: Text('예약'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('가예약'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // 버튼 색상을 회색으로 변경
                ),
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                var reservation = _reservations[index];
                var courtName = reservation['courtName'];
                var userName = reservation['simpleCustomerDto']['userName'].join(', ');
                var reservationDate = reservation['simpleCustomerDto']['reservationDate'];
                return _buildReservationCard(
                  context,
                  courtName,
                  userName,
                  reservationDate,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, String courtName, String reserverNames, String reservationDate) {
    DateTime parsedDate = DateTime.parse(reservationDate);
    String formattedDate = "${parsedDate.toLocal().year}년 ${parsedDate.toLocal().month}월 ${parsedDate.toLocal().day}일";
    String formattedTime = "${parsedDate.toLocal().hour.toString().padLeft(2, '0')}:${parsedDate.toLocal().minute.toString().padLeft(2, '0')}";

    return Card(
      child: ListTile(
        leading: Image.asset('assets/images/ball.png', width: 50, height: 50), // 이미지 경로를 적절히 수정하세요
        title: Text(
          courtName,
          style: TextStyle(fontSize: 16), // 글씨 크기 조정
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '예약자 이름: $reserverNames',
              style: TextStyle(fontSize: 14), // 글씨 크기 조정
            ),
            Text(
              '예약 일자: $formattedDate',
              style: TextStyle(fontSize: 14), // 글씨 크기 조정
            ),
            Text(
              '예약 시간: $formattedTime',
              style: TextStyle(fontSize: 14), // 글씨 크기 조정
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourtReservationDetailScreen()),
            );
          },
          child: Text(
            '세부내용',
            style: TextStyle(fontSize: 7), // 글씨 크기 조정
          ),
        ),
      ),
    );
  }
}
