import 'package:flutter/material.dart';
import 'package:tennisfunapp/screens/signup/sign_up_screen.dart';
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

  bool _isFocused = false;

  void _tryLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Use the correct method name and check for the returned structure.
      var result =
          await AuthService().login(email: _email, password: _password);
      if (result['isSuccess']) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            key: _formKey,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const LogoImage(),
              const SizedBox(height: 55),
              EmailFormField(),
              const SizedBox(height: 15),
              PasswordFormField(),
              // const SizedBox(height: 5),
              EmailFindAndPasswordFind(context),
              const SizedBox(height: 54),
              SignupButton(context),
              const SizedBox(height: 10),
              LoginButton(),
            ],
          ),
        ),
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
                  borderRadius: BorderRadius.circular(20))),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text('회원가입',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF464EFF),
                fontSize: 12.5,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.10,
              )),
        ));
  }

  Container LoginButton() {
    return Container(
        height: 40,
        width: 260,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF464EFF),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF464EFF)),
                  borderRadius: BorderRadius.circular(20))),
          onPressed: _tryLogin,
          child: const Text('로그인',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.10,
              )),
        ));
  }

  Container PasswordFormField() {
    return Container(
        width: 260,
        height: 40,
        child: TextFormField(
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
            hintText: '비밀번호를 입력해주세요',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFFEDEDED))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onSaved: (value) => _password = value!,
        ));
  }

  Container EmailFormField() {
    return Container(
        width: 260,
        height: 40,
        child: TextFormField(
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
            hintText: '아이디를 입력해주세요',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFFEDEDED))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: (value) => _email = value!,
        ));
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
      child: Row(children: [
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
            )),
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
            ))
      ]));
}
