import 'package:tycoon/models/trade.dart';

class User {
  final String? id;
  String? name;

  final bool? locked;
  List<String>? loginMethods;

  final bool? admin;
  int? budget;
  List? orders;
  String? apiKey;
  String? apiSecret;

  String? fcmToken;

  User({
    this.id,
    this.name,
    this.loginMethods,
    this.locked,
    this.admin,
    this.fcmToken,
    this.budget,
    this.orders,
    this.apiKey,
    this.apiSecret,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      loginMethods: json['methods'] != null
          ? List<String>.from(json['methods'].map((x) => x))
          : [],
      locked: json['locked'] ?? false,
      admin: json['admin'] ?? false,
      fcmToken: json['fcmToken'] ?? '',
      budget: json['budget'] ?? 0,
      orders: json['trades'] != null
          ? List<Trade>.from(
              json["trades"].map(
                (x) => Trade.fromMap(x),
              ),
            )
          : [],
      apiKey: json['apiKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fcmToken': fcmToken,
      'budget': budget,
      'apiKey': apiKey,
      'apiSecret': apiSecret,
    };
  }
}
