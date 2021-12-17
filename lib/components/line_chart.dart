import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/components/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Linechart extends StatefulWidget {
  final String indicator;
  final List<ChartData> data;

  const Linechart({Key? key, required this.indicator, required this.data})
      : super(key: key);

  @override
  _LinechartState createState() => _LinechartState();
}

class _LinechartState extends State<Linechart> {
  setTitle(String indicator) {
    switch (indicator) {
      case 'humidity':
        return 'Humidity chart';
      case 'temperature':
        return 'Temperature chart';
      default:
        return 'Heart rate chart';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: setTitle(widget.indicator)),
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<ChartData, String>>[
            LineSeries<ChartData, String>(
                dataSource: widget.data,
                xValueMapper: (ChartData values, _) => values.duration,
                yValueMapper: (ChartData values, _) => values.values,
                name: widget.indicator,
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: false))
          ]),
    ]));
  }
}
