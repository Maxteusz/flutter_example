class CoinMarket {
  late String id;
  late String symbol;
  late String name;
  late String image;
  late double currentPrice;
  late double priceChangePercentage24h;
  late double priceChange24h;


  CoinMarket({required this.id,
    required this.symbol,
    required this.name,
    required this.image,
  required this.currentPrice,
  required this.priceChangePercentage24h,
  required this.priceChange24h});

  CoinMarket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
    image = json['image'];
    currentPrice = json['current_price'] == null ? 0.0 : json['current_price'].toDouble();
    priceChangePercentage24h = json['price_change_percentage_24h'] == null ? 0.0 : json['price_change_percentage_24h'].toDouble();
    priceChange24h = json['price_change_24h'] == null ? 0.0 : json['price_change_24h'].toDouble();


  }
}