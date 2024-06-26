import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourtCard extends StatelessWidget {
  final String courtName;
  final VoidCallback? onTap;

  CourtCard({required this.courtName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.sports_tennis),
        title: Text(courtName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              onPressed: () {
                // 수정하기 기능을 구현하세요
              },
              child: Text('수정하기', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: onTap,
              child: Text('예약현황', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
