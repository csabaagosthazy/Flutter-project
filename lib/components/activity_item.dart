import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/activity.dart';
import 'package:flutter_group2_tshirt_project/data/tshirt_data.dart';

/// This is the stateless widget that HistoryList instantiates.
class ActivityItem extends StatelessWidget {
  ActivityItem(
      {Key? key,
      required this.currentDate,
      required this.totalDuration,
      required this.currentDataTshirt,
      this.onClick})
      : super(key: key);

  final String currentDate;
  final String totalDuration;
  final List<TshirtData> currentDataTshirt;
  var onClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          onClick(Activity(history: currentDataTshirt));
        },
        child: Row(
          children: <Widget>[
            Text(currentDate + " " + totalDuration),
          ],
        ),
      ),
    );
  }
}
