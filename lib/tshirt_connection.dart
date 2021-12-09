import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/tshirt_data.dart';

class TshirtConnection {
  String url;


  //Constructor
  TshirtConnection({required this.url});

  Future<TshirtData> getData() async {
    late Map<int, String> res;

    //Connect to the server IP
    //http://192.168.4.2
    //https://tshirtserver.herokuapp.com/
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      res = response.body.split(" ").asMap();
      TshirtData data = TshirtData(
          time: res[0],
          heartFrequency: res[1],
          temperature: res[2],
          humidity: res[3]);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to connect to t-shirt');
    }
  }
}
/* 

  final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return 'Failed to connect to t-shirt';
    } */