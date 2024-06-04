import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  double ntrp = 2.0; // Default NTRP value
  int age = 20; // Default age
  String gender = 'MALE'; // Default gender

  bool _isFocused = false;
  final AuthService _authService = AuthService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var response = await _authService.register(
          email: email,
          name: name,
          password: password,
          ntrp: ntrp,
          age: age,
          gender: gender,
        );

        // Add a null check on response and isSuccess
        if (response != null && response['isSuccess'] == true) {
          print("SUCCESS");
          Navigator.pushNamed(context, '/signupSuccess');
        } else {
          // Handle the case where isSuccess is not true or response is null
          String message = response?['message'] ?? 'Unknown error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        // Catch any other exceptions that might occur during the registration process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralUserSignUpAppBar(),
      body: ListView(
        children: [
          FullWidthThinBox(),
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FormFieldLabel('이메일'),
                  const SizedBox(height: 5),
                  EmailFormField_signup(),
                  const SizedBox(height: 20),
                  FormFieldLabel('비밀번호'),
                  const SizedBox(height: 5),
                  PasswordFormField_signup(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FormFieldLabel('이름'),
                      const SizedBox(width: 164),
                      FormFieldLabel('성별'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Expanded(
                        child: NameFormField_signup(),
                      ),
                      const SizedBox(width: 35),
                      Expanded(
                        child: GenderDropdownButton_signup(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FormFieldLabel('NTRP'),
                  NtrpSlider_singup(),
                  FormFieldLabel('나이'),
                  const SizedBox(height: 5),
                  AgeFormField_signup(),
                  const SizedBox(height: 70),
                  RegisterButton_signup(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row FormFieldLabel(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Label(label),
        ),
      ],
    );
  }

  Text Label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: -0.10,
      ),
    );
  }

  SizedBox FullWidthThinBox() {
    return SizedBox(
        width: double.infinity, // 화면 너비를 꽉 채웁니다.
        height: 5, // 얇은 높이 (원하는 값으로 조절 가능)
        child: Container(
          color: const Color(0xFFEDEDED),
        ));
  }

  Container RegisterButton_signup() {
    return Container(
        child: Center(
            child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(315, 30),
          backgroundColor: Color(0xFF464EFF),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFF464EFF)),
              borderRadius: BorderRadius.circular(20))),
      onPressed: _submitForm,
      child: Text('가입하기',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.10,
          )),
    )));
  }

  DropdownButtonFormField<String> GenderDropdownButton_signup() {
    return DropdownButtonFormField<String>(
      value: gender,
      onChanged: (String? newValue) {
        setState(() {
          gender = newValue!;
        });
      },
      items: <String>['MALE', 'FEMALE']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Gender',
      ),
    );
  }

  Container AgeFormField_signup() {
    return Container(
        width: 340,
        height: 30,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFD3D3D3)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Color(0xFF919191),
            fontSize: 10,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: -0.08,
          ),
          textAlignVertical: TextAlignVertical(y: 1.0),
          // 포커스를 받았을 때 상태 업데이트
          onTap: () {
            setState(() {
              _isFocused = true;
            });
          },
          // 포커스를 잃었을 때 상태 업데이트
          onFieldSubmitted: (value) {
            setState(() {
              _isFocused = false;
            });
          },

          onSaved: (value) => age = int.parse(value!),
          decoration: InputDecoration(
              hintText: '나이를 입력해주세요',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Color(0xFF464EFF))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red))),
          validator: (value) => value!.isEmpty ? 'Please enter your age' : null,
        ));
  }

  Slider NtrpSlider_singup() {
    return Slider(
      activeColor: Color(0xFF464EFF),
      inactiveColor: Color(0xFFEDEDED),
      value: ntrp,
      min: 1.0,
      max: 7.0,
      divisions: 12,
      label: ntrp.toStringAsFixed(1),
      onChanged: (double value) {
        setState(() {
          ntrp = value;
        });
      },
    );
  }

  Container NameFormField_signup() {
    return Container(
        width: 160,
        height: 30,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFD3D3D3)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: TextFormField(
          style: TextStyle(
            color: Color(0xFF919191),
            fontSize: 10,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: -0.08,
          ),
          textAlignVertical: TextAlignVertical(y: 1.0),
          // 포커스를 받았을 때 상태 업데이트
          onTap: () {
            setState(() {
              _isFocused = true;
            });
          },
          // 포커스를 잃었을 때 상태 업데이트
          onFieldSubmitted: (value) {
            setState(() {
              _isFocused = false;
            });
          },

          onSaved: (value) => name = value!,
          decoration: InputDecoration(
              hintText: '이름을 입력해주세요',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Color(0xFF464EFF))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red))),
          validator: (value) =>
              value!.isEmpty ? 'Please enter your name' : null,
        ));
  }

  Container PasswordFormField_signup() {
    return Container(
        width: 340,
        height: 30,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFD3D3D3)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: TextFormField(
          style: TextStyle(
            color: Color(0xFF919191),
            fontSize: 10,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: -0.08,
          ),
          textAlignVertical: TextAlignVertical(y: 1.0),
          // 포커스를 받았을 때 상태 업데이트
          onTap: () {
            setState(() {
              _isFocused = true;
            });
          },
          // 포커스를 잃었을 때 상태 업데이트
          onFieldSubmitted: (value) {
            setState(() {
              _isFocused = false;
            });
          },
          onSaved: (value) => password = value!,
          decoration: InputDecoration(
              hintText: '비밀번호를 입력해주세요',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Color(0xFF464EFF))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red))),
          obscureText: true,
          validator: (value) => value!.length < 8
              ? 'Password must be at least 8 characters'
              : null,
        ));
  }

  Container EmailFormField_signup() {
    return Container(
      width: 340,
      height: 30,
      child: TextFormField(
        style: TextStyle(
          color: Color(0xFF919191),
          fontSize: 10,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          height: 1.0,
          letterSpacing: -0.08,
        ),
        textAlignVertical: TextAlignVertical(y: 1.0),
        onSaved: (value) => email = value!,
        decoration: InputDecoration(
            hintText: '이메일을 입력해주세요',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Color(0xFF464EFF))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.red))),
        validator: (value) => value!.isEmpty || !value.contains('@')
            ? 'Enter a valid email'
            : null,
      ),
    );
  }

  AppBar GeneralUserSignUpAppBar() {
    return AppBar(
      title: Text(
        '회원가입',
        style: TextStyle(
          color: Color(0xFF222222),
          fontSize: 18,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 1.0,
          letterSpacing: -0.14,
        ),
      ),
      centerTitle: true,
    );
  }
}
