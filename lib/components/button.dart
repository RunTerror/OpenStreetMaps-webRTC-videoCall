import 'package:flutter/material.dart';

class CustomButoon extends StatelessWidget {
  final String text;
  final bool isLoading;

  const CustomButoon({super.key, required this.text, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
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
          : Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
