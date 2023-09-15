import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetails extends StatelessWidget {
  const VideoDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
        ),
        body: 
          VideoPlayerWidget(data: args,));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final Map<String, dynamic> data;

 const VideoPlayerWidget({super.key, required this.data});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.data['videoUrl']))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

   String calculateTimeAgo(Timestamp dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime.toDate());

    if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.only(bottom: 20,left: 20,right: 20,top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: VideoPlayer(_videoController)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _videoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_videoController.value.isPlaying) {
                          _videoController.pause();
                        } else {
                          _videoController.play();
                        }
                      });
                    },
                  ),
                ],
              ),
              Text('Days ago: ${calculateTimeAgo(widget.data['date'])}', style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              Text('Name: ${widget.data['name']}', style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              Text('cateogry: ${widget.data['cateogry']}', style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              const Text('location:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
              Text('longitude: ${widget.data['location']['longitude']}', style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              Text('latitude: ${widget.data['location']['latitude']}', style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              const Text('Description:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
              Text('${widget.data['description']}', style:const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,maxLines: 20,),

            ],
        ),
      ),
    );
  }
}
