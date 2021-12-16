// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/tshirt_data.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

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
  Future<String> createUser(
      String userId, String firstName, String lastName) async {
    return users
        .doc(userId)
        .set({"FirstName": firstName, "LastName": lastName, "Sessions": []})
        .then((value) => "User created")
        .catchError(
            (error) => throw Exception("Failed to create user: $error"));
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
  Future<String> updateUser(
      String userId, String firstName, String lastName) async {
    return users
        .doc(userId)
        .update({"FirstName": firstName, "LastName": lastName})
        .then((value) => "User updated")
        .catchError(
            (error) => throw Exception("Failed to update user: $error"));
  }

  ///Saving session by user
  ///
  ///userId: signed in user
  ///
  ///data: Session data list
  ///
  ///Returns database transaction result
  Future<String> saveSession(String userId, List<TshirtData> data) async {
    //Thsirt data to string list
    List<String> stringList = [];
    data.forEach((element) {
      stringList.add(element.toString());
    });
    var toStore = [
      {"Data": stringList, "Timestamp": DateTime.now()}
    ];
    DocumentReference _ref = users.doc(userId);
    return _ref
        .update({"Sessions": FieldValue.arrayUnion(toStore)})
        .then((value) => "Session saved")
        .catchError(
            (error) => throw Exception("Failed to save session: $error"));
  }

  ///Get user session by user id and date
  ///
  ///Returns a List of Thsirt data list
  Future<List<List<TshirtData>>> getDataByUserAndDate(
      String userId, DateTime date) async {
    List<List<TshirtData>> result = [];
    await users.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
      //if user exist
      if (documentSnapshot.exists) {
        //get user sessions
        List<dynamic> sessions = documentSnapshot.get("Sessions");
        sessions.forEach((element) {
          //check if the date is matching
          if (DateFormat('yyyy-MM-dd')
                  .format(element["Timestamp"].toDate())
                  .toString() ==
              DateFormat('yyyy-MM-dd').format(date).toString()) {
            //create lists of TshirtData
            List<TshirtData> dataList = [];
            element["Data"].forEach((string) {
              var stringArr = string.split(" ").asMap();
              TshirtData data = TshirtData(
                  time: stringArr[0],
                  heartFrequency: stringArr[1],
                  temperature: stringArr[2],
                  humidity: stringArr[3]);
              dataList.add(data);
            });

            result.add(dataList);
          }
        });
      }
    });
    return result;
  }
}
