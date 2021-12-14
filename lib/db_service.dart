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
    _ref
        .update({"Sessions": FieldValue.arrayUnion(toStore)})
        .then((value) => log("Session saved"))
        .catchError((error) => log("Failed to save session: $error"));
  }

  ///Get user session by user id and date
  ///
  ///Returns a List of Thsirt data list
  Future<List<List<TshirtData>>> getDataByUserAndDate(
      String userId, DateTime date) async {
    List<List<TshirtData>> result = [];
    users.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
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
      } else {
        log("User id does not exist!");
      }
    });
    return result;
  }
}
