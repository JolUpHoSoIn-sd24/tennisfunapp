import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/match_api_service.dart';

class ScoreEditScreen extends StatefulWidget {
  final String gameId;
  final int userScore;
  final int opponentScore;

  ScoreEditScreen(
      {required this.gameId,
      required this.userScore,
      required this.opponentScore});

  @override
  _ScoreEditScreenState createState() => _ScoreEditScreenState();
}

class _ScoreEditScreenState extends State<ScoreEditScreen> {
  final MatchApiService matchApiService = MatchApiService();
  final _formKey = GlobalKey<FormState>();
  late int userScore;
  late int opponentScore;

  @override
  void initState() {
    super.initState();
    userScore = widget.userScore;
    opponentScore = widget.opponentScore;
  }

  void _submitScores() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await matchApiService.updateScores(
            widget.gameId, userScore, opponentScore);
        Navigator.pop(context);
      } catch (e) {
        print("Error submitting scores: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('점수 업데이트 중 오류가 발생했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('점수 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: userScore.toString(),
                decoration: InputDecoration(labelText: '나의 점수'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '점수를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  userScore = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: opponentScore.toString(),
                decoration: InputDecoration(labelText: '상대방의 점수'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '점수를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  opponentScore = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitScores,
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
