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
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  onSaved: (value) => email = value!,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                TextFormField(
                  onSaved: (value) => password = value!,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.length < 8
                      ? 'Password must be at least 8 characters'
                      : null,
                ),
                TextFormField(
                  onSaved: (value) => name = value!,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
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
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your age' : null,
                ),
                DropdownButtonFormField<String>(
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
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
