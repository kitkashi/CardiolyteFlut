import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//1000 ms in a second
//suggested is 100HZ
const int refreshRateMs=10;
//100 points shown a second
//i want to show a 10 second strip
const int secondsDisplayed=5;
const int shownGraphPoints=(refreshRateMs*10)*(secondsDisplayed);
//instantiate random number
final Random random = Random();

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  _MyHomePage({super.key});

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
          Expanded(
          child:LiveEkgChart(),
          ),
        ],
      ),
    );
  }
}

class LiveEkgChart extends StatefulWidget {
  const LiveEkgChart({
    super.key,
  });

  @override
  State<LiveEkgChart> createState() => _LiveEkgChartState();
}

class _LiveEkgChartState extends State<LiveEkgChart> {
  int i = 0;
  late List<EkgSampleData>? ekgData;
  ChartSeriesController<EkgSampleData, num>? _chartSeriesController;
  Timer? _timer;

  _LiveEkgChartState() {
    _timer = Timer.periodic
          (const Duration(milliseconds: 1000),
        _updateDataSource);
  }

  late ZoomPanBehavior zoomPanBehavior;
  @override
  void initState() {
    ekgData = <EkgSampleData>[
      //first point
      EkgSampleData(x: 0, y: 0),
      // EkgSampleData(x: 9, y: 72),
    ];
    zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: zoomPanBehavior,
      primaryXAxis: NumericAxis(
        minimum: 0,
        maximum: 10,
        // initialVisibleMinimum: 0,
        // initialVisibleMaximum: 100,
        // autoScrollingDelta:10,
        // autoScrollingMode:  AutoScrollingMode.end,
      ),
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
          // animationDuration: 100,
          // name: 'Reading',
          // Enable data label
          dataLabelSettings: DataLabelSettings(isVisible: true),
          //Initialize the onRendererCreated event and store the controller for the respective series
          onRendererCreated: (ChartSeriesController<EkgSampleData, num> controller) {
            _chartSeriesController = controller;
          },
        ),
      ],
    );
  }
  void _updateDataSource(Timer _) {
    print(i);
    ekgData?.add(EkgSampleData(x: ++i, y: _getRandomInt(10, 100)));
    //chooses how many points to display on the screen at once
    if (ekgData?.length == 10000) {
      ekgData?.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[ekgData!.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[ekgData!.length - 1],
      );
    }
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
