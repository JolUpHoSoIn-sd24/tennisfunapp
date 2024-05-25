import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            height: 0,
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
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.14,
              ),
            ),
          ),
          StartDate(context),
          EndDate(context),
          MinTime(),
          MaxTime(),
          Description(),
          IsIntense(),
          ObjectiveButton(),
          GameType(),
          isSinglesButton(),
          CourtIsReserved(),
          if (hasReservedCourt) ...[
            ReservationCourtID(),
            RentalCost(),
            ReservedDate(context),
            ReservedTime(),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF464EFF),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFF464EFF)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
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
              child: Text(
                '저장하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.0,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final isSinglesbutton = [true, false];
  final objectivebutton = [true, false, false];

  Container isSinglesButton() {
    return Container(
      alignment: Alignment.center,
      child: ToggleButtons(
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: 150,
        ),
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('단식',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('복식',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ))),
        ],
        isSelected: isSinglesbutton,
        selectedBorderColor: Color(0xFF464EFF),
        fillColor: Color(0xFF464EFF),
        selectedColor: Colors.white,
        borderRadius: BorderRadius.circular(3),
        onPressed: (index) {
          setState(() {
            if (index == 0) {
              isSinglesbutton[0] = true;
              isSinglesbutton[1] = false;
              isSingles = true;
            } else {
              isSinglesbutton[0] = false;
              isSinglesbutton[1] = true;
              isSingles = false;
            }
          });
        },
      ),
    );
  }

  Container ObjectiveButton() {
    return Container(
      alignment: Alignment.center,
      child: ToggleButtons(
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: 100,
        ),
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('부담없이',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('진지하게',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('다 좋아요!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ))),
        ],
        isSelected: objectivebutton,
        selectedBorderColor: Color(0xFF464EFF),
        fillColor: Color(0xFF464EFF),
        selectedColor: Colors.white,
        borderRadius: BorderRadius.circular(3),
        onPressed: (index) {
          setState(() {
            switch (index) {
              case 0:
                objectivebutton[0] = true;
                objectivebutton[1] = false;
                objectivebutton[2] = false;
                objective = MatchObjective.FUN;
              case 1:
                objectivebutton[0] = false;
                objectivebutton[1] = true;
                objectivebutton[2] = false;
                objective = MatchObjective.ANY;
              case 2:
                objectivebutton[0] = false;
                objectivebutton[1] = false;
                objectivebutton[2] = true;
                objective = MatchObjective.INTENSE;
            }
          });
        },
      ),
    );
  }

  ListTile ReservedTime() {
    return ListTile(
      leading: Icon(
        Icons.timer,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: minTimeController,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF464EFF), width: 3)),
          hintText: '예약 시간 (분)',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  ListTile ReservedDate(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.calendar_today,
        color: Color(0xFF464EFF),
      ),
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
            child: Text(
              endDate == null
                  ? '예약 날짜 선택'
                  : '예약 날짜: ${DateFormat('yyyy-MM-dd').format(endDate!)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.10,
              ),
            ),
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
            child: Text(
              endTime == null
                  ? '예약 시간 선택'
                  : '예약 시간: ${endTime!.format(context)}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: -0.10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile RentalCost() {
    return ListTile(
      leading: Icon(
        Icons.money,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: rentalCostController,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF464EFF), width: 3)),
          hintText: 'Rental Cost',
          prefixText: '₩',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  SwitchListTile CourtIsReserved() {
    return SwitchListTile(
      title: Text(
        '코트를 예약하셨나요?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 0,
          letterSpacing: -0.10,
        ),
      ),
      activeColor: Color(0xFF464EFF),
      value: hasReservedCourt,
      onChanged: (bool value) {
        setState(() {
          hasReservedCourt = value;
        });
      },
    );
  }

  ListTile ReservationCourtID() {
    return ListTile(
      leading: Icon(
        Icons.location_city,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: reservationCourtIdController,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF464EFF), width: 3)),
          hintText: 'Reservation Court ID',
        ),
      ),
    );
  }

  Padding GameType() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '게임 타입',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 0,
          letterSpacing: -0.10,
        ),
      ),
    );
  }

  Padding IsIntense() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '목표',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 0,
          letterSpacing: -0.10,
        ),
      ),
    );
  }

  ListTile Description() {
    return ListTile(
      leading: Icon(
        Icons.edit,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: descriptionController,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF464EFF), width: 3)),
          hintText: 'Description',
        ),
      ),
    );
  }

  ListTile MaxTime() {
    return ListTile(
      leading: Icon(
        Icons.timer_off,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: maxTimeController,
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF464EFF), width: 3)),
          hintText: 'Max Time (minutes)',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  ListTile MinTime() {
    return ListTile(
      leading: Icon(
        Icons.timer,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: minTimeController,
        strutStyle: StrutStyle(
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
        decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF464EFF), width: 3)),
          hintText: 'Min Time (minutes)',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  ListTile EndDate(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.calendar_today,
        color: Color(0xFF464EFF),
      ),
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
            child: Text(
              endDate == null
                  ? '종료 날짜 선택'
                  : '종료 날짜: ${DateFormat('yyyy-MM-dd').format(endDate!)}',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.14,
              ),
            ),
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
            child: Text(
              endTime == null
                  ? '종료 시간 선택'
                  : '종료 시간: ${endTime!.format(context)}',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile StartDate(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.calendar_today,
        color: Color(0xFF464EFF),
      ),
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
            child: Text(
              startDate == null
                  ? '시작 날짜 선택'
                  : '시작 날짜: ${DateFormat('yyyy-MM-dd').format(startDate!)}',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.14,
              ),
            ),
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
            child: Text(
              startTime == null
                  ? '시작 시간 선택'
                  : '시작 시간: ${startTime!.format(context)}',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: -0.14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
