import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/activity_item.dart';
import 'package:flutter_group2_tshirt_project/services/auth_service.dart';
import '../services/db_service.dart';
import 'activity_data.dart';

/// This is the stateful widget that Activity instantiates.
class HistoryList extends StatefulWidget {
  HistoryList(
      {this.displayRecentActivity,
      this.historyActivity,
      this.clickActivityButton,
      this.clickCloseButton});

  var clickActivityButton;
  var clickCloseButton;
  var displayRecentActivity;
  List<ActivityData>? historyActivity;

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  bool isDisplayedOldActivity = false;
  bool isConnectedToInternet = true;
  late Widget oldActivity;
  List<ActivityData>? historyActivity;

  ///Retrieve data from db for the current user
  ///
  ///Returns a List of activity data
  Future<List<ActivityData>> getDataFromDb() async {
    DbService db = DbService();
    AuthService auth = AuthService();
    User? user = await auth.getCurrentUser();
    if (user == null) {
      return [];
    }

    return await db.getDataByUser(user.uid, 10);
  }

  ///Display the activity given in parms
  ///
  /// activity : activity to display
  void displayLastActivity(Widget activity) {
    if (widget.clickActivityButton != null) {
      widget.clickActivityButton();
    }
    setState(() {
      isDisplayedOldActivity = true;
      oldActivity = activity;
    });
  }

  ///Close the calendar
  void closeActivity() {
    if (widget.clickCloseButton != null) {
      widget.clickCloseButton();
    }
    setState(() {
      isDisplayedOldActivity = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.displayRecentActivity) {
      getDataFromDb().then((value) => {
            setState(() {
              historyActivity = value;
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Display a message if there is no connection
    if (!isConnectedToInternet) {
      return const Center(
        child: Text(
            "Could not retrieve the data because you are not connected to Internet."),
      );
    }
    if (!widget.displayRecentActivity) {
      historyActivity = widget.historyActivity;
    }
    //display an activity
    if (isDisplayedOldActivity) {
      return Column(
        children: [
          ElevatedButton(onPressed: closeActivity, child: const Text("Close")),
          Expanded(
            child: oldActivity,
          )
        ],
      );
    }

    var design;
    // Wait because it is not loaded
    if (historyActivity == null) {
      design = const Center(
        child: Text("Wait for a moment !"),
      );
      // No data
    } else if (historyActivity!.isEmpty) {
      design = const Scaffold(
          body: Center(
        child: Text("No data to show"),
      ));
    } else {
      //Display only the last 5 activities
      List<Widget> items = List.empty(growable: true);
      items.add(
        const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "List of activities: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            )),
      );
      for (var i = 0; i < historyActivity!.length; i++) {
        items.add(ActivityItem(
          data: historyActivity![historyActivity!.length - 1 - i],
          onClick: displayLastActivity,
        ));
      }
      // design = Container(child: Column(children: items));
      design = ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return items[index];
          });
    }
    return design;
  }
}
