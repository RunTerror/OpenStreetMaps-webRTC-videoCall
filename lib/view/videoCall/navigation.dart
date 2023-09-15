import 'package:flutter/material.dart';
import 'package:video/view/videoCall/join_video.dart';
import 'package:video/view/videoCall/video_call.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const VideoCall();
                }));
              },
              child: const Text("Start Call")),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const JoinVideoCall();
                }));
              },
              child: const Text("Join Call")),
              const Spacer(),
        ],
      ),
    ));
  }
}
