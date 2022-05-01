// import 'package:influencers/sockets/init.socket.dart';
// import 'package:influencers/sockets/sockets.dart';

// class FeedSocketIO {
//   static final socket = InitSocketIO.socket;

//   static sendRequest(data) async {
//     socket.emit(
//       SocketUtils.sendFeedRequest,
//       data,
//     );
//   }

//   static feedRequestSent(Function feedRequestSent) {
//     socket.on(SocketUtils.feedRequestSent, (userId) {
//       feedRequestSent(userId);
//     });
//   }

//   static feedRequestFailed(Function feedRequestFailed) {
//     socket.on(SocketUtils.feedRequestFailed, (data) {
//       feedRequestFailed(data);
//     });
//   }

//   static newFeedRequest(Function feedRequestRecieved) {
//     socket.on(SocketUtils.newFeedRequest, (userId) {
//       feedRequestRecieved(userId);
//     });
//   }

//   ///Singleton factory
//   static final FeedSocketIO _instance = FeedSocketIO._internal();

//   factory FeedSocketIO() {
//     return _instance;
//   }

//   FeedSocketIO._internal();
// }
