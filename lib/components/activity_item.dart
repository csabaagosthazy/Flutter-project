import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/activity.dart';
import 'package:flutter_group2_tshirt_project/data/activity_data.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    return SizedBox(
      height: 75,
      child:
        Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            onClick(Activity(history: data.listTshirtData));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(MdiIcons.calendar, color: Colors.blueAccent, size: 50,),
              Text(data.activityDate.toString()),
            Icon(MdiIcons.timer, color: Colors.yellow, size: 50,),
            Text(data.listTshirtData.last.time),
            ],
          ),
        ),
      ),
    );

  }
}
