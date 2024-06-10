import 'package:flutter/material.dart';
import 'package:tennisfunapp/models/candidate_model.dart';

class PromptCard extends StatelessWidget {
  final CandidateModel candidate;
  final VoidCallback? onMatchRequest;
  final IconData? icon;

  const PromptCard({
    Key? key,
    required this.candidate,
    this.onMatchRequest,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 40),
            SizedBox(height: 20),
            Text(
              candidate.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(candidate.skillLevel),
            if (onMatchRequest != null) ...[
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: onMatchRequest,
                child: Text('매칭을 요청하거나 수정하세요.'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
