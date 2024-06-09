import 'package:flutter/material.dart';
import '../../services/court_service.dart';
import 'court_reservation_detail_screen.dart';

class CourtReservationScreen extends StatefulWidget {
  final String courtId;
  final String courtName;

  CourtReservationScreen({required this.courtId, required this.courtName});

  @override
  _CourtReservationScreenState createState() => _CourtReservationScreenState();
}

class _CourtReservationScreenState extends State<CourtReservationScreen> {
  final CourtService _courtService = CourtService();
  List<Map<String, dynamic>> _reservations = [];
  bool _isLoading = true;
  bool _isPending = false;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var result = _isPending
          ? await _courtService.fetchPendingReservations(widget.courtId)
          : await _courtService.fetchReservations(widget.courtId);
      if (result != null) {
        setState(() {
          _reservations = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load reservations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('코트별 예약 현황'),
        leading: BackButton(),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  widget.courtName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ToggleButtons(
                  isSelected: [_isPending == false, _isPending == true],
                  onPressed: (int index) {
                    setState(() {
                      _isPending = index == 1;
                      _fetchReservations();
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: Theme.of(context).primaryColor,
                  color: Colors.black,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('예약'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('가예약'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                var reservation = _reservations[index];
                var courtName = reservation['courtName'];
                var userName = reservation['simpleCustomerDto']['userName'].join(', ');
                var reservationDate = reservation['simpleCustomerDto']['reservationDate'];
                return _buildReservationCard(
                  context,
                  courtName,
                  userName,
                  reservationDate,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, String courtName, String reserverNames, String reservationDate) {
    DateTime parsedDate = DateTime.parse(reservationDate);
    String formattedDate = "${parsedDate.toLocal().year}년 ${parsedDate.toLocal().month}월 ${parsedDate.toLocal().day}일";
    String formattedTime = "${parsedDate.toLocal().hour.toString().padLeft(2, '0')}:${parsedDate.toLocal().minute.toString().padLeft(2, '0')}";

    return Card(
      child: ListTile(
        leading: Image.asset('assets/images/ball.png', width: 50, height: 50),
        title: Text(
          courtName,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '예약자 이름: $reserverNames',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '예약 일자: $formattedDate',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '예약 시간: $formattedTime',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourtReservationDetailScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            '세부내용',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
