import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icondata;
  final TextEditingController controller;
  const CustomTextField({super.key,required this.hintText,required this.icondata, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(border:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), prefixIcon: Icon(icondata),hintText: hintText),
    );
  }
}