import 'package:flutter/material.dart';

class CourtReservationDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코트별 예약 현황'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('예약 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildReservationDetailRow('사용자 이름', '김혜동'),
            _buildReservationDetailRow('전화 번호', '010-0000-0000'),
            _buildReservationDetailRow('이용 시간', '2023년 3월 4일 12:00~14:00'),
            _buildReservationDetailRow('단 복식 여부', '단식'),
            SizedBox(height: 20),
            Text('예약 코트 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildReservationDetailRow('코트 이름', '카일이네 테니스장'),
            _buildReservationDetailRow('코트 타입', '잔디, 클레이'),
            _buildReservationDetailRow('이용 가능 시간', '12:00~14:00'),
            _buildReservationDetailRow('한줄 소개', '한 판 치기 딱 좋은 곳'),
            _buildReservationDetailRow('시간 당 비용', '99,999원'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('예약 취소'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('확인'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16)),
          Text(content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
