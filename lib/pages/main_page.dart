import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/activity.dart';
import 'package:flutter_group2_tshirt_project/data/history_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //InitState methode that launch the code when the application in starting
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var design;
    //TODO: don't forget to modify the false inside the if statement
    if (false) {
      design = Activity(canStart: true);
    } else {
      design = HistoryList();
    }
    return design;
  }
}
