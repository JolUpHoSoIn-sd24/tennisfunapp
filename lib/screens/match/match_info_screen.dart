import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tennisfunapp/models/candidate_model.dart';
import 'package:tennisfunapp/components/candidate_card.dart';
import 'package:tennisfunapp/components/prompt_card.dart';

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({Key? key}) : super(key: key);

  @override
  _TennisMatchScreenState createState() => _TennisMatchScreenState();
}

class _TennisMatchScreenState extends State<MatchInfoScreen> {
  final CardSwiperController controller = CardSwiperController();

  final List<CandidateModel> candidates = [
    CandidateModel(name: "John Doe", skillLevel: "Advanced"),
    CandidateModel(name: "Jane Smith", skillLevel: "Intermediate"),
    CandidateModel(name: "Richard Roe", skillLevel: "Beginner"),
  ];

  final List<CandidateModel> prompt = [
    CandidateModel(
        name: "Ready for a match?",
        skillLevel: "Tap below to find a partner!",
        isPrompt: true),
  ];

  late List<Widget> cards;

  @override
  void initState() {
    super.initState();
    // 여기에 조건을 추가하여 candidates 또는 prompt를 선택하도록 합니다.
    bool isMatchRequestNeeded = true;
    List<CandidateModel> selectedList =
        isMatchRequestNeeded ? prompt : candidates;

    // 리스트가 비어 있을 경우 기본 카드를 추가
    if (selectedList.isEmpty) {
      selectedList = [
        CandidateModel(
            name: "No candidates available",
            skillLevel: "Please check back later!",
            isPrompt: true),
      ];
    }

    cards = selectedList.map((candidate) {
      if (candidate.isPrompt) {
        return PromptCard(
            candidate: candidate,
            onMatchRequest: () {
              Navigator.pushNamed(context, '/match-request');
            });
      } else {
        return CandidateCard(candidate: candidate);
      }
    }).toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
