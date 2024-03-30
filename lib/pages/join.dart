import 'package:flutter/material.dart';
import 'package:unimeet/components/appbar.dart';
import 'package:unimeet/components/textfield.dart';
import 'package:unimeet/context/meet.dart';

class JoinMeet extends StatefulWidget {
  const JoinMeet({super.key});

  @override
  State<JoinMeet> createState() => _JoinMeetState();
}

class _JoinMeetState extends State<JoinMeet> {
  TextEditingController _roomid = TextEditingController();
  TextEditingController _pass = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _roomid.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          BackBtn: () => Navigator.pop(context), title: Text("Join Meet")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FieldForm(Label: "Room Id:", controller: _roomid, isPass: false),
              SizedBox(
                height: 10,
              ),
              FieldForm(Label: "Password :", controller: _pass, isPass: false),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            checkRoomAndCreateMeeting(_roomid.text.trim(),
                                _pass.text.trim(), context, false);
                          },
                          child: Text("Join Meet"))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
