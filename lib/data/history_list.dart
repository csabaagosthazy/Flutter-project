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

  Future<List<ActivityData>> getDataFromDb() async {
    DbService db = DbService();
    return await db.getDataByUser("2");
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
    var design;
    if (historyActivity == null) {
      design = const Scaffold(
          body: Center(
        child: Text("Wait for a moment !"),
      ));
    } else if (historyActivity!.isEmpty) {
      design = const Scaffold(
          body: Center(
        child: Text("No data to show"),
      ));
    } else {
      design = Column(children: [
        Expanded(
            child: ActivityItem(
                currentDate:
                    historyActivity![historyActivity!.length - 1].activityDate,
                totalDuration: historyActivity![historyActivity!.length - 1]
                    .listTshirtData
                    .last
                    .time)),
        Expanded(
            child: ActivityItem(
                currentDate:
                    historyActivity![historyActivity!.length - 2].activityDate,
                totalDuration: historyActivity![historyActivity!.length - 2]
                    .listTshirtData
                    .last
                    .time)),
        Expanded(
            child: ActivityItem(
                currentDate:
                    historyActivity![historyActivity!.length - 3].activityDate,
                totalDuration: historyActivity![historyActivity!.length - 3]
                    .listTshirtData
                    .last
                    .time)),
      ]);
    }
    return design;
  }
}
