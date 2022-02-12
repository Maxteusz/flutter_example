import 'dart:convert';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:queris_zadanie/coin_market.dart';
import 'dart:convert';

import 'coins_trading.dart';





void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,

      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Coins> coins_trading = [];
  List<CoinMarket> coins_market = [];
  int _set_page = 1;
  late Future<List<Coins>> futureCoins;
  late Future<List<CoinMarket>> futureCoinsMarket;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String title = "Home";



  @override
  void initState() {
    futureCoins = fetchCoins();
    futureCoinsMarket = fetchCoinsMarket();
    super.initState();
  }

  Future<List<Coins>> fetchCoins() async {
try {
  final response = await http.get(
      Uri.parse('https://api.coingecko.com/api/v3/search/trending'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  if (response.statusCode == 200) {
    var  map = json.decode(response.body);
    //List<dynamic> data = map["coins"];
    //List<Coin> wel = map.map((e) => Coin.fromJson(e)).toList();
    Coins_trading wel = new Coins_trading.fromJson(json.decode(response.body));
    print(json.decode(response.body)['coins'].toString());
    coins_trading = wel.coins;
    return coins_trading;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to list Suit');
  }
}
catch (e) {
  print(e);
  return coins_trading;
}
  }

  Future<List<CoinMarket>> fetchCoinsMarket() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        coins_market = body.map((e) => CoinMarket.fromJson(e)).toList();
        print(coins_market.length.toString());
        return coins_market;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to list Suit');
      }
    }
    catch (e) {
      print(e);
      return coins_market;
    }
  }

  Future<Null> refreshCoinsList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      futureCoins = fetchCoins();
    });
    return null;
  }

  Future<Null> refreshCoinMarketList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      futureCoinsMarket = fetchCoinsMarket();
    });
    return null;
  }


  @override
  Widget build(BuildContext context) {
    const double icon_size = 30;
    const Color active_button_colors = Colors.blue;
    const Color deactive_button_colors = Colors.grey;


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: 20),
        child:Text(title,
        style: TextStyle(
          color: Colors.black,
              fontWeight: FontWeight.bold
        ))),

        backgroundColor: Colors.white,

      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add), onPressed: () {
          setState(() {

          });
      },),

      bottomNavigationBar: SizedBox(
    height: 70,
       child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[

               IconButton(icon: Icon(Icons.home), onPressed: () {
                 setState(() {
                   _set_page = 1;
                   //futureCoinsMarket = fetchCoinsMarket();
                   title = "Home";
                 });
               },
                 color: _set_page == 1 ? active_button_colors: deactive_button_colors,
                iconSize: icon_size,),

               Container(
                 margin: EdgeInsets.only(right: 100),
               child: IconButton(icon: Icon(Icons.pie_chart), onPressed: () {
                 setState(() {
                   _set_page = 2;
                   //futureCoins = fetchCoins();
                   title = "Markets";

                 });
               },
                 color: _set_page == 2 ? active_button_colors: deactive_button_colors,
                iconSize: icon_size,

               )

            ),
               IconButton(icon: Icon(Icons.show_chart), onPressed: () {
                 setState(() {
                   _set_page = 3;
                   title = "";
                 });
               },
                iconSize: icon_size,
                 //color: _set_page == 3 ? active_button_colors: _set_page == 2 ? Colors.amber: Colors.black
                  color: _set_page == 3 ? active_button_colors: deactive_button_colors,
              ),

               IconButton(icon: Icon(Icons.doorbell), onPressed: () {
                 setState(() {
                   _set_page = 4;
                   coins_trading.clear();
                   coins_market.clear();

                 });
               },
                 color: _set_page == 4 ? active_button_colors: deactive_button_colors,
                iconSize: icon_size,

            ),
          ],
        ),
      )),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _set_page == 2 ?
        RefreshIndicator(child:
        Container(
    child: FutureBuilder<List<CoinMarket>>(
    future: futureCoinsMarket,
    builder: (context, item) {
      if (item.hasData){
       return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: coins_market.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 10),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                elevation : 5,
                  child: Row (

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                            height: 40,
                            width: 40,
                            child: Image.network(coins_market[index].image),
                          )

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                            width: 130,
                            margin: EdgeInsets.only(top: 20,  left: 20),

                            child: Text(coins_market[index].name,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 20, left: 20),
                            child: Text(coins_market[index].symbol.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13)),
                          ),

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(coins_market[index].currentPrice.toString() + " USD",
                                textAlign:TextAlign.right,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                          Container(

                            margin: EdgeInsets.only(top: 5,left: 10),
                            child: Text(coins_market[index].priceChangePercentage24h.toStringAsFixed(2) + "%",
            textAlign:TextAlign.right,

                                style: TextStyle(
                                    color: coins_market[index].priceChangePercentage24h < 0 ? Colors.red : Colors.green,
                                    fontSize: 13)),
                          ),

                        ],
                      ),

                    ],
                  )
            ));
          }
        );

      }
      return const CircularProgressIndicator();
    }

    )
        ),
            onRefresh: refreshCoinMarketList): _set_page == 1 ?
        RefreshIndicator(child: Container(

            child: FutureBuilder<List<Coins>>(
                future: futureCoins,
                builder: (context, item) {
                  if (item.hasData){
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: coins_trading.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation : 5,
                                  child: Row (
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20, bottom: 20, left: 20),
                                            height: 40,
                                            width: 40,
                                            child: Image.network(coins_trading[index].item.large),
                                          )

                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20,  left: 20),
                                            width: 130,
                                            child: Text(coins_trading[index].item.name,
                                                style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5, bottom: 20, left: 20),
                                            child: Text(coins_trading[index].item.symbol,
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 13)),
                                          ),

                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,

                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text((coins_trading[index].item.priceBtc * 169539.74).toStringAsFixed(4) + " BTC",
                                                style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),


                                        ],
                                      ),
                                    ],
                                  )
                              ));
                        }
                    );

                  }
                  return const CircularProgressIndicator();
                }

            )
        ),
            onRefresh: refreshCoinsList):
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("data")
        ],
      ) ,
      ),
    );
  }
}