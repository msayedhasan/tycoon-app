import 'package:firebase_messaging/firebase_messaging.dart';

import './local_notification.dart';

class FirebaseNotification {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // static Future<String> getFcmToken() async {
  //   try {
  //     _firebaseMessaging.requestNotificationPermissions(
  //       const IosNotificationSettings(
  //         sound: true,
  //         badge: true,
  //         alert: true,
  //         provisional: false,
  //       ),
  //     );

  //     final fcmToken = await _firebaseMessaging.getToken() ?? '';
  //     if (fcmToken != '') {
  //       print('fcmToken success');
  //     }
  //     return fcmToken;
  //   } catch (err) {
  //     print(err);
  //     return '';
  //   }
  // }

  static Future<String> getFcmToken() async {
    try {
      messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        provisional: false,
      );

      final fcmToken = await messaging.getToken() ?? '';
      if (fcmToken != '') {
        print('fcmToken success');
      }
      return fcmToken;
    } catch (err) {
      print(err);
      return '';
    }
  }

  // static showNotification(context) async {
  //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //   print('firebase messaging configuration');
  //   _firebaseMessaging.configure(
  //     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
  //     // onBackgroundMessage: myBackgroundMessageHandler,
  //     // Called when the app is in the foreground and we recieve a notification
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('onMessage: $message');
  //       LocalNotification.showNotification(
  //         message['notification']['title'],
  //         message['notification']['body'],
  //       );
  //     },

  //     // Called when the app has been closed completely and it's opened from the push notification
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('onLaunch: $message');
  //       LocalNotification.showNotification(
  //         message['notification']['title'],
  //         message['notification']['body'],
  //       );
  //     },

  //     // Called when the app is in the background and it's opened from the push notification
  //     onResume: (Map<String, dynamic> message) async {
  //       print('onResume: $message');
  //       LocalNotification.showNotification(
  //         message['notification']['title'],
  //         message['notification']['body'],
  //       );
  //     },
  //   );
  // }
  static showNotification(context) async {
    print('firebase messaging configuration');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        LocalNotification.showNotification(
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });
    // messaging.configure(
    //   onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //   // onBackgroundMessage: myBackgroundMessageHandler,
    //   // Called when the app is in the foreground and we recieve a notification
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('onMessage: $message');
    //     LocalNotification.showNotification(
    //       message['notification']['title'],
    //       message['notification']['body'],
    //     );
    //   },

    //   // Called when the app has been closed completely and it's opened from the push notification
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onLaunch: $message');
    //     LocalNotification.showNotification(
    //       message['notification']['title'],
    //       message['notification']['body'],
    //     );
    //   },

    //   // Called when the app is in the background and it's opened from the push notification
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //     LocalNotification.showNotification(
    //       message['notification']['title'],
    //       message['notification']['body'],
    //     );
    //   },
    // );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      LocalNotification.showNotification(
        message['data']['title'],
        message['data']['body'],
      );
    }
    if (message.containsKey('notification')) {
      LocalNotification.showNotification(
        message['notification']['title'],
        message['notification']['body'],
      );
    }
  }

  ///Singleton factory
  static final FirebaseNotification _instance =
      FirebaseNotification._internal();

  factory FirebaseNotification() {
    return _instance;
  }

  FirebaseNotification._internal();
}
