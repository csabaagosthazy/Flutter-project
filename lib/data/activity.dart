import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_group2_tshirt_project/components/chart_data.dart';
import 'package:flutter_group2_tshirt_project/components/info_card.dart';
import 'package:flutter_group2_tshirt_project/components/line_chart.dart';
import 'package:flutter_group2_tshirt_project/connection/tshirt_connection.dart';
import 'package:flutter_group2_tshirt_project/data/history_list.dart';
import 'package:flutter_group2_tshirt_project/data/tshirt_data.dart';
import 'package:flutter_group2_tshirt_project/db_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// This is the stateful widget that MainPage instantiates.
class Activity extends StatefulWidget {
  bool canStart;
  bool displayHistory;
  late List<TshirtData> history;

  Activity({List<TshirtData>? history,this.displayHistory=false, this.canStart = false}) {
    this.history = history ?? List.empty(growable: true);
    displayHistory = this.canStart;
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

  ///Update the indicator
  ///
  ///indicator: the indicator that we want to display on the graph
  void changeLineChartBasedOnValue(String indicator) {
    setState(() {
      this.indicator = indicator;
    });
  }

  ///Get heart frequency data from the Tshirt
  ///
  ///gHistory : All data from the Tshirt
  ///
  ///Returns a list a chart data to feed the graph
  List<ChartData> getDataHeart(List<TshirtData> gHistory) {
    List<ChartData> myChartDataList = List.empty(growable: true);
    for (TshirtData tdata in gHistory) {
      ChartData tempChartData = ChartData(tdata.time, tdata.heartFrequency);
      myChartDataList.add(tempChartData);
    }
    return myChartDataList;
  }

  ///Get temperature data from the Tshirt
  ///
  ///gHistory : All data from the Tshirt
  ///
  ///Returns a list a chart data to feed the graph
  List<ChartData> getDataTemp(List<TshirtData> gHistory) {
    List<ChartData> myChartDataList = List.empty(growable: true);
    for (TshirtData tdata in gHistory) {
      ChartData tempChartData = ChartData(tdata.time, tdata.temperature);
      myChartDataList.add(tempChartData);
    }
    return myChartDataList;
  }

  ///Get humidity data from the Tshirt
  ///
  ///gHistory : All data from the Tshirt
  ///
  ///Returns a list a chart data to feed the graph
  List<ChartData> getDataHum(List<TshirtData> gHistory) {
    List<ChartData> myChartDataList = List.empty(growable: true);
    for (TshirtData tdata in gHistory) {
      ChartData tempChartData = ChartData(tdata.time, tdata.humidity);
      myChartDataList.add(tempChartData);
    }
    return myChartDataList;
  }

  ///Change the current chart base on indicator
  ///
  ///indicator : the indicator that we want to display on the graph
  ///
  ///Returns a list of chart data
  List<ChartData> listOfValuesWithTime(String indicator) {
    switch (indicator) {
      case 'humidity':
        return getDataHum(history);
      case 'temperature':
        return getDataTemp(history);
      default:
        return getDataHeart(history);
    }
  }

  ///Convert the time in int
  ///
  ///time : The time in String
  ///
  ///Returns the time in int
  int _getDuration(String time) {
    var itemTimes = time.split(":");
    return int.parse(itemTimes[0]) * 3600 +
        int.parse(itemTimes[1]) * 60 +
        int.parse(itemTimes[2]);
  }

  ///Convert the time in String
  ///
  ///duration: The duration in int
  ///
  ///Returns the duration in String
  String _getDurationToTimeString(int duration) {
    int hours = (duration / 3600).floor();
    duration = duration % 3600;
    int minutes = (duration / 60).floor();
    int seconds = (duration % 60);
    return hours.toString() +
        ":" +
        minutes.toString() +
        ":" +
        seconds.toString();
  }

  void hideStartButton(){
    setState(() {
      widget.canStart = false;
    });
  }

  void displayStartButton(){
    setState(() {
      widget.canStart = true;
    });
  }

  ///Call when the activity is start
  void startActivity() {
    if (isStarted) {
      return;
    }
    TshirtData? data;
    isStarted = true;
    //We increment a timer every 2 secondes the get the data and we put the get data methode inside the timer
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      //Methode that will connect the application with the web server in this ip (192.168.4.2) and get the data
      Future<dynamic> res = conn.getData();
      //res.then((value) => {value.map((e) => data + " " + e)});
      res.then((value) => data = value).catchError((error, stackTrace) {
        textConnectedTshirt = "Disconnected";
        if (history.length >= 3) {
          DbService db = DbService();
          db.saveSession("2", history);
        }
        stopActivity();
      });

      setState(() {
        if (data != null) {
          if (firstTimeDuration == -1) {
            firstTimeDuration = _getDuration(data!.time);
            data!.time = "0:0:0";
          } else {
            data!.time = _getDurationToTimeString(
                _getDuration(data!.time) - firstTimeDuration);
          }

          history.add(data!);

          heartFrequencyTitle = history.last.heartFrequency.toString();
          humidityTitle = history.last.humidity.toString();
          temperatureTitle = history.last.temperature.toString();
          textConnectedTshirt =
              "Connected!";
        }
      });
    });
  }

  ///Call when the activity is stop
  void stopActivity() {
    if (!isStarted) {
      return;
    }
    timer!.cancel();
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
    if (history.isNotEmpty) {
      int avgHeartFrequency = 0;
      int avgTemperature = 0;
      int avgHumidity = 0;
      for (TshirtData data in history) {
        avgHeartFrequency += data.heartFrequency;
        avgHumidity += data.humidity;
        avgTemperature += data.temperature;
      }
      avgHeartFrequency = (avgHeartFrequency / history.length).floor();
      avgHumidity = (avgHumidity / history.length).floor();
      avgTemperature = (avgTemperature / history.length).floor();

      heartFrequencyTitle = avgHeartFrequency.toString();
      humidityTitle = avgHumidity.toString();
      temperatureTitle = avgTemperature.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> underButton = List.empty(growable: true);

    if ((widget.canStart || widget.displayHistory) && !isStarted) {
     underButton.add(Expanded(flex: 3, child: HistoryList(clickActivityButton: hideStartButton, clickCloseButton: displayStartButton)));
    } else {
      underButton.add(Row(
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
      ));
      underButton.add(Text(
        _data,
        style: Theme.of(context).textTheme.headline4,
      ));
      underButton.add(Expanded(
          child: Linechart(
        indicator: indicator,
        data: listOfValuesWithTime(indicator),
      )));
    }

    return  Column(children: <Widget>[
    Visibility(
    visible: widget.canStart,
        child:Row(children: [
          Expanded(child: Center(child: Text(textConnectedTshirt)),)
            ,
            ElevatedButton(
                onPressed: () {
                  if (isStarted && history.length >= 3) {
                    DbService db = DbService();
                    db.saveSession("2", history);
                    stopActivity();
                  } else {
                    startActivity();
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: isStarted ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: Text(
                  isStarted ? "Stop activity" : "Start Activity",
                  style: GoogleFonts.heebo(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(
              height: 10,
            ),

            /*
                child: isStarted
                    ? const Text("Stop activity")
                    : const Text("Start activity")),*/
          ])),
      ...underButton
    ]);
  }
}
