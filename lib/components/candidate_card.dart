import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennisfunapp/models/candidate_model.dart';

class CandidateCard extends StatelessWidget {
  final CandidateModel candidate;

  const CandidateCard({Key? key, required this.candidate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final opponent = candidate.opponent;
    final matchDetails = candidate.matchDetails;
    final court = candidate.court;

    final startTime = DateTime.parse(matchDetails?['startTime']);
    final endTime = DateTime.parse(matchDetails?['endTime']);
    final formattedStartTime =
        DateFormat('yyyy년 MM월 dd일 HH:mm').format(startTime);
    final formattedEndTime = DateFormat('HH:mm').format(endTime);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/tennis_court.jpg',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              candidate.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 18),
                SizedBox(width: 4),
                Text(
                  '${opponent?['gender'] == 'MALE' ? '남성' : '여성'}, ${opponent?['age'] ?? 'N/A'}세',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.sports_tennis, size: 18),
                SizedBox(width: 4),
                Text(
                  'NTRP ${opponent?['ntrp'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.favorite, size: 18, color: Colors.red),
                SizedBox(width: 4),
                Text(
                  '매너 온도: ${opponent?['mannerScore'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, size: 18),
                SizedBox(width: 4),
                Text(
                  '$formattedStartTime - $formattedEndTime',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18),
                SizedBox(width: 4),
                Text(
                  '${court?['courtName'] ?? 'N/A'}, ${court?['courtType'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
