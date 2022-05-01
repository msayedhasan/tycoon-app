class Images {
  static const String Splash = "assets/images/splash.png";
  static const String Launch = "assets/images/launch.png";
  static const String Icon = "assets/images/icon.png";
  static const String Background = "assets/images/background.jpg";
  static const String Avatar = "assets/images/avatar.jpg";
  static const String Placeholder = "assets/images/placeholder.png";
  static const String LOGO = "assets/images/logo.png";
  static const String Facebook = "assets/images/facebook.jpg";
  static const String Google = "assets/images/google.jpg";
  static const String Apple = "assets/images/apple.jpg";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
