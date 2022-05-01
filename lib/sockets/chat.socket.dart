// import 'package:influencers/sockets/sockets.dart';

// import '../models/models.dart';
// import '../sockets/init.socket.dart';

// class ChatSocketIO {
//   static final socket = InitSocketIO.socket;

//   static openChat(openChatData) async {
//     socket.emit(
//       SocketUtils.openChat,
//       openChatData,
//     );
//   }

//   static newChatRecieved(Function chatRecieved) {
//     socket.on(SocketUtils.newChat, (data) {
//       chatRecieved(data);
//     });
//   }

//   static joinChat(chatId) async {
//     socket.emit(
//       SocketUtils.joinChat,
//       chatId,
//     );
//   }

//   static sendMessage(Message msg) {
//     socket.emit(
//       SocketUtils.sendMessage,
//       msg.toJson(),
//     );
//   }

//   static newMessageRecieved(Function messageRecieved) {
//     socket.on(SocketUtils.newMessage, (data) {
//       messageRecieved(data);
//     });
//   }

//   ///Singleton factory
//   static final ChatSocketIO _instance = ChatSocketIO._internal();

//   factory ChatSocketIO() {
//     return _instance;
//   }

//   ChatSocketIO._internal();
// }
