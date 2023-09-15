import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:video/utils/bars.dart/message_bars.dart';

class ProfileProvider with ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _profile;
  File? get profile => _profile;

  ImagePicker picker = ImagePicker();

  source(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select profile"),
          actions: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title:const Text("Camera"),
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title:const Text("Gallery"),
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  pickImage(ImageSource source) async {
    final pickedfile = await picker.pickImage(source: source);
    if (pickedfile != null) {
      _profile = File(pickedfile.path);
      notifyListeners();
    }
  }

  upLoadImage(BuildContext context) async {
    firebase_storage.Reference storageRef =
        storage.ref('/profileImage${user!.uid}');
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(profile!.path).absolute);
    await Future.value(uploadTask);
    final newUrl = await storageRef.getDownloadURL();
    await user!.updatePhotoURL(newUrl);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({"profileUrl": newUrl})
        .onError((error, stackTrace) =>
            MessageBars.flushbarerror(error.toString(), context))
        .then((value) {MessageBars.toastMessage("Profile Uploaded!");});
  }
}
