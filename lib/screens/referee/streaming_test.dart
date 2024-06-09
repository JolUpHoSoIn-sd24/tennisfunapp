import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class StreamingTest extends StatefulWidget {
  const StreamingTest({super.key});

  @override
  State<StatefulWidget> createState() => _StreamingTestState();
}

class _StreamingTestState extends State<StreamingTest> {
  RTCPeerConnection? _peerConnection;
  final _localRenderer = RTCVideoRenderer();

  MediaStream? _localStream;

  RTCDataChannelInit? _dataChannelDict;
  RTCDataChannel? _dataChannel;
  final String transformType = "referee";

  // MediaStream? _localStream;
  bool _isStreaming = false;
  bool _isInferenceVideo = false;

  DateTime? _timeStart;

  bool _loading = false;

  void _onTrack(RTCTrackEvent event) {
    print("TRACK EVENT: ${event.streams.map((e) => e.id)}, ${event.track.id}");
    if (event.track.kind == "video") {
      print("HERE");
      if (_isInferenceVideo) {
        _localRenderer.srcObject = event.streams[0];
      }
      else {
        _localRenderer.srcObject = _localStream;
      }
    }
  }

  void _onDataChannelState(RTCDataChannelState? state) {
    switch (state) {
      case RTCDataChannelState.RTCDataChannelClosed:
        print("Camera Closed!!!!!!!");
        break;
      case RTCDataChannelState.RTCDataChannelOpen:
        print("Camera Opened!!!!!!!");
        break;
      default:
        print("Data Channel State: $state");
    }
  }

  Future<bool> _waitForGatheringComplete(_) async {
    print("WAITING FOR GATHERING COMPLETE");
    if (_peerConnection!.iceGatheringState ==
        RTCIceGatheringState.RTCIceGatheringStateComplete) {
      return true;
    } else {
      await Future.delayed(Duration(seconds: 1));
      return await _waitForGatheringComplete(_);
    }
  }

  void _toggleCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);
  }

  Future<void> _negotiateRemoteConnection() async {
    return _peerConnection!
        .createOffer()
        .then((offer) {
      return _peerConnection!.setLocalDescription(offer);
    })
        .then(_waitForGatheringComplete)
        .then((_) async {
      var des = await _peerConnection!.getLocalDescription();
      var headers = {
        'Content-Type': 'application/json',
      };
      var request = http.Request(
        'POST',
        Uri.parse(
            'http://34.64.135.47:8000/referee'), // CHANGE URL HERE TO LOCAL SERVER
      );
      request.body = json.encode(
        {
          "sdp": des!.sdp,
          "type": des.type,
          "video_transform": transformType,
        },
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String data = "";
      print(response);
      if (response.statusCode == 200) {
        data = await response.stream.bytesToString();
        var dataMap = json.decode(data);
        print(dataMap);
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(
            dataMap["sdp"],
            dataMap["type"],
          ),
        );
      } else {
        print(response.reasonPhrase);
      }
    });
  }

  Future<void> _makeCall() async {
    setState(() {
      _loading = true;
    });
    var configuration = <String, dynamic>{
      'sdpSemantics': 'unified-plan',
    };

    //* Create Peer Connection
    if (_peerConnection != null) return;
    _peerConnection = await createPeerConnection(
      configuration,
    );

    _peerConnection!.onTrack = _onTrack;
    // _peerConnection!.onAddTrack = _onAddTrack;

    //* Create Data Channel
    _dataChannelDict = RTCDataChannelInit();
    _dataChannelDict!.ordered = true;
    _dataChannel = await _peerConnection!.createDataChannel(
      "chat",
      _dataChannelDict!,
    );
    _dataChannel!.onDataChannelState = _onDataChannelState;
    // _dataChannel!.onMessage = _onDataChannelMessage;

    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'width': '1280',
          'height': '720',
          'frameRate': '30',
        },
        // 'facingMode': 'user',
        'facingMode': 'environment',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

      var videoTrack = stream.getVideoTracks().first;

      // _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      // _localRenderer.srcObject = _localStream;

      stream.getTracks().forEach((element) {
        _peerConnection!.addTrack(element, stream);
      });

      print("NEGOTIATE");
      await _negotiateRemoteConnection();
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _isStreaming = true;
      _loading = false;
    });
  }

  Future<void> _stopCall() async {
    try {
      // await _localStream?.dispose();
      await _dataChannel?.close();
      await _peerConnection?.close();
      _peerConnection = null;
      _localRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isStreaming = false;
    });
  }

  Future<void> initLocalRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    initLocalRenderers();
  }

  @override
  dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _localRenderer.dispose();
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
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: () {
                if (_isInferenceVideo) {
                  setState(() {
                    _isInferenceVideo = false;
                    _localRenderer.srcObject = _localStream;
                  });
                } else {
                  setState(() {
                    _isInferenceVideo = true;
                    _makeCall();
                  });
                }
              },
              child: Icon(Icons.switch_camera),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                if (_isStreaming) {
                  _stopCall();
                } else {
                  _makeCall();
                }
              },
              child: Icon(_isStreaming ? Icons.stop : Icons.videocam),
            ),
          ),
        ],

      ),
    );
  }
}