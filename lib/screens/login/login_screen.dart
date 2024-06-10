import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isBusinessUser = false; // 추가: 비즈니스 회원 체크 여부
  bool _isFocused = false;

  void _tryLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var result;
      if (_isBusinessUser) {
        result = await AuthService()
            .businessLogin(email: _email, password: _password);
      } else {
        result = await AuthService().login(email: _email, password: _password);
      }

      if (result['isSuccess']) {
        if (_isBusinessUser) {
          Navigator.pushReplacementNamed(context, '/business/home');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("로그인 실패, 이메일 인증 혹은 비밀번호를 확인해주세요.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const LogoImage(),
                const SizedBox(height: 55),
                EmailFormField(),
                const SizedBox(height: 15),
                PasswordFormField(),
                BusinessUserCheckbox(), // 추가: 비즈니스 회원 체크박스
                //EmailFindAndPasswordFind(context),
                const SizedBox(height: 54),
                LoginButton(),
                const SizedBox(height: 10),
                SignupButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container BusinessUserCheckbox() {
    return Container(
      width: 260,
      child: Row(
        children: [
          Checkbox(
            value: _isBusinessUser,
            onChanged: (value) {
              setState(() {
                _isBusinessUser = value!;
              });
            },
          ),
          Text(
            "사업자 회원",
            style: TextStyle(
              color: Color(0xFF646464),
              fontSize: 12.5,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Container SignupButton(BuildContext context) {
    return Container(
      height: 40,
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF464EFF)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/accountTypeSelection');
        },
        child: Text(
          '회원가입',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF464EFF),
            fontSize: 12.5,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.10,
          ),
        ),
      ),
    );
  }

  Container LoginButton() {
    return Container(
      height: 40,
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF464EFF),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF464EFF)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: _tryLogin,
        child: Text(
          '로그인',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.10,
          ),
        ),
      ),
    );
  }

  Container PasswordFormField() {
    return Container(
      width: 260,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(
              color: Color(0xFF646464),
              fontSize: 12.5,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.3,
              letterSpacing: -0.10,
            ),
            textAlignVertical: TextAlignVertical(y: 1.0),
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: _isFocused ? Colors.white : Color(0xFFEDEDED),
              hintText: '비밀번호',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFFEDEDED)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red),
              ),
              errorMaxLines: 2, // 에러 메시지를 한 줄로 제한
            ),
            validator: (value) {
              String pattern =
                  r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,}$';
              RegExp regex = RegExp(pattern);
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요.';
              } else if (!regex.hasMatch(value)) {
                return '비밀번호는 8자 이상, 대문자, 소문자, 숫자, 특수문자(@#\$%^&+=)를 포함해야 합니다.';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
        ],
      ),
    );
  }

  Container EmailFormField() {
    return Container(
      width: 260,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(
              color: Color(0xFF646464),
              fontSize: 12.5,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.3,
              letterSpacing: -0.10,
            ),
            textAlignVertical: TextAlignVertical(y: 1.0),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: _isFocused ? Colors.white : Color(0xFFEDEDED),
              hintText: '이메일을 입력해주세요',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFFEDEDED)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red),
              ),
              errorMaxLines: 1, // 에러 메시지를 한 줄로 제한
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력해주세요.';
              } else if (!value.contains('@')) {
                return '이메일 형식이 올바르지 않습니다.';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
        ],
      ),
    );
  }
}

class LogoImage extends StatelessWidget {
  const LogoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/tennis.main.logo.svg',
      width: 96,
      height: 198,
    );
  }
}

Padding EmailFindAndPasswordFind(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
    child: Row(
      children: [
        // 아이디 찾기
        TextButton(
          onPressed: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => FindID()));
          },
          child: Text(
            "아이디 찾기",
            style: TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              height: 0,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => FindPassword()));
          },
          child: Text(
            "비밀번호 찾기",
            style: TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              height: 0,
            ),
          ),
        )
      ],
    ),
  );
}
