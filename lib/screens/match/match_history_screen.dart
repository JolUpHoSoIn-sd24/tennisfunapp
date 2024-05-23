import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/match_api_service.dart';
import 'package:tennisfunapp/models/game.dart';

class MatchHistoryScreen extends StatelessWidget {
  final MatchApiService matchApiService = MatchApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('매칭 히스토리'),
      ),
      body: FutureBuilder<Game?>(
        future: matchApiService.fetchGameDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러가 발생했습니다.'));
          } else if (snapshot.hasData) {
            final game = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sports_tennis,
                                color: Colors.blue, size: 30),
                            SizedBox(width: 8),
                            Text(
                              '매칭 결과',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('코트: ${game.court.name}'),
                        Text('코트 타입: ${game.court.surfaceType}'),
                        Text(
                          '대관 비용: ${game.rentalCost}원',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('시작 시간: ${game.startTime}'),
                        Text('종료 시간: ${game.endTime}'),
                        Text(
                          '상태: ${game.state}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.blue, size: 30),
                            SizedBox(width: 8),
                            Text(
                              '플레이어',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ...game.players.map((player) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '이름: ${player.name}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('NTRP: ${player.ntrp}'),
                                  Text('나이: ${player.age}'),
                                  Text('성별: ${player.gender}'),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('매칭 결과가 없습니다.'));
          }
        },
      ),
    );
  }
}
