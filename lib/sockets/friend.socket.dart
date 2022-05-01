// import 'package:influencers/config/config.dart';
// import 'package:influencers/sockets/init.socket.dart';
// import 'package:influencers/sockets/sockets.dart';

// class FriendSocketIO {
//   static final socket = InitSocketIO.socket;

//   static getOnlineFriends() async {
//     socket.emit(
//       SocketUtils.getOnlineFriends,
//       Globals.user.id,
//     );
//   }

//   static onlineFriendsReceived(Function friendsReceived) async {
//     socket.on(SocketUtils.onlineFriends, (onlineFriendsChat) {
//       List<String> onlineFriendsIds = [];
//       for (var i = 0; i < onlineFriendsChat.length; i++) {
//         onlineFriendsIds.add(onlineFriendsChat[i]['friend']);
//       }

//       friendsReceived(onlineFriendsIds);
//     });
//   }

//   ///Singleton factory
//   static final FriendSocketIO _instance = FriendSocketIO._internal();

//   factory FriendSocketIO() {
//     return _instance;
//   }

//   FriendSocketIO._internal();
// }
