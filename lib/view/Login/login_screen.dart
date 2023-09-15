import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../utils/bars.dart/message_bars.dart';
import '../Verification/otpverification.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,

      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: h,
        width: w,
        child: Column(
          children: [
            SizedBox(
              height: h / 3,
            ),
            IntlPhoneField(
              controller: phoneController,
              initialCountryCode: "IN",
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                var number = phoneController.text.trim();
                if (number.length < 10) {
                  MessageBars.flushbarerror(
                      "Please enter 10 digit phone number", context);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  FirebaseAuth.instance
                      .verifyPhoneNumber(
                          phoneNumber: '+91 $number',
                          verificationCompleted: (_) {
                            setState(() {
                              isLoading=false;
                            });
                          },
                          verificationFailed: (e) {
                            setState(() {
                              isLoading=false;
                            });
                            MessageBars.flushbarerror(e.message!, context);
                          },
                          codeSent: (String id, int? code) {
                            setState(() {
                              isLoading=false;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return VerifyScreen(id: id, number: number);
                            }));
                          },
                          codeAutoRetrievalTimeout: (String code) {
                            setState(() {
                              isLoading=false;
                            });
                          })
                      .then((value) {
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: h / 18,
                width: w / 1.2,
                child: isLoading
                    ? Center(
                        child: SizedBox(
                            height: h / 25,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            )))
                    : const Center(
                        child: Text(
                        "verify",
                        style: TextStyle(color: Colors.white),
                      )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
