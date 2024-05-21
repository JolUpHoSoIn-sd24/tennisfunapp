import 'package:flutter/material.dart';
import 'package:tennisfunapp/models/candidate_model.dart';

class PromptCard extends StatelessWidget {
  final CandidateModel candidate;
  final VoidCallback onMatchRequest;

  const PromptCard(
      {Key? key, required this.candidate, required this.onMatchRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              candidate.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(candidate.skillLevel),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: onMatchRequest,
              child: Text('Request Match'),
            )
          ],
        ),
      ),
    );
  }
}
