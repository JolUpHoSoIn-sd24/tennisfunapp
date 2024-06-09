import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

class AiRefereeStreaming extends StatefulWidget {
  const AiRefereeStreaming({super.key});

  @override
  State<StatefulWidget> createState() => _AiRefereeStreamingState();
}

class _AiRefereeStreamingState extends State<AiRefereeStreaming> {
  late MediaStream _localStream;
  late RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    initRenderers();
    debugPrint("initState");
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.deactivate();
    if (_isStreaming) {
      _localStream.getVideoTracks()[0].stop();
    }
    _localRenderer.dispose();
  }

  // method that return current time
  String _currentTime() {
    return DateTime.now().toString();
  }

  Future<void> _startStreaming() async {

    final map = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '1280', // 최소 너비
          'minHeight': '720', // 최소 높이
          'minFrameRate': '60', // 최소 프레임 rate
        },
        'facingMode': 'environment', // 후면 카메라 고정
        'optional': [],
      }
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(map);
    } catch(e) {
      print(e);
      // 후면 카메라 없으면 전면 카메라 사용
      _localStream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': false});
    }

    _localRenderer.srcObject = _localStream;

    setState(() {
      _isStreaming = true;
      print("is print working?");
    });

    // _streamToServer() 호출 추가
    await _streamToServer();
    debugPrint("why?");
  }

  Future<void> _streamToServer() async {
    http.StreamedResponse response = await http.Client().send(http.StreamedRequest('POST', Uri.parse("http://34.64.135.47:8080/referee")));
    debugPrint("strat streamToServer");

    response.stream.listen((data) async {
      print("in listen");
      // raw 데이터를 파일로 저장
      File file = File('temp.jpg');
      file.writeAsBytes(data, flush: true);

      // 파일 읽어서 base64 encoding
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      // 서버 전송
      var temp_response = await http.post(
        Uri.parse("http://34.64.135.47:8080/referee"),
        body: {
          "image": base64Image,
          "time": _currentTime(),
        },
      );
      debugPrint('Response status: ${temp_response.statusCode}');
      debugPrint('Response body: ${temp_response.body}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Referee Streaming')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              margin: EdgeInsets.all(0.0),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: RTCVideoView(_localRenderer),
              decoration: BoxDecoration(color: Colors.black54),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isStreaming) {
            _localStream.getVideoTracks()[0].stop();
            setState(() {
              _isStreaming = false;
            });
          } else {
            _startStreaming();
          }
        },
        child: Icon(_isStreaming ? Icons.stop : Icons.videocam),
      ),
    );
  }
}