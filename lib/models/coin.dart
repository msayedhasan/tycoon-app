class Coin {
  final String? symbol;
  final String? asset;
  final String? price;
  final String? free;
  final String? locked;
  final double? usd;
  final String? lotSizeMinQty;
  final String? lotSizeMaxQty;
  final String? lotSizeStepSize;

  Coin({
    this.symbol,
    this.asset,
    this.price,
    this.free,
    this.locked,
    this.usd,
    this.lotSizeMinQty,
    this.lotSizeMaxQty,
    this.lotSizeStepSize,
  });

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
      symbol: map['symbol'] ?? '',
      asset: map['asset'] ?? '',
      price: map['price'] ?? '',
      free: map['free'] ?? '',
      locked: map['locked'] ?? '',
      usd: map['usd'],
      lotSizeMinQty: map['filters'] != null
          ? ((map['filters'] as List).firstWhere(
              (element) => element['filterType'] == 'LOT_SIZE')?['minQty'])
          : '',
      lotSizeMaxQty: map['filters'] != null
          ? ((map['filters'] as List).firstWhere(
              (element) => element['filterType'] == 'LOT_SIZE')?['maxQty'])
          : '',
      lotSizeStepSize: map['filters'] != null
          ? ((map['filters'] as List).firstWhere(
              (element) => element['filterType'] == 'LOT_SIZE')?['stepSize'])
          : '',
    );
  }
}
