import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennisfunapp/screens/match/score_edit_screen.dart';
import 'package:tennisfunapp/services/match_api_service.dart';

class MatchHistoryDetailScreen extends StatefulWidget {
  @override
  _MatchHistoryDetailScreenState createState() =>
      _MatchHistoryDetailScreenState();
}

class _MatchHistoryDetailScreenState extends State<MatchHistoryDetailScreen> {
  final MatchApiService matchApiService = MatchApiService();
  List<dynamic>? matches;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMatchHistory();
  }

  void loadMatchHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      var fetchedMatches = await matchApiService.fetchMatchHistory();
      setState(() {
        matches = fetchedMatches;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading match history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String _translateGender(String gender) {
    switch (gender) {
      case 'MALE':
        return '남성';
      case 'FEMALE':
        return '여성';
      default:
        return gender;
    }
  }

  String _translateGameState(String state) {
    switch (state) {
      case 'PREGAME':
        return '경기 전 - 결제 대기 중';
      case 'INPLAY':
        return '경기 진행 중 - 경기 완료 후 평가하세요';
      case 'AWAIT_FEEDBACK':
        return '피드백 대기 중 - 평가를 기다리는 중';
      case 'AWAIT_SCORE_CONFIRM':
        return '점수 확정 대기중 \n- 모든 플레이어의 점수가 같아질 때까지 기다리는 중';
      case 'POSTGAME':
        return '경기 완료 \n- 모든 점수가 확정되었습니다';
      default:
        return state;
    }
  }

  Widget _buildPlayerDetails(List<dynamic> players, List<dynamic> scores,
      String opponentId, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('플레이어 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...players.map((player) {
          final score = scores.firstWhere(
              (score) => score['userId'] == player['userId'],
              orElse: () => null);
          final opponentScore = scores.firstWhere(
              (score) => score['userId'] == opponentId,
              orElse: () => null);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(player['name'][0]),
                      backgroundColor: highlightColor,
                    ),
                    title: Text(player['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NTRP: ${player['ntrp']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('나이: ${player['age']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('성별: ${_translateGender(player['gender'])}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            '입력한 플레이어의 점수: ${score?['scoreDetailDto']?['userScore'] ?? 'N/A'}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            '입력한 상대방의 점수: ${score?['scoreDetailDto']?['opponentScore'] ?? 'N/A'}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMatchCard(dynamic match, Color highlightColor) {
    final game = match['gameDetailsDto'];
    final scores = match['scores'] as List<dynamic>;
    final playerScore = scores.firstWhere(
        (score) => score['userId'] != match['opponentId'],
        orElse: () => null);
    final opponentScore = scores.firstWhere(
        (score) => score['userId'] == match['opponentId'],
        orElse: () => null);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sports_tennis, color: highlightColor, size: 30),
                SizedBox(width: 8),
                Text('${match['elapsedTime']} 게임 결과',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(color: highlightColor, thickness: 2),
            SizedBox(height: 16),
            Text('코트: ${match['courtName']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('코트 타입: ${game['court']['surfaceType']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('대관 비용: ${game['rentalCost'].toInt()}원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
                '경기 시간: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(DateTime.parse(game['startTime']))} - ${DateFormat('HH:mm').format(DateTime.parse(game['endTime']))}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('상태: ${_translateGameState(game['state'])}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: game['state'] == 'AWAIT_SCORE_CONFIRM'
                        ? Colors.red
                        : Colors.green)),
            SizedBox(height: 24),
            _buildPlayerDetails(
              game['players'] as List<dynamic>? ?? [],
              scores,
              match['opponentId'],
              highlightColor,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: game['state'] != 'PREGAME' &&
                          game['state'] != 'POSTGAME'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScoreEditScreen(
                                gameId: game['gameId'],
                                userScore: playerScore?['scoreDetailDto']
                                        ?['userScore'] ??
                                    0,
                                opponentScore: playerScore?['scoreDetailDto']
                                        ?['opponentScore'] ??
                                    0,
                              ),
                            ),
                          ).then((_) {
                            loadMatchHistory();
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: game['state'] != 'PREGAME' &&
                              game['state'] != 'POSTGAME'
                          ? highlightColor
                          : Colors.grey,
                      foregroundColor: Colors.white),
                  child: Text('점수 수정하기'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color highlightColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('경기 기록'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : matches == null || matches!.isEmpty
              ? Center(child: Text('경기 기록이 없습니다.'))
              : ListView.builder(
                  itemCount: matches!.length,
                  itemBuilder: (context, index) {
                    final match = matches![index];
                    return _buildMatchCard(match, highlightColor);
                  },
                ),
    );
  }
}
