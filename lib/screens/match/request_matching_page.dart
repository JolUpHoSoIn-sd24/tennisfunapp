import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennisfunapp/services/match_api_service.dart';

enum MatchObjective { INTENSE, FUN, ANY }

// 토글버튼으로 새로 추가된 라인
final isSinglesbutton = [true, false];
final objectivebutton = [true, false, false];

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
  RangeValues runningTimeRange = const RangeValues(30, 120);
  double maxDistance = 5.0;
  DateTime? startDate = DateTime.now();
  TimeOfDay? startTime = TimeOfDay.now();
  DateTime? endDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay? endTime = TimeOfDay.now();
  String money = '';
  String message = '';
  TextEditingController userIdController = TextEditingController();
  TextEditingController dislikedCourtsController = TextEditingController();
  TextEditingController minTimeController = TextEditingController();
  TextEditingController maxTimeController = TextEditingController();
  TextEditingController rentalCostController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reservationCourtIdController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '매칭 정보 입력하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 0,
            letterSpacing: -0.10,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        // padding: EdgeInsets.all(8),
        children: [
          Container(
            padding: EdgeInsets.all(16),
            //color: Color(0xFFEDEDED),
            child: Text(
              '매칭 정보를 입력해주세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: -0.10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FullWidthThinBox(),
          Label('희망시간'),
          AvailableTime(context),
          FullWidthThinBox(),
          Label('선호 러닝 타임'),
          RunningTimeRangeSlider(),
          FullWidthThinBox(),
          Label('최대 거리'),
          MaxDistanceSlider(),
          FullWidthThinBox(),
          Label('경기 목적'),
          ObjectiveButton(),
          FullWidthThinBox(),
          Label('경기 유형'),
          isSinglesButton(),
          FullWidthThinBox(),
          Label('한 줄 소개'),
          DescriptionFormField(),
          FullWidthThinBox(),
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
                  "maxDistance": maxDistance,
                  "dislikedCourts": dislikedCourtsController.text.split(','),
                  "minTime": int.tryParse(minTimeController.text),
                  "maxTime": int.tryParse(maxTimeController.text),
                  "isReserved": hasReservedCourt,
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

  ListTile ReservedTime() {
    return ListTile(
      leading: Icon(
        Icons.timer,
        color: Color(0xFF464EFF),
      ),
      title: TextFormField(
        controller: minTimeController,
        decoration: InputDecoration(
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
          hintText: 'Reservation Court ID',
        ),
      ),
    );
  }

  ListTile Double() {
    return ListTile(
      title: Text('더블'),
      leading: Radio<bool>(
        activeColor: Color(0xFF464EFF),
        value: false,
        groupValue: isSingles,
        onChanged: (bool? value) {
          setState(() {
            isSingles = value!;
          });
        },
      ),
    );
  }

  ListTile Single() {
    return ListTile(
      title: Text('싱글'),
      leading: Radio<bool>(
        activeColor: Color(0xFF464EFF),
        value: true,
        groupValue: isSingles,
        onChanged: (bool? value) {
          setState(() {
            isSingles = value!;
          });
        },
      ),
    );
  }

  ListTile Any() {
    return ListTile(
      title: Text('다 좋아요'),
      leading: Radio<MatchObjective>(
        activeColor: Color(0xFF464EFF),
        value: MatchObjective.ANY,
        groupValue: objective,
        onChanged: (MatchObjective? value) {
          setState(() {
            objective = value!;
          });
        },
      ),
    );
  }

  ListTile Fun() {
    return ListTile(
      title: Text('부담없이'),
      leading: Radio<MatchObjective>(
        activeColor: Color(0xFF464EFF),
        value: MatchObjective.FUN,
        groupValue: objective,
        onChanged: (MatchObjective? value) {
          setState(() {
            objective = value!;
          });
        },
      ),
    );
  }

  ListTile Intense() {
    return ListTile(
      title: Text('진지하게'),
      leading: Radio<MatchObjective>(
        activeColor: Color(0xFF464EFF),
        value: MatchObjective.INTENSE,
        groupValue: objective,
        onChanged: (MatchObjective? value) {
          setState(() {
            objective = value!;
          });
        },
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
        decoration: InputDecoration(
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
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.black),
                  Text(
                    endDate == null
                        ? '종료 날짜 선택'
                        : '${DateFormat('yyyy-MM-dd').format(endDate!)}',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.black),
                  Text(
                      endTime == null
                          ? '종료 시간 선택'
                          : '${endTime!.format(context)}',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile AvailableTime(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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

                  endDate = picked;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 12, color: Colors.black),
                  Text(
                    startDate == null
                        ? '시작 날짜 선택'
                        : ' ${DateFormat('yyyy-MM-dd').format(startDate!)}',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.black),
                  Text(
                      startTime == null
                          ? '시작 시간 선택'
                          : '${startTime!.format(context)}',
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
          ),
          Text('~'),
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.black),
                  Text(
                      endTime == null
                          ? '종료 시간 선택'
                          : '${endTime!.format(context)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox FullWidthThinBox() {
    return SizedBox(
        width: double.infinity, // 화면 너비를 꽉 채웁니다.
        height: 7, // 얇은 높이 (원하는 값으로 조절 가능)
        child: Container(
          color: const Color(0xFFEDEDED),
        ));
  }

  RangeSlider RunningTimeRangeSlider() {
    return RangeSlider(
      activeColor: Color(0xFF464EFF),
      inactiveColor: Colors.grey,
      values: runningTimeRange,
      min: 30,
      max: 120,
      divisions: 3,
      labels: RangeLabels(
        '${runningTimeRange.start.round()} minutes',
        '${runningTimeRange.end.round()} minutes',
      ),
      onChanged: (RangeValues values) {
        setState(() {
          runningTimeRange = values;
          minTimeController.text = values.start.round().toString();
          maxTimeController.text = values.end.round().toString();
        });
      },
    );
  }

  Slider MaxDistanceSlider() {
    return Slider(
      value: maxDistance,
      min: 1,
      max: 10,
      divisions: 9,
      label: '${maxDistance.round()} Km',
      activeColor: Color(0xFF464EFF),
      inactiveColor: Colors.grey,
      onChanged: (double value) {
        setState(() {
          maxDistance = value;
        });
      },
    );
  }

  Padding Label(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
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

  Padding DescriptionFormField() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        width: 340,
        height: 30,
        child: TextFormField(
          style: TextStyle(
            color: Color(0xFF919191),
            fontSize: 13,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: -0.08,
          ),
          textAlignVertical: TextAlignVertical(y: 1.0),
          controller: descriptionController,
          decoration: InputDecoration(
              hintText: '한 줄 소개를 입력해주세요!',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Color(0xFF464EFF))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Container ObjectiveButton() {
    return Container(
      alignment: Alignment.center,
      child: ToggleButtons(
        constraints: BoxConstraints(
          minHeight: 20,
          minWidth: 80,
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
                break;
              case 1:
                objectivebutton[0] = false;
                objectivebutton[1] = true;
                objectivebutton[2] = false;
                objective = MatchObjective.INTENSE;
                break;
              case 2:
                objectivebutton[0] = false;
                objectivebutton[1] = false;
                objectivebutton[2] = true;
                objective = MatchObjective.ANY;
                break;
            }
          });
        },
      ),
    );
  }

  Container isSinglesButton() {
    return Container(
      alignment: Alignment.center,
      child: ToggleButtons(
        constraints: BoxConstraints(
          minHeight: 20,
          minWidth: 80,
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
                    color: Colors.grey, // 텍스트 색상 회색으로 설정하여 비활성화처럼 보이게 함
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
              // 복식 버튼은 비활성화 상태이므로 선택 불가
              // isSinglesbutton[0] = false;
              // isSinglesbutton[1] = true;
              // isSingles = false;
            }
          });
        },
      ),
    );
  }
}
