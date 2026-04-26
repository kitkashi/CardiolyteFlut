import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//instantiate random number
final Random random = Random();
ChartSeriesController? _chartSeriesController;
List<EkgSampleData> ekgData = <EkgSampleData>[
  EkgSampleData(x: 1, y: 30),
  EkgSampleData(x: 3, y: 13),
  EkgSampleData(x: 5, y: 80),
  EkgSampleData(x: 7, y: 30),
  EkgSampleData(x: 9, y: 72)
];

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: _MyHomePage(),
    );
  }
}


  
class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Initialize the chart widget
          SfCartesianChart(
            primaryXAxis: NumericAxis(),
            primaryYAxis: NumericAxis(),
            // Chart title
            title: ChartTitle(text: 'Ekg Chart'),
            // Enable tooltip
            // tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<EkgSampleData, num>>[
              LineSeries<EkgSampleData, num>(
                dataSource: ekgData, 
                xValueMapper: (EkgSampleData ekgData, _) => ekgData.x,
                yValueMapper: (EkgSampleData ekgData, _) => ekgData.y,
                // name: 'Reading',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}                        


class EkgSampleData {
  EkgSampleData({this.x, this.y});

  int? x;
  int? y;
}

int _getRandomInt(int min, int max) {
  return min + random.nextInt(max - min);
}

/// Continuously updating the data source based on timer.
void _updateDataSource(Timer timer) {
  int i=0;
  ekgData.add(EkgSampleData(x: i++, y: _getRandomInt(10, 100)));
  if (ekgData.length == 20) {
    ekgData.removeAt(0);
    _chartSeriesController?.updateDataSource(
      addedDataIndexes: <int>[ekgData.length - 1],
      removedDataIndexes: <int>[0],
    );
  } else {
    _chartSeriesController?.updateDataSource(
      addedDataIndexes: <int>[ekgData.length - 1],
    );
  }
}                         

Timer? timer;

@override
void initState() {
  super.initState();
  timer = Timer.periodic(const Duration(milliseconds: 100), _updateDataSource);
}                          
