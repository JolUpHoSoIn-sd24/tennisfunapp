import 'package:flutter/material.dart';
import 'package:tennisfunapp/services/feedback_api_service.dart';

enum MannersRating { POOR, AVERAGE, EXCELLENT }

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final FeedbackApiService feedbackApiService = FeedbackApiService();

  int userScore = 0;
  int opponentScore = 0;
  MannersRating mannersRating = MannersRating.AVERAGE;
  double suggestedNTRP = 4.0;
  String comments = '';

  void _submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      var response = await feedbackApiService.submitFeedback({
        "scoreDetailDto": {
          "userScore": userScore,
          "opponentScore": opponentScore
        },
        "mannersRating": mannersRating.toString().split('.').last,
        "suggestedNTRP": suggestedNTRP,
        "comments": comments
      });

      if (response['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('평가가 성공적으로 등록되었습니다.')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('평가 등록에 실패했습니다. 다시 시도해 주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('게임 평가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('경기 결과', style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '사용자 점수',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '사용자 점수를 입력하세요';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userScore = int.parse(value!);
                        },
                      ),
                    ),
                    Text(':'),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '상대방 점수',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '상대방 점수를 입력하세요';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          opponentScore = int.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('상대 매너 온도', style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<MannersRating>(
                  value: mannersRating,
                  items: MannersRating.values.map((rating) {
                    return DropdownMenuItem(
                      value: rating,
                      child: Text(rating.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      mannersRating = value!;
                    });
                  },
                  onSaved: (value) {
                    mannersRating = value!;
                  },
                ),
                SizedBox(height: 16),
                Text('상대 NTRP 평가', style: TextStyle(fontSize: 18)),
                Slider(
                  value: suggestedNTRP,
                  min: 1.0,
                  max: 7.0,
                  divisions: 12,
                  label: suggestedNTRP.toString(),
                  onChanged: (value) {
                    setState(() {
                      suggestedNTRP = value;
                    });
                  },
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    child: Text('피드백 저장하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
