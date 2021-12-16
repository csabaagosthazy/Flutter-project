class TshirtData {
   String time;
   int heartFrequency;
   int temperature;
   int humidity;

  //Constructor
  TshirtData({
    required this.time,
    required this.heartFrequency,
    required this.temperature,
    required this.humidity,
  });

  @override
  String toString() {
    return time + " "
        + heartFrequency.toString() + " "
        + temperature.toString() + " "
        + humidity.toString();
  }
}
