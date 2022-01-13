// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/activity_data.dart';
import 'package:flutter_group2_tshirt_project/data/history_list.dart';
import 'package:flutter_group2_tshirt_project/services/auth_service.dart';
import 'package:flutter_group2_tshirt_project/services/db_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<ActivityData> dataFromDb = [];
  bool isCalendarVisible = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  /// Get all the activities
  ///
  /// dateTime: Date to get the activities
  void getActivityByDay(DateTime dateTime) async {
    DbService db = DbService();
    AuthService auth = AuthService();
    User? user = await auth.getCurrentUser();
    if (user != null) {
      var data = await db.getDataByUserAndDate(user.uid, dateTime);
      setState(() {
        dataFromDb = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getActivityByDay(DateTime.now());
  }

  /// Hide the calendar
  void hideCalendar() {
    setState(() {
      isCalendarVisible = false;
    });
  }

  /// Display the calendar
  void showCalendar() {
    setState(() {
      isCalendarVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Visibility(
        visible: isCalendarVisible,
        child: TableCalendar(
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
            if (!isSameDay(selectedDay, _selectedDay)) {
              getActivityByDay(selectedDay);
            }
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
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
      ),
      Expanded(
          child: HistoryList(
              displayRecentActivity: false,
              historyActivity: dataFromDb,
              clickActivityButton: hideCalendar,
              clickCloseButton: showCalendar))
      //
    ]));
  }
}
