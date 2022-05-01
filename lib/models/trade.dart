class Trade {
  final String? id;
  final String? ticker;
  final String? createdAt;
  final bool? active;
  final bool? completed;
  final bool? failed;
  final double? profit;
  final double? percentage;
  final List<Order>? orders;
  final bool? canceled;
  final String? canceledAt;

  Trade({
    this.id,
    this.ticker,
    this.createdAt,
    this.active,
    this.completed,
    this.failed,
    this.profit,
    this.percentage,
    this.orders,
    this.canceled,
    this.canceledAt,
  });

  factory Trade.fromMap(Map<String, dynamic> json) {
    return Trade(
      id: json['_id'] ?? "",
      ticker: json['ticker'] ?? '',
      createdAt: json['createdAt'] ?? '',
      active: json['active'] ?? false,
      completed: json['completed'] ?? false,
      failed: json['failed'] ?? false,
      profit: json['profit'],
      percentage: json['percentage'],
      orders: json['orders'] != null
          ? List<Order>.from(
              json["orders"].map(
                (x) => Order.fromMap(x),
              ),
            )
          : [],
      canceled: json['canceled'] ?? false,
      canceledAt: json['canceledAt'] ?? '',
    );
  }
}

class Order {
  final String? id;
  final String? ticker;
  final int? orderId;
  final String? price;
  final String? qty;
  final String? type;
  final String? side;
  final bool? active;
  final bool? canceled;
  final String? canceledAt;
  final String? createdAt;

  Order({
    this.id,
    this.ticker,
    this.orderId,
    this.price,
    this.qty,
    this.type,
    this.side,
    this.active,
    this.canceled,
    this.canceledAt,
    this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? "",
      orderId: map['orderId'] ?? '',
      ticker: map['ticker'] ?? '',
      price: map['price'] ?? '',
      qty: map['qty'] ?? '',
      type: map['type'] ?? '',
      side: map['side'] ?? '',
      active: map['active'] ?? false,
      canceled: map['canceled'] ?? false,
      canceledAt: map['canceledAt'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
