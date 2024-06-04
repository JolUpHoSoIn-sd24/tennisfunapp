import 'package:flutter/material.dart';

import 'court_reservation_detail_screen.dart';

class CourtReservationScreen extends StatelessWidget {
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
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                _buildReservationCard(context, 'No.1', '김길동', '2023년 3월 4일', '16:00~18:00'),
                _buildReservationCard(context, 'No.2', '김길동', '2023년 3월 4일', '16:00~18:00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, String courtNo, String reserverName, String date, String time) {
    return Card(
      child: ListTile(
        leading: Image.asset('assets/images/ball.png', width: 50, height: 50), // 이미지 경로를 적절히 수정하세요
        title: Text('코트 $courtNo'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('예약자 이름: $reserverName'),
            Text('예약 일자: $date'),
            Text('예약 시간: $time'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourtReservationDetailScreen()),
            );
          },
          child: Text('세부내용'),
        ),
      ),
    );
  }
}
