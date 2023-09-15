import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video/view_model.dart/signaling.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
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
              Text(roomId ?? ''),
              SizedBox(
                child: ElevatedButton(
                    onPressed: () async {
                      roomId = await signaling.createRoom(_remoteRenderer);
                      setState(() {});
                    },
                    child: const Text("Start Call")),
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
            roomId==null?SizedBox(): Positioned(
                bottom: 20,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.red),
                  child: IconButton(
                      onPressed: ()async {
                      await signaling.endRoom(roomId!);
                      if(mounted){
                         Navigator.of(context).pop();
                      }
                      },
                      icon: const Icon(Icons.mic)),
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
    ));
  }
}



// Column(
//         children: [
//           const SizedBox(height: 8),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: ()async {
//                  await signaling.openUserMedia(_localRenderer, _remoteRenderer);
//                  setState(() {
//                  });
//                 },
//                 child:const Text("Open camera & microphone"),
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   roomId = await signaling.createRoom(_remoteRenderer);
//                   textEditingController.text = roomId!;
//                   setState(() {});
//                 },
//                 child:const Text("Create room"),
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add roomId
//                   signaling.joinRoom(
//                     textEditingController.text.trim(),
//                     _remoteRenderer,
//                   );
//                 },
//                 child:const Text("Join room"),
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   signaling.hangUp(_localRenderer);
//                 },
//                 child: const Text("Hangup"),
//               ),
//                ElevatedButton(
//                 onPressed: () {
//                   signaling.endRoom();
//                 },
//                 child: const Text("End Call"),
//               )
//             ],
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
//                   Expanded(child: RTCVideoView(_remoteRenderer)),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Join the following Room: "),
//                 Flexible(
//                   child: TextFormField(
//                     controller: textEditingController,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(height: 8)
//         ],
//       ),