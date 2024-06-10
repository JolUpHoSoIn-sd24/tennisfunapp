import 'package:flutter/material.dart';
import 'package:tennisfunapp/screens/signup/business_sign_up_screen.dart';

class AccountTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '계정 유형을 선택해주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40), // 적당한 간격 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AccountTypeButton(
                  label: '일반 사용자',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                ),
                SizedBox(width: 20),
                AccountTypeButton(
                  label: '테니스 사업자',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/businessSignUp');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccountTypeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  AccountTypeButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF464EFF), // 버튼 색상을 파란색으로 설정
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xFF464EFF)), // 버튼 테두리를 파란색으로 설정
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.white), // 글자 색상을 흰색으로 설정
      ),
    );
  }
}
