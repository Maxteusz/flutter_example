class Coins_trading {
  late List<Coins> coins;

  Coins_trading({required this.coins});
  Coins_trading.fromJson(Map<String, dynamic> json) {
    var list = json['coins'] as List;
    List<Coins> imagesList = list.map((i) => Coins.fromJson(i)).toList();
    coins = imagesList;
    }

  }
class Coins {
  late Item item;

  Coins({required this.item});

  Coins.fromJson(Map<String, dynamic> json) {
    item =  new Item.fromJson(json['item']);
  }
}

class Item {
late String id;
late int coinId;
late String name;
late String symbol;
late int marketCapRank;
late String thumb;
late String small;
late String large;
late String slug;
late double priceBtc;
late int score;

  Item(
      {required this.id,
        required this.coinId,
        required this.name,
        required this.symbol,
        required this.marketCapRank,
        required this.thumb,
        required this.small,
        required this.large,
        required this.slug,
        required this.priceBtc,
        required this.score});



  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coinId = json['coin_id'];
    name = json['name'];
    symbol = json['symbol'];
    marketCapRank = json['market_cap_rank'];
    thumb = json['thumb'];
    small = json['small'];
    large = json['large'];
    slug = json['slug'];
    priceBtc = json['price_btc'];
    score = json['score'];

  }
}