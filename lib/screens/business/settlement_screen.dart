import 'package:flutter/material.dart';

class SettlementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정산하기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: ListTile(
                  leading: Image.asset('assets/images/ball.png'),
                  title: Text('카일이네 테니스장'),
                  subtitle: Text('서울시 압구정 남부순환로 30길 8 1층\n24시간 운영 | 주차 가능'),
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: Text('코트 1'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('정산현황'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: Text('코트 2'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('정산현황'),
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
