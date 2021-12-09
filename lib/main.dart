// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_group2_tshirt_project/tshirt_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '/tshirt_connection.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

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
/// This is the stateless widget that the main application instantiates.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.icon});

   final String title;
   final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Column(
                children: [
                  icon,
                  Center(child: Text(title),)
          ]),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  //Variable that get all the data from the t-shirt
  String _data = "";
  String textConnectedTshirt = "No t-shirt connected!";

  // List of variables
  List<TshirtData> history = List.empty(growable: true);
  TshirtConnection conn =
      TshirtConnection(url: 'https://tshirtserver.herokuapp.com/');

  //InitState methode that launch the code when the application in starting
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String data = "";
    //We increment a timer every 2 secondes the get the data and we put the get data methode inside the timer
    Timer.periodic(const Duration(seconds: 2), (timer) {
      //Methode that will connect the application with the web server in this ip (192.168.4.2) and get the data
      Future<dynamic> res = conn.getData();
      //res.then((value) => {value.map((e) => data + " " + e)});
      res.then((value) => data = value.toString());

      setState(() {
        if(data.isNotEmpty) {
          _data = data;
          data = "";
          List<String> values = _data.split(" ");
          history.add(TshirtData(time: values[0], heartFrequency: values[1], temperature: values[2], humidity: values[3]));

          textConnectedTshirt = "T-shirt connected! ("+history.last.time+")";

        }

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
        child:
            Column(children: <Widget>[
              Center(child: Text(textConnectedTshirt)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                      child: _InfoCard(title: history.last.heartFrequency, icon: const Icon(MdiIcons.heart,color: Colors.red, size: 75))
                  ),
                  Expanded(
                      flex: 3,
                      child:_InfoCard(title: history.last.temperature, icon: Icon(MdiIcons.thermometer,color: Colors.orange, size: 75))
                  ),
                  Expanded(
                      flex: 3,
                      child:_InfoCard(title: history.last.humidity, icon: Icon(MdiIcons.waterPercent,color: Colors.blue, size:75))
                  ),

                ],
              ),

                  Text('You can see de t-shirt data in real time',),
                  Text(_data,style: Theme.of(context).textTheme.headline4,),
                  Expanded(child: HistoryList(history)),
      ]))

    );

  }
}

class HistoryList extends StatefulWidget {
  final List<TshirtData> historyItems;

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
        return Card(child: Row(children: <Widget>[Expanded(child: ListTile(title: Text(item.time + " " + item.heartFrequency + " " + item.temperature + " " + item.humidity)))]));
      },
    );
  }
}

