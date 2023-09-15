import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageBars {
  
  static flushbarerror(String msg, BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    Flushbar(
                    maxWidth: w / 1.1,
                    flushbarPosition: FlushbarPosition.TOP,
                    message:
                        msg,
                    icon:const Icon(
                      Icons.info_outline,
                      size: 28.0,
                      color: Colors.red,
                    ),
                    duration: const Duration(seconds: 3),
                    leftBarIndicatorColor: Colors.red,
                  ).show(context);
  }

  static toastMessage(String toastmessage){
     Fluttertoast.showToast(
      webPosition: "right",
        msg: toastmessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
