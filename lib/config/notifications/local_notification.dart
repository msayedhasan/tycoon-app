import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initialize() async {
    var androidSettings = const AndroidInitializationSettings('app_icon');

    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(
            alert: false,
            badge: true,
            sound: true,
          );
    }

    var iosSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: (
        int? id,
        String? title,
        String? body,
        String? payload,
      ) async {
        print(payload);
        showNotification(title!, body!);
      },
    );

    var settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    flutterLocalNotificationsPlugin.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  static showNotification(String title, String body) async {
    var android = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var ios = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platform = new NotificationDetails(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: 'Default_Sound',
    );
  }

  static void onSelectNotification(String? payload) async {
    print(payload);
    await flutterLocalNotificationsPlugin.cancelAll();
    ;
  }

  ///Singleton factory
  static final LocalNotification _instance = LocalNotification._internal();

  factory LocalNotification() {
    return _instance;
  }

  LocalNotification._internal();
}
