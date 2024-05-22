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
    bool isMatchRequestNeeded = await matchApiService.fetchMatchRequestStatus();
    List<CandidateModel> selectedList =
        isMatchRequestNeeded ? prompt : candidates;

    if (selectedList.isEmpty) {
      selectedList = [
        CandidateModel(
            name: "AI가 매칭작업을 수행중입니다.",
            skillLevel: "잠시만 기다려주세요.",
            isPrompt: true),
      ];
    }

    setState(() {
      cards = selectedList.map((candidate) {
        if (candidate.isPrompt) {
          return PromptCard(
              candidate: candidate,
              onMatchRequest: () async {
                final result =
                    await Navigator.pushNamed(context, '/match-request');
                if (result != null && result == true) {
                  initializeMatchInfo();
                }
              });
        } else {
          return CandidateCard(candidate: candidate);
        }
      }).toList();
    });
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
