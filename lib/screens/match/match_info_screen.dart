import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tennisfunapp/models/candidate_model.dart';
import 'package:tennisfunapp/components/candidate_card.dart';

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
    // 추가 플레이어 정보를 여기에 넣어주세요.
  ];
  late final List<Widget> cards;

  @override
  void initState() {
    super.initState();
    cards = candidates
        .map((candidate) => CandidateCard(candidate: candidate))
        .toList();
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
              width: screenWidth - 40, // 화면 너비에서 40px 감소 (좌우 20px씩)
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
          numberOfCardsDisplayed: 3,
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
