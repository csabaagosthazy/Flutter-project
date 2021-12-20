import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/activity.dart';
import 'package:flutter_group2_tshirt_project/data/activity_data.dart';

/// This is the stateless widget that HistoryList instantiates.
class ActivityItem extends StatelessWidget {
  ActivityItem(
      {Key? key,
      required this.data,
      this.onClick})
      : super(key: key);

  final ActivityData data;
  var onClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          onClick(Activity(history: data.listTshirtData));
        },
        child: Row(
          children: <Widget>[
            Text("Activity of "+ data.activityDate + ", duration:  " + data.listTshirtData.last.time),
          ],
        ),
      ),
    );
  }
}
