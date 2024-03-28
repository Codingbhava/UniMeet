import 'package:flutter/material.dart';
import 'package:unimeet/components/appbar.dart';

class JoinMeet extends StatefulWidget {
  const JoinMeet({super.key});

  @override
  State<JoinMeet> createState() => _JoinMeetState();
}

class _JoinMeetState extends State<JoinMeet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          BackBtn: () => Navigator.pop(context), title: Text("Join Meet")),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
