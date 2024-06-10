import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/business_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessSignUpScreen extends StatefulWidget {
  @override
  _BusinessSignUpScreenState createState() => _BusinessSignUpScreenState();
}

class _BusinessSignUpScreenState extends State<BusinessSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _businessNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final BusinessService _businessService = BusinessService();
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _birthdateController.dispose();
    _businessNumberController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '아이디를 입력해주세요.';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '유효한 이메일 주소를 입력해주세요.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    String pattern = r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,}$';
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (!RegExp(pattern).hasMatch(value)) {
      return '비밀번호는 최소 8자 이상이어야 하며, 대문자, 소문자, 숫자, 특수문자(@#\$%^&+=)를 포함해야 합니다. 공백은 허용되지 않습니다.';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> requestBody = {
        "emailId": _emailController.text,
        "password": _passwordController.text,
        "name": _nameController.text,
        "birthDate": _birthdateController.text,
        "businessRegistrationNumber": _businessNumberController.text,
        "bank": _bankNameController.text,
        "accountNumber": _accountNumberController.text,
        "documentUrls": ["https://example.com/document1.pdf", "https://example.com/document2.pdf"],
        "shopName": "MyShop", // 이 부분은 실제로 입력 받거나 다른 방법으로 처리
        "location": {
          "x": _longitude,
          "y": _latitude
        }
      };

      try {
        var response = await _businessService.registerBusiness(requestBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      _latitude = arguments['latitude'];
      _longitude = arguments['longitude'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('테니스장 사업자 회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/accountTypeSelection');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  hintText: 'tennis@fun.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호는 여기에 써 주세요.',
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  hintText: '비밀번호를 다시 입력해주세요.',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 다시 입력해주세요.';
                  }
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: '이름을 입력해주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: '생년월일',
                  hintText: 'YYYY-MM-DD',
                ),
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '생년월일을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '테니스장 등록',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registerCourtAddress');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF464EFF), // 버튼 색상
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '테니스장 등록하기',
                      style: TextStyle(fontSize: 16, color: Colors.white), // 글씨 색상 흰색으로 변경
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _businessNumberController,
                decoration: InputDecoration(
                  labelText: '사업자 등록 번호',
                  hintText: '123-45-6789 형식으로 입력해주세요. (모범)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '사업자 등록 번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(
                  labelText: '은행 이름',
                  hintText: '은행 이름을 입력해주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '은행 이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: '계좌번호',
                  hintText: '계좌번호를 입력해주세요.',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '계좌번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF464EFF), // 버튼 색상
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '가입하기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
