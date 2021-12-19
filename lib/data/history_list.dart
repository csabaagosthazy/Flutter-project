import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/activity_item.dart';
import '../db_service.dart';
import 'activity_data.dart';

/// This is the stateful widget that Activity instantiates.
class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<ActivityData>? historyActivity;
  bool isDisplayedOldActivity = false;
  late Widget oldActivity;

  ///Retrieve data from db for the current user
  ///
  ///Returns a List of activity data
  Future<List<ActivityData>> getDataFromDb() async {
    DbService db = DbService();
    //TODO: change 2 with the current user when login is done
    return await db.getDataByUser("2");
  }

  ///Display the activity given in parms
  ///
  /// activity : activity to display
  void displayLastActivity(Widget activity) {
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
    if (isDisplayedOldActivity) {
      return oldActivity;
    }
    var design;
    if (historyActivity == null) {
      design = Center(
        child: Text("Wait for a moment !"),
      );
    } else if (historyActivity!.isEmpty) {
      design = const Scaffold(
          body: Center(
        child: Text("No data to show"),
      ));
    } else {
      List<Widget> items = List.empty(growable: true);
      for (int i = 0; i < min(3, historyActivity!.length); i++) {
        items.add(Expanded(
            child: ActivityItem(
          currentDate:
              historyActivity![historyActivity!.length - 1 - i].activityDate,
          totalDuration: historyActivity![historyActivity!.length - 1 - i]
              .listTshirtData
              .last
              .time,
          currentDataTshirt:
              historyActivity![historyActivity!.length - 1 - i].listTshirtData,
          onClick: displayLastActivity,
        )));
      }
      design = Container(child: Column(children: items));
    }
    return design;
  }
}
