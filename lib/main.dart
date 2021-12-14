import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/tshirt_connection.dart';
import '/tshirt_data.dart';
import '/db_service.dart';
import 'dart:developer';

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
  //Variable that get all the data from the t-shirt
  String _data = "";
  String _test = "";

  var time;
  var heartFrequency;
  var temperature;
  var humidity;
  // init connection class
  TshirtConnection conn =
      TshirtConnection(url: 'https://tshirtserver.herokuapp.com/');

  //InitState methode that launch the code when the application in starting
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var data = "No t-shirt connected!";
    DbService db = DbService();
    var res = db.getDataByUserAndDate("2", DateTime.now());
    log(res.toString());

    //We increment a timer every 2 secondes the get the data and we put the get data methode inside the timer
    Timer mytimer = Timer.periodic(Duration(seconds: 2), (timer) {
      //Methode that will connect the application with the web server in this ip (192.168.4.2) and get the data
      Future<dynamic> res = conn.getData();
      //res.then((value) => {value.map((e) => data + " " + e)});
      res.then((value) => data = value.toString());

      List<TshirtData> test = [
        TshirtData(
            time: "testTime",
            heartFrequency: "testFreq",
            temperature: "testTemp",
            humidity: "testHum"),
        TshirtData(
            time: "testTime",
            heartFrequency: "testFreq",
            temperature: "testTemp",
            humidity: "testHum")
      ];
      db.saveSession("1", test);
      setState(() {
        _data = data;
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
            const Text(
              'You can see the t-shirt data in real time',
            ),
            Text(
              _data,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              _test,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
