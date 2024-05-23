import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

// String selectedTitle = 'Location Map Test';

class LocationMap extends StatefulWidget {
  const LocationMap({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late KakaoMapController mapController;
  Set<Marker> markers = {}; // 마커 변수
  Position? _currentPosition;

  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentPosition(); // 초기 위치 정보 가져오기
  // }

  // Future<void> _getCurrentPosition() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       _currentPosition = position;
  //       _addMarker(); // 마커 추가 함수 호출
  //     });
  //   } catch (e) {
  //     print('Error getting location: $e');
  //     // 에러 처리 (예: 사용자에게 에러 메시지 표시)
  //   }
  // }

  // void _addMarker() {
  //   markers.add(Marker(
  //     markerId: UniqueKey().toString(),
  //     latLng: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        // appBar: AppBar(
        //   title: Text('마커 표시하기'),
        // ),
        // body: KakaoMap(
        //   onMapCreated: ((controller) {
        //     mapController = controller;
        //     // if (_currentPosition != null) {
        //     //   _addMarker();
        //     // }

        //     // markers.add(Marker(
        //     //   markerId: UniqueKey().toString(),
        //     //   latLng: await mapController.getCenter(),
        //     // )
        //     );
        //   }),
        //   markers: markers.toList(),
        //   center: LatLng(37.56682, 126.97865),

        // ),
        KakaoMap(
      onMapCreated: ((controller) async {
        mapController = controller;

        markers.add(Marker(
          markerId: UniqueKey().toString(),
          latLng: await mapController.getCenter(),
        ));

        setState(() {});
      }),
      markers: markers.toList(),
      center: LatLng(37.2845371, 127.0441352),
    );
  }
}
