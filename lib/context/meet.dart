import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:unimeet/database/delete.dart';
import 'package:unimeet/database/read.dart';
import 'package:unimeet/database/update.dart';
import 'package:unimeet/database/write.dart';

class JitsiMeetMethods {
  void createMeeting({
    required String roomName,
    required bool isCreate,
    String username = '',
  }) async {
    try {
      Map<String, Object> featureFlags = {};
      Map<String, Object> configOverrides = {};
      String? name;
      if (username.isEmpty) {
        name = LogUser!.displayName;
      } else {
        name = username;
      }
      var options = JitsiMeetingOptions(
        userAvatarUrl: LogUser?.photoURL,
        configOverrides: configOverrides,
        roomNameOrUrl: roomName,
        serverUrl: "https://allo.bim.land",
        isAudioMuted: true,
        isVideoMuted: true,
        userDisplayName: name,
        userEmail: LogUser?.email,
        featureFlags: featureFlags,
      );
      addToMeetingHistory(roomName, isCreate);
      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
            onOpened: () => print("onOpened"),
            onConferenceWillJoin: (url) {
              print("onConferenceWillJoin: url: $url");
            },
            onConferenceJoined: (url) {
              print("onConferenceJoined: url: $url");
            },
            onConferenceTerminated: (url, error) {
              print("onConferenceTerminated: url: $url, error: $error");
            },
            onAudioMutedChanged: (isMuted) {
              print("onAudioMutedChanged: isMuted: $isMuted");
            },
            onVideoMutedChanged: (isMuted) {
              print("onVideoMutedChanged: isMuted: $isMuted");
            },
            onScreenShareToggled: (participantId, isSharing) {
              print(
                "onScreenShareToggled: participantId: $participantId, "
                "isSharing: $isSharing",
              );
            },
            onParticipantJoined: (email, name, role, participantId) {
              print(
                "onParticipantJoined: email: $email, name: $name, role: $role, "
                "participantId: $participantId",
              );
            },
            onParticipantLeft: (participantId) {
              print("onParticipantLeft: participantId: $participantId");
            },
            onParticipantsInfoRetrieved: (participantsInfo, requestId) {
              print(
                "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
                "requestId: $requestId",
              );
            },
            onChatMessageReceived: (senderId, message, isPrivate) {
              print(
                "onChatMessageReceived: senderId: $senderId, message: $message, "
                "isPrivate: $isPrivate",
              );
            },
            onChatToggled: (isOpen) => print("onChatToggled: isOpen: $isOpen"),
            onClosed: () {
              if (isCreate) {
                UpdateUser({'close': true, 'create': false}, LogUser!.uid);
                DeleteMeeting(roomName);
              } else {
                UpdateUser({'close': true}, LogUser!.uid);
              }
            }),
      );
    } catch (error) {
      print("error: $error");
    }
  }
}

final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
createNewMeeting() async {
  var random = Random();
  bool roomExists = true;
  String room = '0';
  String pass = '0';

  while (roomExists) {
    room = (random.nextInt(10000000) + 10000000).toString();
    pass = (random.nextInt(10000000) + 10000000).toString();

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('CurrentMeet')
        .doc(room)
        .get();

    if (!snapshot.exists) {
      roomExists = false;
    }
  }

  await UpdateUser({'room': room, 'pass': pass, 'close': false, 'create': true},
      LogUser!.uid);
  CreateMeeting(room, pass, false);
  _jitsiMeetMethods.createMeeting(roomName: room, isCreate: true);
}

Future<void> checkRoomAndCreateMeeting(
    String room, String pass, BuildContext context, bool schedule) async {
  if (schedule) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('CurrentMeet')
          .doc(room)
          .get();

      if (snapshot.exists) {
        UpdateMeet({'isScheduled': false}, room);
        _jitsiMeetMethods.createMeeting(roomName: room, isCreate: true);
      } else {
        // Room doesn't exist, show appropriate message
        showDialog(
          context: context, // Assuming you have access to context
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Room is Scheduled by other"),
              content:
                  Text("The room you entered it Scheduled, try sometime later"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
      // Handle any errors occurred during data retrieval
    }
  } else {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('CurrentMeet')
          .doc(room)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String storedPass = data['pass'];
        bool isScheduled = data['isScheduled'];
        if (storedPass == pass) {
          if (isScheduled) {
            showDialog(
              context: context, // Assuming you have access to context
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Room is Scheduled by other"),
                  content: Text(
                      "The room you entered it Scheduled, try sometime later"),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          } else {
            // Password matches, create the meeting
            _jitsiMeetMethods.createMeeting(roomName: room, isCreate: false);
          }
        } else {
          // Password doesn't match, show appropriate message
          showDialog(
            context: context, // Assuming you have access to context
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Incorrect Password"),
                content: Text("The password for this room is incorrect."),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Room doesn't exist, show appropriate message
        showDialog(
          context: context, // Assuming you have access to context
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Room not Exist"),
              content: Text("The room you entered it not Exist"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
      // Handle any errors occurred during data retrieval
    }
  }
}
