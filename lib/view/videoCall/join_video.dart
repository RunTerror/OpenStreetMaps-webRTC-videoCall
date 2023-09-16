import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video/view_model.dart/signaling.dart';

class JoinVideoCall extends StatefulWidget {
  const JoinVideoCall({super.key});

  @override
  State<JoinVideoCall> createState() => _JoinVideoCallState();
}

class _JoinVideoCallState extends State<JoinVideoCall> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  final textEditingController = TextEditingController();

    @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
   return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.blue,
                  ),
                  child: IconButton(
                      onPressed: () async {
                        await signaling.openUserMedia(
                            _localRenderer, _remoteRenderer);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                ),
                SizedBox(width: w/2,child: TextField(controller: textEditingController,),),
                SizedBox(
                  child: ElevatedButton(
                      onPressed: () async {
                        await signaling.joinRoom(textEditingController.text, _remoteRenderer);
                        setState(() {
                        });
                      },
                      child: const Text("Join")),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: h - 100,
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              Positioned(
                  bottom: 20,
                  right: 10,
                  height: 100,
                  child: SizedBox(
                    width: 100,
                    height: 200,
                    child: RTCVideoView(_localRenderer),
                  )),
              textEditingController.text.isEmpty?const SizedBox(): Positioned(
                  bottom: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.red),
                    child: IconButton(
                        onPressed: ()async {
                        await signaling.endRoom(textEditingController.text.trim());
                        if(mounted){
                           Navigator.of(context).pop();
                        }
                        },
                        icon: const Icon(Icons.phone)),
                  )),
              Positioned(
                right: w / 4,
                bottom: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.blue,
                  ),
                  child: IconButton(
                      onPressed: () async {
                        signaling.hangUp(_localRenderer);
                      },
                      icon: const Icon(
                        Icons.pause,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
              ],
            ),
        ));}
}