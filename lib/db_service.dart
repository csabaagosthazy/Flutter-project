// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'data/activity_data.dart';
import 'data/tshirt_data.dart';

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
  ///Returns a List of Tshirt data list
  Future<List<List<TshirtData>>> getDataByUserAndDate(
      String userId, DateTime date) async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    List<List<TshirtData>> result = [];
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
                heartFrequency: stringArr[1],
                temperature: stringArr[2],
                humidity: stringArr[3]);
            dataList.add(data);
          }

          result.add(dataList);
        }
      }
    }
    return result;
  }

  ///Get user session by user id
  ///
  ///Returns a List of activity data
  Future<List<ActivityData>> getDataByUser(
      String userId) async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    List<ActivityData> result = [];
    DocumentSnapshot documentSnapshot = await users.doc(userId).get();
    //if user exist
    if (documentSnapshot.exists) {
      //get user sessions
      List<dynamic> sessions = documentSnapshot.get("Sessions");
      for (final element in sessions) {
        ActivityData currentActivityData;
        String currentSessionDate = dateFormat.format(element["Timestamp"].toDate()).toString();
        List<TshirtData> dataList = [];
        for (final dataPoint in element["Data"]) {
          var stringArr = dataPoint.split(" ");
          TshirtData data = TshirtData(
              time: stringArr[0],
              heartFrequency: stringArr[1],
              temperature: stringArr[2],
              humidity: stringArr[3]);
          dataList.add(data);
        }
        currentActivityData = ActivityData(dataList, currentSessionDate);
        result.add(currentActivityData);
      }
    }
    return result;
  }
}
