import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tennisfunapp/models/candidate_model.dart';
import 'package:tennisfunapp/components/candidate_card.dart';
import 'package:tennisfunapp/components/prompt_card.dart';
import 'package:tennisfunapp/services/match_api_service.dart';

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({Key? key}) : super(key: key);

  @override
  _TennisMatchScreenState createState() => _TennisMatchScreenState();
}

class _TennisMatchScreenState extends State<MatchInfoScreen> {
  final CardSwiperController controller = CardSwiperController();
  final MatchApiService matchApiService = MatchApiService();

  final List<CandidateModel> candidates = [];

  final List<CandidateModel> prompt = [
    CandidateModel(
        name: "게임 할 준비 되셨나요?",
        skillLevel: "아래 버튼을 눌러 상대를 찾아보세요!",
        isPrompt: true),
  ];

  List<Widget> cards = [];

  @override
  void initState() {
    super.initState();
    initializeMatchInfo();
  }

  void initializeMatchInfo() async {
    try {
      List<dynamic>? matchResults = await matchApiService.fetchMatchResults();

      if (matchResults == null) {
        // 응답 상태 코드가 200이 아닌 경우 (매치 리퀘스트 필요)
        setState(() {
          cards = prompt.map((candidate) {
            return PromptCard(
              candidate: candidate,
              onMatchRequest: () async {
                final result =
                    await Navigator.pushNamed(context, '/match-request');
                if (result != null && result == true) {
                  initializeMatchInfo();
                }
              },
            );
          }).toList();
        });
      } else if (matchResults.isEmpty) {
        // 결과가 빈 배열인 경우 (AI가 매치 상대를 찾고 있음)
        setState(() {
          cards = [
            CandidateCard(
              candidate: CandidateModel(
                name: "AI가 매칭작업을 수행중입니다.",
                skillLevel: "잠시만 기다려주세요.",
              ),
            ),
          ];
        });
      } else {
        // 결과가 빈 배열이 아닌 경우 (매치 결과 표시)
        List<CandidateModel> candidates = matchResults.map((result) {
          final opponent = result['opponent'];
          final matchDetails = result['matchDetails'];
          final court = result['court'];
          return CandidateModel(
            matchRequestId: result['matchRequestId'],
            opponent: opponent,
            matchDetails: matchDetails,
            court: court,
            status: result['status'],
            name: opponent['name'],
            skillLevel: '${opponent['ntrp']}',
            age: opponent['age'],
            gender: opponent['gender'],
          );
        }).toList();

        setState(() {
          cards = candidates.map((candidate) {
            return CandidateCard(candidate: candidate);
          }).toList();
        });
      }
    } catch (e) {
      setState(() {
        cards = [
          PromptCard(
            candidate: CandidateModel(
              name: 'Error fetching match results',
              skillLevel: 'Please try again later',
              isPrompt: true,
            ),
            onMatchRequest: () {},
          ),
        ];
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      // 데이터 로딩 중임을 사용자에게 알리는 위젯을 표시
      return Scaffold(
        appBar: AppBar(title: const Text('Tennis Matches')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis Matches'),
      ),
      body: SafeArea(
        child: CardSwiper(
          controller: controller,
          cardsCount: cards.length,
          cardBuilder: (context, index, _, __) {
            final screenWidth = MediaQuery.of(context).size.width;
            return Container(
              width: screenWidth - 40,
              child: cards[index],
            );
          },
          onSwipe: (prevIndex, index, direction) {
            debugPrint('Card $prevIndex was swiped $direction');
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
          allowedSwipeDirection: AllowedSwipeDirection.all(),
          isLoop: true,
        ),
      ),
    );
  }
}
