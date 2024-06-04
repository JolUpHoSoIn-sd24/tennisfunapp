import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennisfunapp/services/match_api_service.dart';
import 'package:tennisfunapp/services/user_api_service.dart';
import 'package:tennisfunapp/models/game.dart';
import 'package:tennisfunapp/models/user.dart';

class MatchHistoryScreen extends StatelessWidget {
  final MatchApiService matchApiService = MatchApiService();
  final UserApiService userApiService = UserApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.wait([
          matchApiService.fetchGameDetails(),
          userApiService.fetchUserDetails(),
        ]).then((values) => {
              'game': values[0],
              'user': values[1],
            }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러가 발생했습니다.'));
          } else if (snapshot.hasData) {
            final game = snapshot.data!['game'] as Game?;
            final user = snapshot.data!['user'] as User?;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user != null) ...[
                      Text(
                        '안녕하세요\n${user.name}님!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('NTRP: ${user.ntrp}'),
                      Text('매너 점수: ${user.mannerScore}'),
                      SizedBox(height: 16),
                      Text('현재 매칭된 테니스 경기', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 8),
                    ],
                    if (game != null) ...[
                      Card(
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
                                '대관 비용: ${game.rentalCost.toInt()}원',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                  '경기 시간: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(game.startTime)} - ${DateFormat('HH:mm').format(game.endTime)}'),
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
                                  Icon(Icons.people,
                                      color: Colors.blue, size: 30),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // 결제하기 버튼 클릭 시 동작
                                    },
                                    child: Text('결제하기'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // 평가하기 버튼 클릭 시 동작
                                    },
                                    child: Text('평가하기'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Center(child: Text('매칭 결과가 없습니다.')),
                    ],
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('데이터가 없습니다.'));
          }
        },
      ),
    );
  }
}
