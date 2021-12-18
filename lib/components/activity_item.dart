import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is the stateless widget that the main application instantiates.
class ActivityItem extends StatelessWidget {
  const ActivityItem(
      {Key? key, required this.currentDate, required this.totalDuration})
      : super(key: key);

  final String currentDate;
  final String totalDuration;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {},
        child: Row(
          children: <Widget>[
            Text(currentDate + " " + totalDuration),
          ],
        ),
      ),
    );
  }
}
