import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennisfunapp/screens/match/feedback_screen.dart';
import 'package:tennisfunapp/services/match_api_service.dart';
import 'package:tennisfunapp/services/payment_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchHistoryDetailScreen extends StatefulWidget {
  @override
  _MatchHistoryDetailScreenState createState() =>
      _MatchHistoryDetailScreenState();
}

class _MatchHistoryDetailScreenState extends State<MatchHistoryDetailScreen> {
  final MatchApiService matchApiService = MatchApiService();
  final PaymentApiService paymentApiService = PaymentApiService();
  List<dynamic>? matches;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMatchHistory();
  }

  void loadMatchHistory() async {
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
        return '점수 확정 대기중 - 모든 플레이어의 점수가 같아질 때까지 기다리는 중';
      case 'POSTGAME':
        return '경기 완료 - 모든 점수가 확정되었습니다';
      default:
        return state;
    }
  }

  Widget _buildPlayerDetails(List<dynamic> players,
      Map<String, dynamic> paymentStatus, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('플레이어 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...players.map((player) {
          bool hasPaid = paymentStatus[player['userId']] ?? false;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(player['name'][0]),
                backgroundColor: highlightColor,
              ),
              title: Text(player['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NTRP: ${player['ntrp']}'),
                  Text('나이: ${player['age']}'),
                  Text('성별: ${_translateGender(player['gender'])}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasPaid ? Icons.check_circle : Icons.cancel,
                        color: hasPaid ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        hasPaid ? '결제 완료' : '미결제',
                        style: TextStyle(
                          color: hasPaid ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
    final game = match['game'];
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
                Text('매칭 결과',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(color: highlightColor, thickness: 2),
            SizedBox(height: 16),
            Text('경기 ID: ${game['gameId']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('코트: ${game['matchDetails']['courtId']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('코트 타입: ${game['matchDetails']['courtType']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('대관 비용: ${game['rentalCost'].toInt()}원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
                '경기 시간: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(DateTime.parse(game['matchDetails']['startTime']))} - ${DateFormat('HH:mm').format(DateTime.parse(game['matchDetails']['endTime']))}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('상태: ${_translateGameState(game['postGameStatus'])}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: game['postGameStatus'] == 'PREGAME'
                        ? Colors.red
                        : Colors.green)),
            SizedBox(height: 24),
            _buildPlayerDetails(
              game['players'] as List<dynamic>? ?? [],
              game['paymentStatus'] as Map<String, dynamic>? ?? {},
              highlightColor,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: game['paymentStatus'][match['opponentId']] == false
                      ? () async {
                          String? paymentUrl =
                              await paymentApiService.initiatePayment();
                          if (paymentUrl != null) {
                            Uri url = Uri.parse(paymentUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Unable to launch the payment URL')));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Failed to initiate payment')));
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          game['paymentStatus'][match['opponentId']] == false
                              ? highlightColor
                              : Colors.grey,
                      foregroundColor: Colors.white),
                  child: Text('결제하기'),
                ),
                ElevatedButton(
                  onPressed: game['postGameStatus'] != 'PREGAME'
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedbackScreen()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: game['postGameStatus'] != 'PREGAME'
                          ? highlightColor
                          : Colors.grey,
                      foregroundColor: Colors.white),
                  child: Text('평가하기'),
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
