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
  String confirmPassword = ''; // Add confirmPassword field
  String name = '';
  double ntrp = 2.0; // Default NTRP value
  String birthDate = ''; // 생년월일 필드
  String gender = 'MALE'; // Default gender

  bool _isFocused = false;
  bool _isLoading = false; // Add loading state

  final AuthService _authService = AuthService();

  DateTime selectedDate = DateTime.now();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });
      _formKey.currentState!.save();
      birthDate =
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
      try {
        var response = await _authService.register(
          email: email,
          name: name,
          password: password,
          ntrp: ntrp,
          birthDate: birthDate,
          gender: gender,
        );

        if (response != null && response['isSuccess'] == true) {
          print("SUCCESS");
          Navigator.pushNamed(context, '/signupSuccess');
        } else {
          String message = response?['message'] ?? 'Unknown error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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
                  FormFieldLabel('비밀번호 재확인'), // Label for confirm password
                  const SizedBox(height: 5),
                  ConfirmPasswordFormField_signup(), // Field for confirm password
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
                  NtrpSlider_signup(),
                  FormFieldLabel('생년월일'),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: BirthdateFormField_signup(),
                    ),
                  ),
                  const SizedBox(height: 70),
                  if (_isLoading) // Show loading indicator
                    CircularProgressIndicator(),
                  if (!_isLoading) // Show button when not loading
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
        if (label == 'NTRP') // 조건문 추가
          ...[
          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
          Text(
            'NTRP가 무엇인가요?',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          HelpIcon(
            dialogTitle: 'NTRP란?',
            helpText:
                'NTRP(National Tennis Rating Program)는 테니스 실력을 평가하는 척도입니다. 1.0부터 7.0까지 있으며, 숫자가 높을수록 실력이 좋습니다.',
          ),
        ],
        if (label == '비밀번호') // 조건문 추가
          ...[
          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
          Text(
            '비밀번호 형식이 무엇인가요?',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          HelpIcon(
            dialogTitle: '비밀번호 형식',
            helpText:
                '비밀번호는 최소 8자 이상이어야하며, 소문자, 대문자, 숫자, 특수문자(@#\$%^&+=)를 각각 적어도 하나씩 포함해야 합니다.',
          ),
        ],
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
      onPressed: _isLoading ? null : _submitForm, // Disable button when loading
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

  Container BirthdateFormField_signup() {
    return Container(
      width: 340,
      height: 30,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFD3D3D3)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
          style: TextStyle(
            color: Color(0xFF919191),
            fontSize: 10,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: -0.08,
          ),
        ),
      ),
    );
  }

  Slider NtrpSlider_signup() {
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
          validator: (value) => value!.isEmpty ? '이름 형식이 올바르지 않습니다' : null,
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
          onChanged: (value) {
            setState(() {
              password = value;
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호 형식이 올바르지 않습니다.';
            }
            final regex = RegExp(
                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=])[A-Za-z\d@#$%^&+=]{8,}$');
            if (!regex.hasMatch(value)) {
              return '비밀번호 형식이 올바르지 않습니다.';
            }
            return null;
          },
        ));
  }

  Container ConfirmPasswordFormField_signup() {
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
          onChanged: (value) {
            setState(() {
              confirmPassword = value;
            });
          },
          onSaved: (value) => confirmPassword = value!,
          decoration: InputDecoration(
              hintText: '비밀번호를 다시 입력해주세요',
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
          validator: (value) {
            if (confirmPassword == null || confirmPassword.isEmpty) {
              return '비밀번호를 다시 입력해주세요.';
            }
            if (password != confirmPassword) {
              return '비밀번호가 다릅니다. 다시 입력해주세요.';
            }
            return null;
          },
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
            ? '이메일 형식이 올바르지 않습니다.'
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

class HelpIcon extends StatelessWidget {
  final String helpText;
  final String dialogTitle;

  const HelpIcon({
    Key? key,
    required this.helpText,
    required this.dialogTitle, // 추가된 dialogTitle 매개변수
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.help_outline),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(dialogTitle),
            content: Text(helpText),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }
}
