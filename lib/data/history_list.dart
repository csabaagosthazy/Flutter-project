import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/activity_item.dart';
import '../db_service.dart';
import 'activity_data.dart';

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<ActivityData>? historyActivity;
  bool isDisplayedOldActivity = false;
  bool isConnectedToInternet = true;
  late Widget oldActivity;

  Future<List<ActivityData>> getDataFromDb() async {
    DbService db = DbService();
    //TODO: change 2 with the current user when login is done
    return await db.getDataByUser("2").catchError((error) => isConnectedToInternet = false);
  }

  void displayLastActivity(Widget activity){
    setState(() {
      isDisplayedOldActivity = true;
      oldActivity = activity;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromDb().then((value) => {
          setState(() {

            historyActivity = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {



    if(!isConnectedToInternet){
      return const Center(child: Text("Could not retrieve the data because you are not connected to Internet."),);
    }

    if(isDisplayedOldActivity){
      return oldActivity;
    }

    var design;
    if (historyActivity == null) {
      design =  const Center(
        child: Text("Wait for a moment !"),
      );
    } else if (historyActivity!.isEmpty) {
      design = const Scaffold(
          body: Center(
        child: Text("No data to show"),
      ));
    } else {
        List<Widget> items = List.empty(growable: true);
        for(int i=0; i<min(3, historyActivity!.length); i++)
          {
            items.add(Expanded(
                child: ActivityItem(
                  currentDate:
                  historyActivity![historyActivity!.length-1-i].activityDate,
                  totalDuration: historyActivity![historyActivity!.length-1-i]
                      .listTshirtData
                      .last
                      .time,
                  currentDataTshirt:
                  historyActivity![historyActivity!.length-1-i].listTshirtData,
                  onClick: displayLastActivity,
                )));
          }
          design = Container(child: Column(children: items));
    }
    return design;
  }
}
