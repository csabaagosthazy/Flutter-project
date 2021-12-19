class TshirtData {
  // The member variables will never be null since we pass by either constructors
  // that initialize all members. If this claim doesn't hold... well, runtime exceptions.
  // @see https://dart.dev/tools/diagnostic-messages
  late String time;
  late int heartFrequency;
  late int temperature;
  late int humidity;

  //Constructor
  TshirtData({
    required this.time,
    required this.heartFrequency,
    required this.temperature,
    required this.humidity,
  });

  /// Transforms a string containing a datapoint into a [TshirtData] instance
  ///
  /// The datapoint format is the following: "<t-shirt server uptime> <heartbeat rate> <temperature> <humidity>".
  /// Throws [Exception] if the string does not contain exactly four items when split.
  ///
  /// Throws implicitly a FormatException if the data items expected to contain integers
  /// are not parsable into integers.
  TshirtData.fromString(String datapoints) {
    List<String> items = datapoints.split(" ");

    if (items.length != 4) {
      throw Exception("Passed datapoint string must have exactly four items. " +
          items.length.toString() +
          " items found");
    }

    time = items[0];
    heartFrequency = int.parse(items[1]);
    temperature = int.parse(items[2]);
    humidity = int.parse(items[3]);
  }

  @override
  String toString() {
    return time +
        " " +
        heartFrequency.toString() +
        " " +
        temperature.toString() +
        " " +
        humidity.toString();
  }
}
