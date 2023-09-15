import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video/components/button.dart';
import 'package:video/utils/Routes/routenames.dart';
import 'package:video/utils/bars.dart/message_bars.dart';

class VerifyScreen extends StatefulWidget {
  final String id;
  final String number;
  const VerifyScreen({super.key, required this.id, required this.number});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  Future<bool> checkDocument(String collection, String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(uid)
          .get();
      return documentSnapshot.exists;
    } catch (e) {
      MessageBars.flushbarerror("Create profile page", context);
      return false;
    }
  }

  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              controller: textEditingController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () async {
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.id,
                      smsCode: textEditingController.text.trim());
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    bool ifExist = await checkDocument("users", uid);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          ifExist == true
                              ? RouteNames.homeScreen
                              : RouteNames.profile,
                          (route) => false);
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    MessageBars.flushbarerror("Enter correct otp", context);
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color: theme.primaryColor),
                    child: isLoading == false
                        ? const Text("Verify",
                            style: TextStyle(color: Colors.white))
                        : const CircularProgressIndicator()))
          ],
        ),
      ),
    );
  }
}
