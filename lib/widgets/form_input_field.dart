import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final void Function(String?) onSave;
  final bool isPassword;

  FormInputField({
    required this.label,
    required this.onSave,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: onSave,
      ),
    );
  }
}
