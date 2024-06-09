import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettlementCard extends StatelessWidget {
  final String courtName;
  final VoidCallback? onTap;

  SettlementCard({required this.courtName, this.onTap});

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
              onPressed: onTap,
              child: Text('매출현황', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
