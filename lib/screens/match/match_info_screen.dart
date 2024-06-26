import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tennisfunapp/models/candidate_model.dart';
import 'package:tennisfunapp/models/game.dart';
import 'package:tennisfunapp/components/candidate_card.dart';
import 'package:tennisfunapp/components/prompt_card.dart';
import 'package:tennisfunapp/services/match_api_service.dart';

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({Key? key}) : super(key: key);

  @override
  _MatchInfoScreenState createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  final CardSwiperController controller = CardSwiperController();
  final MatchApiService matchApiService = MatchApiService();
  Timer? pollingTimer;

  final List<CandidateModel> prompt = [
    CandidateModel(
      name: "게임 할 준비 되셨나요?",
      skillLevel: "아래 버튼을 눌러 상대를 찾아보세요!",
      isPrompt: true,
    ),
  ];

  final CandidateModel ongoingGamePrompt = CandidateModel(
    name: "게임이 생성되었습니다.",
    skillLevel: "현재 게임을 마무리한 후 새로운 게임을 시작해보세요!",
    isPrompt: true,
  );

  List<Widget> cards = [];

  @override
  void initState() {
    super.initState();
    initializeMatchInfo();
  }

  void initializeMatchInfo() async {
    try {
      // Check for ongoing game
      Game? ongoingGame = await matchApiService.fetchGameDetails();
      if (ongoingGame != null) {
        // Display ongoing game prompt
        setState(() {
          cards = [
            PromptCard(
              candidate: ongoingGamePrompt,
              onMatchRequest: null, // No match request button for ongoing game
              icon: Icons.warning, // Warning icon
            ),
          ];
        });
        return;
      }

      List<dynamic>? matchResults = await matchApiService.fetchMatchResults();
      bool matchRequest = await matchApiService.fetchMatchRequest();

      if (!matchRequest) {
        // 응답 상태 코드가 200이 아닌 경우 (매치 리퀘스트 필요)
        setState(() {
          cards = [];
        });
      } else if (matchResults?.isEmpty ?? true) {
        // 결과가 빈 배열인 경우 (AI가 매치 상대를 찾고 있음)
        setState(() {
          cards = [
            PromptCard(
              candidate: CandidateModel(
                name: "AI가 매칭작업을 수행중입니다.",
                skillLevel: "잠시만 기다려주세요.",
                isPrompt: true,
              ),
              onMatchRequest: () async {
                final result =
                await Navigator.pushNamed(context, '/match-request');
                if (result != null && result == true) {
                  initializeMatchInfo();
                }
              },
              icon: Icons.hourglass_empty, // Clock icon
            ),
          ];
        });
        // 시작 polling
        startPolling();
      } else {
        // 결과가 빈 배열이 아닌 경우 (매치 결과 표시)
        stopPolling(); // 매칭 결과가 생기면 polling 중지
        List<CandidateModel> candidates = matchResults?.map((result) {
          final opponent = result['opponent'];
          final matchDetails = result['matchDetails'];
          final court = result['court'];
          return CandidateModel(
            id: result['id'],
            opponent: opponent,
            matchDetails: matchDetails,
            court: court,
            status: result['status'],
            name: opponent['name'],
            skillLevel: '${opponent['ntrp']}',
            age: opponent['age'],
            gender: opponent['gender'],
          );
        })?.toList() ??
            [];

        setState(() {
          cards = candidates.map((candidate) {
            return CandidateCard(candidate: candidate);
          }).toList();
        });
      }
    } catch (e) {
      setState(() {
        cards = [];
      });
    }
  }

  void startPolling() {
    pollingTimer?.cancel();
    pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      initializeMatchInfo();
    });
  }

  void stopPolling() {
    pollingTimer?.cancel();
    pollingTimer = null;
  }

  @override
  void dispose() {
    controller.dispose();
    stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('테니스 매칭')),
        body: Center(
          child: PromptCard(
            candidate: prompt[0],
            onMatchRequest: () async {
              final result =
              await Navigator.pushNamed(context, '/match-request');
              if (result != null && result == true) {
                initializeMatchInfo();
              }
            },
            icon: Icons.sports_tennis, // Tennis racket icon
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('테니스 매칭'),
      ),
      body: SafeArea(
        child: CardSwiper(
          controller: controller,
          cardsCount: cards.length,
          cardBuilder: (context, index, _, __) {
            if (index >= cards.length) {
              // Display the ongoing game prompt card if index is out of bounds
              return PromptCard(
                candidate: ongoingGamePrompt,
                onMatchRequest: null,
                icon: Icons.warning,
              );
            }
            final screenWidth = MediaQuery.of(context).size.width;
            return Stack(
              children: [
                Container(
                  width: screenWidth - 40,
                  child: cards[index],
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.thumb_up,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
              ],
            );
          },
          onSwipe: (prevIndex, index, direction) async {
            debugPrint('Card $prevIndex was swiped $direction');
            if (prevIndex != null &&
                prevIndex < cards.length &&
                cards[prevIndex] is CandidateCard) {
              String? id = (cards[prevIndex] as CandidateCard).candidate.id;
              if (id != null) {
                String feedback =
                direction == CardSwiperDirection.right ? 'LIKE' : 'DISLIKE';
                bool success =
                await matchApiService.submitMatchFeedback(id, feedback);
                setState(() {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('평가가 성공적으로 제출되었습니다.'),
                        duration: Duration(milliseconds: 200),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('평가가 제출되지 않았습니다. 다시 시도해주세요.'),
                        duration: Duration(milliseconds: 200),
                      ),
                    );
                  }
                });
                initializeMatchInfo();
              }
            }
            return true;
          },
          onUndo: (prevIndex, index, direction) {
            debugPrint(
                'Undo swipe on card $index, which was swiped $direction');
            return true;
          },
          numberOfCardsDisplayed: cards.length >= 3 ? 3 : cards.length,
          backCardOffset: const Offset(25, 0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          scale: 0.9,
          threshold: 30,
          maxAngle: 30,
          allowedSwipeDirection: AllowedSwipeDirection.only(
            left: true,
            right: true,
          ),
          isLoop: true,
        ),
      ),
    );
  }
}
