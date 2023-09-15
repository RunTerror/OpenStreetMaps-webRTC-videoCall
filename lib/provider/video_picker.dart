import 'dart:io';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video/utils/Routes/routenames.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video/utils/bars.dart/message_bars.dart';

class VideoPickerProvider with ChangeNotifier {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;
  File? _pickedvideo;
  File? get pickedvideo => _pickedvideo;


  final picker = ImagePicker();

  pickVideo(BuildContext context) async {
    final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Video",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            actions: [
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
                leading: const Icon(Icons.photo_camera),
                title: const Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
              )
            ],
          );
        });
    if (source != null) {
      final video = await picker.pickVideo(source: source);
      if (video != null) {
        _pickedvideo = File(video.path);
          notifyListeners();
          if (context.mounted) {
          Navigator.pushNamed(context, RouteNames.postScreen,
              arguments: {"pickedvideo": pickedvideo});
        }
        else{
          MessageBars.flushbarerror("null", context);
        }
        }
      }
    }
  }



 
