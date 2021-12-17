import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/chart_data.dart';
import 'package:flutter_group2_tshirt_project/connection/tshirt_connection.dart';
import 'package:flutter_group2_tshirt_project/data/tshirt_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../components/line_chart.dart';
import '../components/info_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //Variable that get all the data from the t-shirt
  String _data = "";
  String textConnectedTshirt = "No t-shirt connected!";

  //heartrate, temperature or humidity
  String indicator = 'heartrate';

  changeLineChartBasedOnValue(String indicator) {
    setState(() {
      this.indicator = indicator;
      print(indicator);
    });
  }

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
        if (data.isNotEmpty) {
          _data = data;
          data = "";
          List<String> values = _data.split(" ");
          history.add(TshirtData(
              time: values[0],
              heartFrequency: values[1],
              temperature: values[2],
              humidity: values[3]));

          textConnectedTshirt =
              "T-shirt connected! (" + history.last.time + ")";
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
        /*
        appBar: AppBar(
          title: Text(widget.title),
        ),
        */
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(children: <Widget>[
      Center(child: Text(textConnectedTshirt)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: InfoCard(
                  title: 'heartrate',
                  fun: changeLineChartBasedOnValue,
                  value: history.last.heartFrequency,
                  icon:
                      const Icon(MdiIcons.heart, color: Colors.red, size: 75))),
          Expanded(
              flex: 3,
              child: InfoCard(
                  title: 'temperature',
                  fun: changeLineChartBasedOnValue,
                  value: history.last.temperature,
                  icon: const Icon(MdiIcons.thermometer,
                      color: Colors.orange, size: 75))),
          Expanded(
              flex: 3,
              child: InfoCard(
                  title: 'humidity',
                  fun: changeLineChartBasedOnValue,
                  value: history.last.humidity,
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

  List<ChartData> getDataHeart(List<TshirtData> gHistory) {
    List<ChartData> myChartDataList = List.empty(growable: true);
    for (TshirtData tdata in gHistory) {
      ChartData tempChartData = ChartData(tdata.time, double.parse(tdata.heartFrequency));
      myChartDataList.add(tempChartData);
    }
    return myChartDataList;
  }

  List<ChartData> getDataTemp(List<TshirtData> gHistory) {
    List<ChartData> myChartDataList = List.empty(growable: true);
    for (TshirtData tdata in gHistory) {
      ChartData tempChartData = ChartData(tdata.time, double.parse(tdata.temperature));
      myChartDataList.add(tempChartData);
    }
    return myChartDataList;
  }
  
  List<ChartData> getDataHum(List<TshirtData> gHistory) {
    List<ChartData> myChartDataList = List.empty(growable: true);
    for (TshirtData tdata in gHistory) {
      ChartData tempChartData = ChartData(tdata.time, double.parse(tdata.humidity));
      myChartDataList.add(tempChartData);
    }
    return myChartDataList;
  }
}
