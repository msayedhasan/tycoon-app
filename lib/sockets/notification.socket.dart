import './init.socket.dart';
import './sockets.dart';

class NotificationSocketIO {
  static final socket = InitSocketIO.socket;

  static newNotification(Function notificationRecieved) {
    socket.on(SocketUtils.newNotification, (notificationData) {
      notificationRecieved(notificationData);
    });
  }

  ///Singleton factory
  static final NotificationSocketIO _instance =
      NotificationSocketIO._internal();

  factory NotificationSocketIO() {
    return _instance;
  }

  NotificationSocketIO._internal();
}
