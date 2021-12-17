import 'dart:async';
import 'package:http/http.dart' as http;
import '/tshirt_data.dart';

class TshirtConnection {
  String url;

  TshirtConnection({required this.url});

  /// Requests and returns the metrics returned by the connected t-shirt server located at [url].
  ///
  /// The data returned by the t-shirt server is encapsulated into a [TshirtData] data class,
  /// so the return is strongly typed.
  ///
  /// Throws explicitly:
  /// - [Exception] when receiving a bad response from the server. Bad responses encompass:
  ///   - HTTP code not 200
  ///
  /// Throws implicitly:
  /// - when parsing text response items into an integer failed
  /// - when the client is unable to send an HTTP request to the server
  /// - when the received string does not contain exactly four elements
  Future<TshirtData> getData() async {
    final http.Response response;

    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return TshirtData.fromString(response.body);
    } else {
      throw Exception('Unable to connect to the t-shirt server');
    }
  }
}
