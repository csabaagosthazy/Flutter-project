import 'dart:async';
import 'package:http/http.dart' as http;
import '/tshirt_data.dart';

class TshirtConnection {
  String url;

  TshirtConnection({required this.url});

  Future<TshirtData> getData() async {
    final http.Response response;

    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseItems = response.body.split(" ");

      // The t-shirt returns [uptime] [heartbeat rate] [temperature] [humidity],
      // if no error has occurred.
      if(responseItems.length < 4) {
        throw Exception("The t-shirt did not return 4 elements in the text response");
      }

      var tshirtUptime = responseItems[1];
      var heartBeatRate = int.parse(responseItems[1]);
      var temperature = int.parse(responseItems[2]);
      var humidity = int.parse(responseItems[3]);

      TshirtData data = TshirtData(
          time: tshirtUptime,
          heartFrequency: heartBeatRate,
          temperature: temperature,
          humidity: humidity
      );

      return data;
    } else {
      throw Exception('Unable to connect to the t-shirt server');
    }
  }
}
