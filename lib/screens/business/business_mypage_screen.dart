import 'package:flutter/material.dart';

class BusinessMyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  leading: Image.asset('assets/images/ball.png'),
                  title: Text('카일이네 테니스장'),
                  subtitle: Text('서울시 압구정 남부순환로 30길 8 1층\n24시간 운영 | 주차 가능'),
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
