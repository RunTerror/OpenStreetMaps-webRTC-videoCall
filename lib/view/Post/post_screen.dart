import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:video/provider/video_picker.dart';
import 'package:video/utils/bars.dart/message_bars.dart';
import 'package:video_compress/video_compress.dart';

import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../components/button.dart';
import '../../components/custom_field.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  VideoPlayerController? videoController;
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController cateogryController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  var position;

  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      MessageBars.toastMessage("Location permission denied");
      await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  uploadVideo(String title, String description, String cateogry,
      Position location, String path) async {
    final thumbnailFile =
        await VideoCompress.getFileThumbnail(path, quality: 50, position: -1);

    final now = DateTime.now().millisecond.toString();

    //uploading video
    firebase_storage.Reference storageRef =
        storage.ref('Videos/${currentUser.uid + now}');
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(path).absolute);
    await Future.value(uploadTask);
    final downloadedUrl = await storageRef.getDownloadURL();

    // uploading thumbnail
    firebase_storage.Reference thumbnailrefrence =
        storage.ref('Thumbnail/${currentUser.uid + now}');
    firebase_storage.UploadTask uploadThumbnail =
        thumbnailrefrence.putFile(File(thumbnailFile.path).absolute);
    await Future.value(uploadThumbnail);
    final thumbnail = await thumbnailrefrence.getDownloadURL();

    // updating video details in firebase database
    await FirebaseFirestore.instance.collection('videos').add({
      "title": title,
      "description": description,
      "cateogry": cateogry,
      "location": {
        "latitude": location.latitude.toString(),
        "longitude": location.longitude.toString()
      },
      "videoUrl": downloadedUrl,
      "name": currentUser.displayName,
      "date": DateTime.now(),
      "imageUrl": currentUser.photoURL,
      "thumbnail": thumbnail
    }).then((value) {
      MessageBars.toastMessage("Posted!");
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, File?>;
    final videoProvider =
        Provider.of<VideoPickerProvider>(context, listen: false);
    final file = args['pickedvideo'];

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
        ),
        body: Container(
          padding: EdgeInsets.only(
              top: 20,
              left: (w - w / 1.3) / 2,
              right: (w - w / 1.3) / 2,
              bottom: 20),
          height: h,
          width: w,
          child: ListView(
            children: [
            file==null?const  Text("No video selected"):  VideoPlayerWidget(file.path),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  hintText: "Title",
                  icondata: Icons.title,
                  controller: titleController),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  hintText: "description",
                  icondata: Icons.note,
                  controller: detailsController),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  hintText: "Cateogry",
                  icondata: Icons.category_rounded,
                  controller: cateogryController),
              const SizedBox(
                height: 20,
              ),
              position == null
                  ? FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: const Row(children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Fetching Current Location.....")
                              ]));
                        } else {
                          final coordinates = snapshot.data;
                          return Column(
                            children: [
                              ListTile(
                                title: Text(coordinates.toString()),
                                leading: const Icon(Icons.location_on),
                              ),
                            ],
                          );
                        }
                      },
                      future: determinePosition(),
                    )
                  : ListTile(
                      title: Text(position.toString()),
                      leading: const Icon(Icons.location_on),
                    ),
              InkWell(
                  onTap: () async {
                    try {
                      if (titleController.text.trim().isEmpty ||
                          detailsController.text.trim().isEmpty ||
                          cateogryController.text.trim().isEmpty ||
                          position == null) {
                        MessageBars.flushbarerror(
                            "Please complete all field first", context);
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await uploadVideo(
                            titleController.text.trim(),
                            detailsController.text.trim(),
                            cateogryController.text.trim(),
                            position,
                            videoProvider.pickedvideo!.path);
                      }
                    } on FirebaseException catch (e) {
                       MessageBars.flushbarerror(e.message!, context);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: CustomButoon(text: "Upload", isLoading: isLoading))
            ],
          ),
        ));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget(this.videoPath, {super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
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
      ],
    );
  }
}
