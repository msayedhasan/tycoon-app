class SocketUtils {
  static String joinNotificationsRoom = 'joinNotificationsRoom'; // send
  static String goOnline = 'goOnline'; // send

  static String getOnlineFriends = 'getOnlineFriends'; // send
  static String onlineFriends = 'onlineFriends'; // get

  static String openChat = 'openChat'; // send
  static String newChat = 'newChat'; // get
  static String joinChat = 'joinChat'; // send
  static String sendMessage = 'sendMessage'; // send
  static String newMessage = 'newMessage'; // get

  static String sendFeedRequest = 'sendFeedRequest';
  static String newFeedRequest = 'newFeedRequest';
  static String feedRequestSent = 'feedRequestSent';
  static String feedRequestFailed = 'feedRequestFailed';

  static String newContract = 'newContract';
  static String newContractRequest = 'newContractRequest';

  static String newNotification = 'newNotification';

  // singlton
  static final SocketUtils _instance = SocketUtils.internal();

  factory SocketUtils() => _instance;

  SocketUtils.internal();
}
