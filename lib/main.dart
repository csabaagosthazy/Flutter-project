// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import '/tshirt_connection.dart';
import '/tshirt_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project Group 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Welcome to our App'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of variables
  List<String> history = [];

  //Variable that get all the data from the t-shirt
  String _data = "";

  var time;
  var heartFrequency;
  var temperature;
  var humidity;
  // init connection class
  TshirtConnection conn =
      TshirtConnection(url: 'https://tshirtserver.herokuapp.com/');

  // add values in history
  void addInHistory(String text) {
    setState(() {
      history.add(text);
    });
  }

  //InitState methode that launch the code when the application in starting
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var data = "No t-shirt connected!";
    //We increment a timer every 2 secondes the get the data and we put the get data methode inside the timer
    Timer mytimer = Timer.periodic(Duration(seconds: 2), (timer) {
      //Methode that will connect the application with the web server in this ip (192.168.4.2) and get the data
      Future<dynamic> res = conn.getData();
      //res.then((value) => {value.map((e) => data + " " + e)});
      res.then((value) => data = value.toString());

      setState(() {
        _data = data;
        addInHistory(_data);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You can see de t-shirt data in real time',),
            Text(_data,style: Theme.of(context).textTheme.headline4,),
            Expanded(child: HistoryList(history))],
        ),
      ),
    );
  }
}

class HistoryList extends StatefulWidget {
  final List<String> historyItems;

  HistoryList(this.historyItems);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.historyItems.length,
      itemBuilder: (context, index) {
        var item = widget.historyItems[index];
        return Card(child: Row(children: <Widget>[Expanded(child: ListTile(title: Text(item)))]));
      },
    );
  }
}

