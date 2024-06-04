import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/court_card.dart';

class CourtsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/ball.png', // ball.png 이미지 경로
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('카일네 테니스장', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('서울시 압구정 남부순환로30길 8 1층'),
                        SizedBox(height: 8),
                        Text('24시간 운영 | 주차 가능', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              CourtCard(courtName: '코트 1'),
              CourtCard(courtName: '코트 2'),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
