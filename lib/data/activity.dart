
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_group2_tshirt_project/components/chart_data.dart';
import 'package:flutter_group2_tshirt_project/components/info_card.dart';
import 'package:flutter_group2_tshirt_project/components/line_chart.dart';
import 'package:flutter_group2_tshirt_project/connection/tshirt_connection.dart';
import 'package:flutter_group2_tshirt_project/data/tshirt_data.dart';
import 'package:flutter_group2_tshirt_project/db_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Activity extends StatefulWidget{

  final bool canStart;
  late List<TshirtData> history;


  Activity({List<TshirtData>? history, this.canStart=false}) {
    this.history = history ?? List.empty(growable: true);
  }

  @override
  _ActivityState createState() => _ActivityState();

}


class _ActivityState extends State<Activity> {
  // List of variables

  late List<TshirtData> history;

  TshirtConnection conn =
  TshirtConnection(url: 'https://tshirtserver.herokuapp.com/');
  Timer? timer;
  String heartFrequencyTitle = "";
  String humidityTitle = "";
  String temperatureTitle = "";
  //heartrate, temperature or humidity
  String indicator = 'heartrate';
  String textConnectedTshirt = "No t-shirt connected!";
  String _data = "";
  bool isStarted = false;
  int firstTimeDuration = -1;


  changeLineChartBasedOnValue(String indicator) {
    setState(() {
      this.indicator = indicator;
      print(indicator);
    });
  }

//Need to take real data from Firebase:

  List<ChartData> dataHeart = [
    ChartData('0:00', 80),
    ChartData('0:15', 100),
    ChartData('0:20', 88),
    ChartData('0:30', 78),
    ChartData('0:40', 65),
    ChartData('0:50', 77),
    ChartData('0:60', 74)
  ];

  List<ChartData> dataTemp = [
    ChartData('0:00', 37),
    ChartData('0:15', 36.6),
    ChartData('0:20', 37.1),
    ChartData('0:30', 36.5),
    ChartData('0:40', 36.4),
    ChartData('0:50', 36.2),
    ChartData('0:60', 36.6)
  ];

  List<ChartData> dataHum = [
    ChartData('0:00', 66),
    ChartData('0:15', 64),
    ChartData('0:20', 65),
    ChartData('0:30', 56),
    ChartData('0:40', 59),
    ChartData('0:50', 62),
    ChartData('0:60', 54)
  ];

  List<ChartData> listOfValuesWithTime(String indicator) {
    switch (indicator) {
      case 'humidity':
        return dataHum;
      case 'temperature':
        return dataTemp;
      default:
        return dataHeart;
    }
  }
  int _getDuration(String time){
    var itemTimes = time.split(":");
    return int.parse(itemTimes[0])*3600 + int.parse(itemTimes[1]) * 60 + int.parse(itemTimes[2]);
  }

  String _getDurationToTimeString(int duration){
      int hours = (duration/3600).floor();
      duration = duration%3600;
      int minutes = (duration/60).floor();
      int seconds = (duration%60);
      return hours.toString() + ":" + minutes.toString() + ":" + seconds.toString();
  }

  void startActivity(){
    String data = "";
    isStarted = true;
    //We increment a timer every 2 secondes the get the data and we put the get data methode inside the timer
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      //Methode that will connect the application with the web server in this ip (192.168.4.2) and get the data
      Future<dynamic> res = conn.getData();
      //res.then((value) => {value.map((e) => data + " " + e)});
      res.then((value) => data = value.toString());

      setState(() {
        if (data.isNotEmpty) {
          List<String> values = data.split(" ");
          TshirtData item = TshirtData(
              time: values[0],
              heartFrequency: double.parse(values[1]),
              temperature: double.parse(values[2]),
              humidity: double.parse(values[3]));
          if (firstTimeDuration == -1) {
            firstTimeDuration = _getDuration(item.time);
            item.time = "0:0:0";
          } else {
            item.time = _getDurationToTimeString(_getDuration(item.time) - firstTimeDuration);
          }

          history.add(item);

          heartFrequencyTitle = history.last.heartFrequency.toString();
          humidityTitle = history.last.humidity.toString();
          temperatureTitle = history.last.temperature.toString();
          textConnectedTshirt =
              "T-shirt connected! (" + history.last.time + ")";
      }

      });
    });
  }
  
  void stopActivity(){
    timer!.cancel();
    DbService db = DbService();
    db.saveSession("2", history);
    history = List.empty(growable: true);
    firstTimeDuration = -1;
    setState(() {
      isStarted = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    history = widget.history;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child: Column(children: <Widget>[
              Row(
                children: [
                  Center(
                      child: Text(textConnectedTshirt)
                  ),
                  Visibility(child:
                    ElevatedButton(
                        onPressed: (){ isStarted ? stopActivity() : startActivity();},
                        child: isStarted ? Text("Stop activity"): Text("Start activity")
                    ),
                    visible: widget.canStart,
                  )
                ],
              ) ,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: InfoCard(
                          title: 'heartrate',
                          fun: changeLineChartBasedOnValue,
                          value: heartFrequencyTitle,
                          icon:
                          const Icon(MdiIcons.heart, color: Colors.red, size: 75))),
                  Expanded(
                      flex: 3,
                      child: InfoCard(
                          title: 'temperature',
                          fun: changeLineChartBasedOnValue,
                          value: temperatureTitle,
                          icon: const Icon(MdiIcons.thermometer,
                              color: Colors.orange, size: 75))),
                  Expanded(
                      flex: 3,
                      child: InfoCard(
                          title: 'humidity',
                          fun: changeLineChartBasedOnValue,
                          value: humidityTitle,
                          icon: const Icon(MdiIcons.waterPercent,
                              color: Colors.blue, size: 75))),
                ],
              ),

              const Text(
                'You can see de t-shirt data in real time',
              ),
              Text(
                _data,
                style: Theme.of(context).textTheme.headline4,
              ),
              Expanded(
                  child: Linechart(
                    indicator: indicator,
                    data: listOfValuesWithTime(indicator),
                  ))
              //    Expanded(child: HistoryList(history)),
            ])));
  }


}