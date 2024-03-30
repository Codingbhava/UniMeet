import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:unimeet/components/appbar.dart';
import 'package:unimeet/components/textfield.dart';
import 'package:unimeet/context/meet.dart';
import 'package:unimeet/database/read.dart';
import 'package:unimeet/database/update.dart';
import 'package:unimeet/database/write.dart';
import 'package:unimeet/local_notifications.dart';

class Scheduled extends StatefulWidget {
  const Scheduled({Key? key}) : super(key: key);

  @override
  State<Scheduled> createState() => _ScheduledState();
}

class _ScheduledState extends State<Scheduled> {
  late DateTime selectedDateTime;
  TextEditingController payloadController = TextEditingController();
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
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
    selectedDateTime = DateTime.now();
    super.initState();
  }

  Future<void> onActionReceivedMethod(receivedNotification) async {
    if (receivedNotification.channelKey == 'UniMeet') {
      // Extracting payload data
      Map<String, dynamic> payload = receivedNotification.payload!;
      String? room = payload['room'];
      String? pass = payload['pass'];
      checkRoomAndCreateMeeting(room!, pass!, context, true);
    }
  }

  void scheduleNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;
    String room = _roomid.text.trim();
    String pass = _pass.text.trim();
    await UpdateUser(
        {'room': room, 'pass': pass, 'close': false, 'create': true},
        LogUser!.uid);
    CreateMeeting(room, pass, true);
    LocalNotifications.myNotifyScheduleInHours(
      title: 'Unimeet ',
      msg: 'Reminder for meeting scheduled',
      heroThumbUrl:
          'https://static-00.iconduck.com/assets.00/google-meet-icon-884x1024-aoedzuv2.png',
      dateTime: selectedDateTime,
      room: room,
      pass: pass,
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTime = combinedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        BackBtn: () => Navigator.pop(context),
        title: Text("Scheduled Meet"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Select Date & Time"),
              subtitle: Text(selectedDateTime.toString()),
              onTap: () => _selectDateTime(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FieldForm(
                      Label: "Room Id:", controller: _roomid, isPass: false),
                  SizedBox(
                    height: 10,
                  ),
                  FieldForm(
                      Label: "Password :", controller: _pass, isPass: false),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: scheduleNotification,
                              child: Text("Schedule Meeting"))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
