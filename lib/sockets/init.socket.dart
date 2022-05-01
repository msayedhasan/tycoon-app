// import 'package:influencers/config/config.dart';
// import 'package:influencers/sockets/sockets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/global.dart';
import './sockets.dart';

class InitSocketIO {
  static IO.Socket socket = IO.io(Globals.host, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  static initSocket() async {
    socket.connect();
    socket.on('connect', (_) {
      print('connected to socket io on server');
      socket.emit(
        SocketUtils.joinNotificationsRoom,
        Globals.user!.id,
      );
      socket.emit(
        SocketUtils.goOnline,
        Globals.user!.id,
      );
    });
    socket.on('connection', (_) {
      print('test');
    });
    print(socket.connected);
  }

  ///Singleton factory
  static final InitSocketIO _instance = InitSocketIO._internal();

  factory InitSocketIO() {
    return _instance;
  }

  InitSocketIO._internal();
}
