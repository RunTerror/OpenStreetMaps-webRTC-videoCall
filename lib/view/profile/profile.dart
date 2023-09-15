import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/components/button.dart';
import 'package:video/components/custom_field.dart';
import 'package:video/provider/profile_provider.dart';
import 'package:video/utils/Routes/routenames.dart';
import 'package:video/utils/bars.dart/message_bars.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final profileprovider = Provider.of<ProfileProvider>(context);
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        width: w,
        height: h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                profileprovider.source(context);
              },
              child: CircleAvatar(
                backgroundImage: profileprovider.profile==null? null: FileImage(profileprovider.profile!),
                radius: w / 5,
                backgroundColor: theme.primaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: nameController,
              hintText: "Name",
              icondata: Icons.note,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () async {
                  if (profileprovider.profile == null) {
                    MessageBars.flushbarerror(
                        "Please Upload a profile image", context);
                  } else if (nameController.text.isEmpty) {
                    MessageBars.flushbarerror(
                        "Please Enter your name", context);
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .set({
                        "name": nameController.text.trim().toString(),
                      });
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(nameController.text.toString());
                      if (context.mounted) {
                        profileprovider.upLoadImage(context);
                        setState(() {
                          isLoading = false;
                        });
                      }
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                            context, RouteNames.homeScreen);
                      }
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      MessageBars.flushbarerror(e.message!, context);
                    }
                  }
                },
                child: CustomButoon(text: "Submit", isLoading: isLoading))
          ],
        ),
      ),
    );
  }
}
