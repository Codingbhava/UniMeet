import 'package:unimeet/constants/data.dart';
import 'package:flutter/material.dart';

class FieldForm extends StatelessWidget {
  final String Label;
  final controller;
  final bool isPass;
  FieldForm(
      {super.key,
      required this.Label,
      required this.controller,
      required this.isPass});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        obscureText: isPass,
        decoration: InputDecoration(
          labelText: Label,
          labelStyle: TextStyle(color: text, fontWeight: FontWeight.w600),
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: text, width: 1),
            borderRadius: BorderRadius.circular(Radius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accent, width: 1),
            borderRadius: BorderRadius.circular(Radius),
          ),
        ),
      ),
    );
  }
}
