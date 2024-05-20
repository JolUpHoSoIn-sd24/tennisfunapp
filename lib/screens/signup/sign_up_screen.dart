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

  final AuthService _authService = AuthService();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var response = await _authService.register(
        email: email,
        name: name,
        password: password,
        ntrp: ntrp,
        age: age,
        gender: gender,
      );
      if (response['isSuccess']) {
        Navigator.pushNamed(context, '/signupSuccess');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              onSaved: (value) => email = value!,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              onSaved: (value) => password = value!,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              onSaved: (value) => name = value!,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Slider(
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
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (value) => age = int.parse(value!),
              decoration: InputDecoration(labelText: 'Age'),
            ),
            DropdownButtonFormField<String>(
              value: gender,
              onChanged: (String? newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
              items: <String>['MALE', 'FEMALE', 'OTHER']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
