import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tennisfunapp/services/match_api_service.dart';
import 'package:tennisfunapp/services/user_api_service.dart';
import 'package:tennisfunapp/services/payment_api_service.dart';
import 'package:tennisfunapp/models/game.dart';
import 'package:tennisfunapp/models/user.dart';

class MatchHistoryScreen extends StatelessWidget {
  final MatchApiService matchApiService = MatchApiService();
  final UserApiService userApiService = UserApiService();
  final PaymentApiService paymentApiService = PaymentApiService();

  @override
  Widget build(BuildContext context) {
    Color highlightColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Future.wait([
          matchApiService.fetchGameDetails(),
          userApiService.fetchUserDetails(),
        ]).then((values) => {'game': values[0], 'user': values[1]}),
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
                    _buildUserDetails(user, highlightColor),
                    if (game != null) ...[
                      SizedBox(height: 24),
                      _buildGameDetails(game, highlightColor, context),
                      _buildPlayerDetails(game, highlightColor),
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

  Widget _buildUserDetails(User? user, Color highlightColor) {
    if (user == null) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안녕하세요, ${user.name}님!',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: highlightColor),
        ),
        SizedBox(height: 8),
        Text('NTRP: ${user.ntrp}',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: highlightColor)),
        Text('매너 점수: ${user.mannerScore}',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: highlightColor)),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGameDetails(
      Game game, Color highlightColor, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            Text('코트: ${game.court.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('코트 타입: ${game.court.surfaceType}',
                style: TextStyle(fontSize: 16)),
            Text('대관 비용: ${game.rentalCost.toInt()}원',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: highlightColor)),
            Text(
                '경기 시간: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(game.startTime)} - ${DateFormat('HH:mm').format(game.endTime)}',
                style: TextStyle(fontSize: 16)),
            Text('상태: ${game.state}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: highlightColor)),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String? paymentUrl =
                          await paymentApiService.initiatePayment();
                      if (paymentUrl != null) {
                        Uri url = Uri.parse(paymentUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Unable to launch the payment URL')));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to initiate payment')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: highlightColor,
                        foregroundColor: Colors.white),
                    child: Text('결제하기')),
                ElevatedButton(
                    onPressed: () {
                      // Implement review functionality
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: highlightColor,
                        foregroundColor: Colors.white),
                    child: Text('평가하기')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerDetails(Game game, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('플레이어 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...game.players.map((player) {
          bool hasPaid = game.paymentStatus[player.userId] ?? false;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                  child: Text(player.name[0]), backgroundColor: highlightColor),
              title: Text(player.name),
              subtitle: Text(
                  'NTRP: ${player.ntrp} | 나이: ${player.age} | 성별: ${player.gender}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Icon(
                hasPaid ? Icons.check_circle : Icons.cancel,
                color: hasPaid ? Colors.green : Colors.red,
              ),
            ),
          );
        }).toList(),
        SizedBox(height: 16),
      ],
    );
  }
}
