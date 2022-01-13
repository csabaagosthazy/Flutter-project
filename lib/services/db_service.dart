// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../data/activity_data.dart';
import '../data/tshirt_data.dart';

// Cloud firestore database class
class DbService {
  //init db reference
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  ///Create user (call after sign up)
  ///
  ///userId : created user id in sign up process
  ///
  ///firstName : user first name
  ///
  ///lastName : user last name
  ///
  ///Returns database transaction result
  Future<void> createUser(
      String userId, String firstName, String lastName) async {
    await users
        .doc(userId)
        .set({"FirstName": firstName, "LastName": lastName, "Sessions": []});
  }

  ///Get user
  ///
  ///userId : signed in user
  ///
  ///Returns database transaction result
  Future<DocumentSnapshot> getUserById(String userId) async {
    return users.doc(userId).get();
  }

  ///Update user
  ///
  ///userId : created user id in sign up process
  ///
  ///firstName : user first name
  ///
  ///lastName : user last name
  ///
  ///Returns database transaction result
  Future<void> updateUser(
      String userId, String firstName, String lastName) async {
    await users
        .doc(userId)
        .update({"FirstName": firstName, "LastName": lastName});
  }

  ///Saving session by user
  ///
  ///userId: signed in user
  ///
  ///data: Session data list
  ///
  ///Returns database transaction result
  Future<void> saveSession(String userId, List<TshirtData> data) async {
    //Thsirt data to string list
    List<String> stringList = [];
    data.forEach((element) {
      stringList.add(element.toString());
    });
    var toStore = [
      {"Data": stringList, "Timestamp": DateTime.now()}
    ];
    DocumentReference _ref = users.doc(userId);
    await _ref.update({"Sessions": FieldValue.arrayUnion(toStore)});
  }

  ///Get user session by user id and date
  ///
  ///userId: signed in user
  ///
  ///data: Session data list
  ///
  ///Returns a List of Tshirt data list
  Future<List<ActivityData>> getDataByUserAndDate(
      String userId, DateTime date) async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    List<ActivityData> result = [];

    DocumentSnapshot documentSnapshot = await users.doc(userId).get();
    //if user exist
    if (documentSnapshot.exists) {
      String targetDate = dateFormat.format(date).toString();
      //get user sessions
      List<dynamic> sessions = documentSnapshot.get("Sessions");
      for (final element in sessions) {
        //check if the date is matching
        String currentSessionDate =
            dateFormat.format(element["Timestamp"].toDate()).toString();

        if (currentSessionDate == targetDate) {
          //create lists of TshirtData
          List<TshirtData> dataList = [];

          for (final dataPoint in element["Data"]) {
            var stringArr = dataPoint.split(" ");
            TshirtData data = TshirtData(
                time: stringArr[0],
                heartFrequency: int.parse(stringArr[1]),
                temperature: int.parse(stringArr[2]),
                humidity: int.parse(stringArr[3]));
            dataList.add(data);
          }
          result.add(ActivityData(dataList, currentSessionDate));
        }
      }
    }
    return result;
  }

  ///Get user session by user id
  ///
  ///userId: signed in user
  ///
  ///data: Session data list
  ///
  ///Returns a List of activity data
  Future<List<ActivityData>> getDataByUser(String userId,
      [int numberActivity = -1]) async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    List<ActivityData> result = [];
    DocumentSnapshot documentSnapshot = await users.doc(userId).get();
    //if user exist
    if (documentSnapshot.exists) {
      //get user sessions
      List<dynamic> sessions = documentSnapshot.get("Sessions");

      if (sessions.isEmpty) {
        return [];
      }
      int numberData = sessions.length;
      if (numberActivity >= 0 && numberActivity < sessions.length) {
        numberData = numberActivity;
      }
      for (var idx = 0; idx < numberData; idx++) {
        final element = sessions[idx];
        ActivityData currentActivityData;
        String currentSessionDate =
            dateFormat.format(element["Timestamp"].toDate()).toString();
        List<TshirtData> dataList = [];
        for (final dataPoint in element["Data"]) {
          var stringArr = dataPoint.split(" ");
          TshirtData data = TshirtData(
              time: stringArr[0],
              heartFrequency: int.parse(stringArr[1]),
              temperature: int.parse(stringArr[2]),
              humidity: int.parse(stringArr[3]));
          dataList.add(data);
        }
        currentActivityData = ActivityData(dataList, currentSessionDate);
        result.add(currentActivityData);
      }
    }
    return result;
  }
}
