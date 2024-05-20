import 'package:flutter/material.dart';

class GenderNTRPSelector extends StatefulWidget {
  final String initialGender;
  final double initialNTRP;
  final ValueChanged<String> onGenderSelected;
  final ValueChanged<double> onNTRPSelected;

  GenderNTRPSelector({
    required this.initialGender,
    required this.initialNTRP,
    required this.onGenderSelected,
    required this.onNTRPSelected,
  });

  @override
  _GenderNTRPSelectorState createState() => _GenderNTRPSelectorState();
}

class _GenderNTRPSelectorState extends State<GenderNTRPSelector> {
  late String selectedGender;
  late double selectedNTRP;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender;
    selectedNTRP = widget.initialNTRP;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Male'),
          leading: Radio<String>(
            value: 'Male',
            groupValue: selectedGender,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedGender = value;
                  widget.onGenderSelected(value);
                });
              }
            },
          ),
        ),
        ListTile(
          title: const Text('Female'),
          leading: Radio<String>(
            value: 'Female',
            groupValue: selectedGender,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedGender = value;
                  widget.onGenderSelected(value);
                });
              }
            },
          ),
        ),
        DropdownButton<double>(
          value: selectedNTRP,
          onChanged: (double? newValue) {
            if (newValue != null) {
              setState(() {
                selectedNTRP = newValue;
                widget.onNTRPSelected(newValue);
              });
            }
          },
          items: <double>[
            1.0,
            1.5,
            2.0,
            2.5,
            3.0,
            3.5,
            4.0,
            4.5,
            5.0,
            5.5,
            6.0,
            7.0
          ].map<DropdownMenuItem<double>>((double value) {
            return DropdownMenuItem<double>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}
