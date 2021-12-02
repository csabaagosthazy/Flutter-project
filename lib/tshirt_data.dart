class TshirtData {
  var time;
  var heartFrequency;
  var temperature;
  var humidity;

  //Constructor
  TshirtData({
    required this.time,
    required this.heartFrequency,
    required this.temperature,
    required this.humidity,
  });

  @override
  String toString() {
    return time + " " + heartFrequency + " " + temperature + " " + humidity;
  }

  factory TshirtData.fromJson(Map<String, dynamic> json) {
    return TshirtData(
        time: DateTime.parse(json['Time'] as String),
        heartFrequency: json['HeartFrequency'] as String,
        temperature: json['Temperature'] as String,
        humidity: json['Humidity'] as String);
  }
}
