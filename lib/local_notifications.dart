import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotifications {
  static Future init() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "UniMeet",
          channelName: "UniMeet",
          channelDescription: "Receive notification from UniMeet",
          playSound: true,
          channelShowBadge: true,
          enableVibration: true,
          enableLights: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
        )
      ],
      debug: true,
    );
  }

  static Future<void> myNotifyScheduleInHours({
    required DateTime dateTime,
    required String room,
    pass,
    heroThumbUrl,
    title,
    msg,
  }) async {
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        day: dateTime.day,
        hour: dateTime.hour,
        minute: dateTime.minute,
        repeats: false,
      ),
      content: NotificationContent(
        id: -1,
        channelKey: 'UniMeet',
        title: title,
        body: msg,
        bigPicture: heroThumbUrl,
        notificationLayout: NotificationLayout.BigPicture,
        color: Colors.black,
        backgroundColor: Colors.black,
        displayOnBackground: true,
        wakeUpScreen: true,
        badge: 1,
        payload: {'room': room, 'pass': pass},
      ),
    );
  }
}
