import 'package:flutter/material.dart';
import 'package:tennisfunapp/models/candidate_model.dart';

class CandidateCard extends StatelessWidget {
  final CandidateModel candidate;

  const CandidateCard({Key? key, required this.candidate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(candidate.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('Skill Level: ${candidate.skillLevel}',
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
