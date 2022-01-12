// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/activity_data.dart';
import 'package:flutter_group2_tshirt_project/data/history_list.dart';
import 'package:flutter_group2_tshirt_project/data/my_notifier.dart';
import 'package:table_calendar/table_calendar.dart';

import '../db_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var dataFromDb = MyNotifier([]);

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  void getActivityByDay(DateTime dateTime) async {
    DbService db = DbService();
    //TODO: change 2 with the current user when login is done
     dataFromDb.changeData(await db.getDataByUserAndDate("2", dateTime));

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      TableCalendar(
        //init the calendar
        focusedDay: _focusedDay,
        firstDay: DateTime(2020),
        lastDay: DateTime(2030),

        //Custom calendar
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekVisible: true,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),

        //adding interactivity
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            getActivityByDay(_selectedDay);
            print(_selectedDay);
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (CalendarFormat _format) {
          setState(() {
            _calendarFormat = _format;
          });
        },

        //Updating focusedDay
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

        //Calendar style
        calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              shape: BoxShape.circle,
            )),

        //Events
      ),
      Expanded(child:
      ValueListenableBuilder<List<ActivityData>>(
        valueListenable: dataFromDb,
        builder: ( context, data, child){
          return HistoryList(displayRecentActivity: false, historyActivity: dataFromDb.value);
          // set to false + ma liste +
        }))
     //
    ]));
  }
}