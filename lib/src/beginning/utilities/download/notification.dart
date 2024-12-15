import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

downloadNotificationInit() async {
  await AwesomeNotifications().initialize(
    'resource://drawable/phoenix_awaken',
    [
      NotificationChannel(
        channelKey: 'phoenix_download',
        channelName: 'Phoenix Download',
        channelDescription: 'Phoenix Visualizer Running Alert',
        enableLights: false,
        enableVibration: false,
        importance: NotificationImportance.Default,
        playSound: false,
      ),
    ],
  );
}

startDownloadNotification(List saavnObjs) async {
  saavnObjs.removeWhere((item) => item == null);
  AwesomeNotifications().isNotificationAllowed().then(
    (isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    },
  );
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 40,
      channelKey: 'phoenix_download',
      locked: true,
      title: 'Phoenix Downloading Music',
      body: '',
      backgroundColor: Colors.black,
    ),
  );
}

stopDownloadNotification() async {
  await AwesomeNotifications().dismiss(40);
}
