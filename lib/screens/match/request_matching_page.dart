import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennisfunapp/services/match_api_service.dart';

enum MatchObjective { INTENSE, FUN, ANY }

class RequestMatchingPage extends StatefulWidget {
  const RequestMatchingPage({Key? key}) : super(key: key);

  @override
  _RequestMatchingPageState createState() => _RequestMatchingPageState();
}

class _RequestMatchingPageState extends State<RequestMatchingPage>
    with SingleTickerProviderStateMixin {
  List<Widget> courtWidgets = [];
  bool isSingles = true;
  MatchObjective objective = MatchObjective.FUN;
  bool isFocused = false;
  bool hasReservedCourt = false;
  DateTime? startDate = DateTime.now();
  TimeOfDay? startTime = TimeOfDay.now();
  DateTime? endDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay? endTime = TimeOfDay.now();
  String money = '';
  String message = '';
  double distance = 0;
  TextEditingController userIdController = TextEditingController();
  TextEditingController dislikedCourtsController = TextEditingController();
  TextEditingController minTimeController = TextEditingController();
  TextEditingController maxTimeController = TextEditingController();
  TextEditingController rentalCostController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reservationCourtIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '매칭 정보 입력하기',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.0,
            letterSpacing: -0.14,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '매칭 정보 입력',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != startDate) {
                      setState(() {
                        startDate = picked;
                      });
                    }
                  },
                  child: Text(startDate == null
                      ? '시작 날짜 선택'
                      : '시작 날짜: ${DateFormat('yyyy-MM-dd').format(startDate!)}'),
                ),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: startTime ?? TimeOfDay.now(),
                    );
                    if (picked != null && picked != startTime) {
                      setState(() {
                        startTime = picked;
                      });
                    }
                  },
                  child: Text(startTime == null
                      ? '시작 시간 선택'
                      : '시작 시간: ${startTime!.format(context)}'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != endDate) {
                      setState(() {
                        endDate = picked;
                      });
                    }
                  },
                  child: Text(endDate == null
                      ? '종료 날짜 선택'
                      : '종료 날짜: ${DateFormat('yyyy-MM-dd').format(endDate!)}'),
                ),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: endTime ?? TimeOfDay.now(),
                    );
                    if (picked != null && picked != endTime) {
                      setState(() {
                        endTime = picked;
                      });
                    }
                  },
                  child: Text(endTime == null
                      ? '종료 시간 선택'
                      : '종료 시간: ${endTime!.format(context)}'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: TextFormField(
              controller: minTimeController,
              decoration: InputDecoration(
                hintText: 'Min Time (minutes)',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          ListTile(
            leading: Icon(Icons.timer_off),
            title: TextFormField(
              controller: maxTimeController,
              decoration: InputDecoration(
                hintText: 'Max Time (minutes)',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '목표',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('진지하게'),
            leading: Radio<MatchObjective>(
              value: MatchObjective.INTENSE,
              groupValue: objective,
              onChanged: (MatchObjective? value) {
                setState(() {
                  objective = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('부담없이'),
            leading: Radio<MatchObjective>(
              value: MatchObjective.FUN,
              groupValue: objective,
              onChanged: (MatchObjective? value) {
                setState(() {
                  objective = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('다 좋아요'),
            leading: Radio<MatchObjective>(
              value: MatchObjective.ANY,
              groupValue: objective,
              onChanged: (MatchObjective? value) {
                setState(() {
                  objective = value!;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '게임 타입',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('싱글'),
            leading: Radio<bool>(
              value: true,
              groupValue: isSingles,
              onChanged: (bool? value) {
                setState(() {
                  isSingles = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('더블'),
            leading: Radio<bool>(
              value: false,
              groupValue: isSingles,
              onChanged: (bool? value) {
                setState(() {
                  isSingles = value!;
                });
              },
            ),
          ),
          SwitchListTile(
            title: Text('코트를 예약하셨나요?'),
            value: hasReservedCourt,
            onChanged: (bool value) {
              setState(() {
                hasReservedCourt = value;
              });
            },
          ),
          if (hasReservedCourt) ...[
            ListTile(
              leading: Icon(Icons.location_city),
              title: TextFormField(
                controller: reservationCourtIdController,
                decoration: InputDecoration(
                  hintText: 'Reservation Court ID',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: TextFormField(
                controller: rentalCostController,
                decoration: InputDecoration(
                  hintText: 'Rental Cost',
                  prefixText: '₩',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != endDate) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Text(endDate == null
                        ? '예약 날짜 선택'
                        : '예약 날짜: ${DateFormat('yyyy-MM-dd').format(endDate!)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay.now(),
                      );
                      if (picked != null && picked != endTime) {
                        setState(() {
                          endTime = picked;
                        });
                      }
                    },
                    child: Text(endTime == null
                        ? '예약 시간 선택'
                        : '예약 시간: ${endTime!.format(context)}'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: TextFormField(
                controller: minTimeController,
                decoration: InputDecoration(
                  hintText: '예약 시간 (분)',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: () async {
                MatchApiService matchApiService = MatchApiService();
                Map<String, dynamic> requestData = {
                  "startTime": startDate != null && startTime != null
                      ? DateTime(
                              startDate!.year,
                              startDate!.month,
                              startDate!.day,
                              startTime!.hour,
                              startTime!.minute)
                          .toIso8601String()
                      : null,
                  "endTime": endDate != null && endTime != null
                      ? DateTime(endDate!.year, endDate!.month, endDate!.day,
                              endTime!.hour, endTime!.minute)
                          .toIso8601String()
                      : null,
                  "objective": objective.toString().split('.').last,
                  "isSingles": isSingles,
                  "minTime": int.tryParse(minTimeController.text),
                  "maxTime": int.tryParse(maxTimeController.text),
                  "description": descriptionController.text,
                };

                var response =
                    await matchApiService.createMatchRequest(requestData);
                if (response.statusCode == 201) {
                  // 성공 처리 로직
                  print("매칭 정보 등록 성공: ${response.body}");
                  Navigator.of(context).pop(true);
                } else {
                  // 실패 처리 로직
                  print("요청 실패: ${response.body}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("매칭 정보를 모두 정확히 입력해주세요.")),
                  );
                }
              },
              child: Text('저장하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
