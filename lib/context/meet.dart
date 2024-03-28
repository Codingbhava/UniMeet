import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:unimeet/database/read.dart';
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
          onOpened: () => debugPrint("onOpened"),
          onConferenceWillJoin: (url) {
            debugPrint("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            debugPrint("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            debugPrint("onConferenceTerminated: url: $url, error: $error");
          },
          onAudioMutedChanged: (isMuted) {
            debugPrint("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            debugPrint("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            debugPrint(
              "onScreenShareToggled: participantId: $participantId, "
              "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            debugPrint(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            debugPrint("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            debugPrint(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            debugPrint(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) =>
              debugPrint("onChatToggled: isOpen: $isOpen"),
          onClosed: () => debugPrint("onClosed"),
        ),
      );
    } catch (error) {
      print("error: $error");
    }
  }
}
