import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tennisfunapp/services/match_api_service.dart';
import 'package:tennisfunapp/services/user_api_service.dart';
import 'package:tennisfunapp/services/payment_api_service.dart';
import 'package:tennisfunapp/models/game.dart';
import 'package:tennisfunapp/models/user.dart';

class MatchHistoryScreen extends StatefulWidget {
  @override
  _MatchHistoryScreenState createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen>
    with WidgetsBindingObserver {
  final MatchApiService matchApiService = MatchApiService();
  final UserApiService userApiService = UserApiService();
  final PaymentApiService paymentApiService = PaymentApiService();
  Game? game;
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData(); // Reload data when app is resumed
    }
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });
    var gameDetails = await matchApiService.fetchGameDetails();
    var userDetails = await userApiService.fetchUserDetails();
    setState(() {
      game = gameDetails;
      user = userDetails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color highlightColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserDetails(user, highlightColor),
                    SizedBox(height: 16),
                    if (game != null) ...[
                      SizedBox(height: 24),
                      _buildGameDetails(game!, highlightColor, context),
                    ] else ...[
                      Center(child: Text('매칭 결과가 없습니다.')),
                    ],
                    MenuOptions(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUserDetails(User? user, Color highlightColor) {
    if (user == null) return SizedBox.shrink();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, ${user.name}님!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            Text('NTRP: ${user.ntrp}',
                style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('매너 점수: ${user.mannerScore}',
                style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('대관 비용: ${game.rentalCost.toInt()}원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            Text(
                '경기 시간: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(game.startTime)} - ${DateFormat('HH:mm').format(game.endTime)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('상태: ${game.state}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        game.state == 'PREGAME' ? Colors.red : Colors.green)),
            SizedBox(height: 24),
            _buildPlayerDetails(game, highlightColor),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: game.paymentStatus[user?.id] == false
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to initiate payment')));
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: game.paymentStatus[user?.id] == false
                            ? highlightColor
                            : Colors.grey,
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
      ],
    );
  }
}

class MenuOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> options = [
      'Edit Account Info',
      'View and Change Ongoing Matches',
      'View and Change Match Status',
      'Terms of Use of TennisFun'
    ];

    return Column(
      children: options.map((option) {
        return ListTile(
          title: Text(option,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          trailing: Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.secondary),
          onTap: () {},
        );
      }).toList(),
    );
  }
}
