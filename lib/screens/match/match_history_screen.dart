import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tennisfunapp/services/match_api_service.dart';
import 'package:tennisfunapp/services/user_api_service.dart';
import 'package:tennisfunapp/services/payment_api_service.dart';
import 'package:tennisfunapp/models/game.dart';
import 'package:tennisfunapp/models/user.dart';
import 'package:tennisfunapp/screens/match/feedback_screen.dart';

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
        return '피드백 대기 중 - 상대의 평가를 기다리는 중';
      default:
        return state;
    }
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
                      _buildNoMatchCard(highlightColor),
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: highlightColor,
              child: Text(
                user.name[0],
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
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
                  _buildUserInfoRow(Icons.star, 'NTRP', '${user.ntrp}'),
                  _buildUserInfoRow(
                      Icons.thumb_up, '매너 점수', '${user.mannerScore}'),
                  _buildUserInfoRow(
                      Icons.person, '성별', _translateGender(user.gender)),
                  _buildUserInfoRow(Icons.email, '이메일', user.emailId,
                      isEmail: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value,
      {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 18, color: Colors.black)),
          Expanded(
            child: Tooltip(
              message: isEmail ? value : '', // Ensure message is provided
              child: Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.black),
                overflow: isEmail ? TextOverflow.ellipsis : null,
                maxLines: isEmail ? 1 : null,
              ),
            ),
          ),
        ],
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
            Text('상태: ${_translateGameState(game.state)}',
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
                    onPressed: game.players
                                .firstWhere(
                                    (player) => player.userId == user?.id)
                                .feedback ==
                            false
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: game.players
                                    .firstWhere(
                                        (player) => player.userId == user?.id)
                                    .feedback ==
                                false
                            ? highlightColor
                            : Colors.grey,
                        foregroundColor: Colors.white),
                    child: Text('평가하기')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchCard(Color highlightColor) {
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
                Icon(Icons.info, color: highlightColor, size: 30),
                SizedBox(width: 8),
                Text('매칭 결과가 없습니다.',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(color: highlightColor, thickness: 2),
            SizedBox(height: 16),
            Text('매칭 과정을 진행해주세요.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          bool hasFeedback = player.feedback ?? false;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                  child: Text(player.name[0]), backgroundColor: highlightColor),
              title: Text(player.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NTRP: ${player.ntrp}'),
                  Text('나이: ${player.age}'),
                  Text('성별: ${_translateGender(player.gender)}'),
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
                  SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasFeedback ? Icons.feedback : Icons.feedback_outlined,
                        color: hasFeedback ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        hasFeedback ? '피드백 완료' : '피드백 미완료',
                        style: TextStyle(
                          color: hasFeedback ? Colors.green : Colors.red,
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
