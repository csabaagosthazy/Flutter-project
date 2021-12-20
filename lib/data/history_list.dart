import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/activity_item.dart';
import '../db_service.dart';
import 'activity_data.dart';

/// This is the stateful widget that Activity instantiates.
class HistoryList extends StatefulWidget {

  HistoryList({this.clickActivityButton, this.clickCloseButton});
  var clickActivityButton;
  var clickCloseButton;
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<ActivityData>? historyActivity;
  bool isDisplayedOldActivity = false;
  bool isConnectedToInternet = true;
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
    widget.clickActivityButton();
    setState(() {
      isDisplayedOldActivity = true;
      oldActivity = activity;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDb().then((value) => {
          setState(() {
            historyActivity = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    //Display a message if there is no connection
    if(!isConnectedToInternet){
      return const Center(child: Text("Could not retrieve the data because you are not connected to Internet."),);
    }

    //display an activity
    if(isDisplayedOldActivity){
      return Column(children: [
        ElevatedButton(onPressed: (){
          widget.clickCloseButton();
          setState(() {
            isDisplayedOldActivity = false;
          });
        }, child: Text("Close")),
        Expanded(child: oldActivity,)

      ],);
    }

    var design;
    // Wait because it is not loaded
    if (historyActivity == null) {
      design =  const Center(
        child: Text("Wait for a moment !"),
      );
      // No data
    } else if (historyActivity!.isEmpty) {
      design = const Scaffold(
          body: Center(
        child: Text("No data to show"),
      ));
    } else {
      //Display only the last 3 activities
      List<Widget> items = List.empty(growable: true);
      for (int i = 0; i < min(3, historyActivity!.length); i++) {
        items.add(Expanded(
            child: ActivityItem(
            data: historyActivity![historyActivity!.length - 1 - i],
            onClick: displayLastActivity,
        )));
      }
      design = Container(child: Column(children: items));
    }
    return design;
  }
}
