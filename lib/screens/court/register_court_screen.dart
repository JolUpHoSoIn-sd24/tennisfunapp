import 'package:flutter/material.dart';

class RegisterCourtScreen extends StatefulWidget {
  @override
  _RegisterCourtScreenState createState() => _RegisterCourtScreenState();
}

class _RegisterCourtScreenState extends State<RegisterCourtScreen> {
  final TextEditingController _courtNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];
  final List<String> _timeSlots = [
    for (int i = 0; i < 24; i++) for (int j = 0; j < 2; j++) '${i.toString().padLeft(2, '0')}:${j == 0 ? '00' : '30'}'
  ];
  final List<TimeSlot> _timeSlotsList = [TimeSlot()];

  @override
  void dispose() {
    _courtNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTimeSlot() {
    if (_timeSlotsList.length < 7) {
      setState(() {
        _timeSlotsList.add(TimeSlot());
      });
    }
  }

  bool _validateTimeSlots() {
    for (TimeSlot slot in _timeSlotsList) {
      if (slot.startTime == null || slot.endTime == null || slot.day == null) {
        return false;
      }
      int startIndex = _timeSlots.indexOf(slot.startTime!);
      int endIndex = _timeSlots.indexOf(slot.endTime!);
      if (startIndex >= endIndex) {
        return false;
      }
    }
    return true;
  }

  List<String> _getAvailableDays(int index) {
    List<String> availableDays = List.from(_daysOfWeek);
    for (int i = 0; i < _timeSlotsList.length; i++) {
      if (i != index && _timeSlotsList[i].day != null) {
        availableDays.remove(_timeSlotsList[i].day);
      }
    }
    return availableDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테니스코트 정보 입력하기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _courtNameController,
              decoration: InputDecoration(
                labelText: '테니스 코트 이름',
                hintText: '최대 몇글자까지 가능합니다',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: '설명',
                hintText: '코트에 대한 설명을 적어주세요',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Text('희망시간', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._timeSlotsList.map((slot) => _buildTimeSlotRow(slot)).toList(),
            SizedBox(height: 8),
            if (_timeSlotsList.length < 7)
              IconButton(
                onPressed: _addTimeSlot,
                icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor),
              ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '30분당 대여 비용',
                suffixText: '원',
              ),
            ),
            SizedBox(height: 16),
            Text('경기 코트', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ToggleButtons(
              isSelected: [true, false, false],
              onPressed: (int index) {
                setState(() {
                  // 원하는 대로 상태를 업데이트하세요
                });
              },
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('하드코트'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('클레이코트'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('잔디코트'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Checkbox(
                  value: true,
                  onChanged: (bool? value) {
                    setState(() {
                      // 원하는 대로 상태를 업데이트하세요
                    });
                  },
                ),
                Text('코트 예약 자동 매칭'),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_validateTimeSlots()) {
                    // 등록하기 기능 구현
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('시간 설정이 올바르지 않습니다.')),
                    );
                  }
                },
                child: Text('등록하기'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotRow(TimeSlot slot) {
    int index = _timeSlotsList.indexOf(slot);
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: '요일'),
            items: _getAvailableDays(index).map((String day) {
              return DropdownMenuItem<String>(
                value: day,
                child: Text(day),
              );
            }).toList(),
            value: slot.day,
            onChanged: (value) {
              setState(() {
                slot.day = value;
              });
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: '시작시간'),
            items: _timeSlots.map((String time) {
              return DropdownMenuItem<String>(
                value: time,
                child: Text(time),
              );
            }).toList(),
            value: slot.startTime,
            onChanged: (value) {
              setState(() {
                slot.startTime = value;
              });
            },
          ),
        ),
        SizedBox(width: 8),
        Text('~'),
        SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: '종료시간'),
            items: _timeSlots.map((String time) {
              return DropdownMenuItem<String>(
                value: time,
                child: Text(time),
              );
            }).toList(),
            value: slot.endTime,
            onChanged: (value) {
              setState(() {
                slot.endTime = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class TimeSlot {
  String? day;
  String? startTime;
  String? endTime;
}
