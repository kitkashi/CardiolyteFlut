import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

//100 ms in a second is .010 seconds, suggested is 100HZ == 0.01 sec
const int refreshRateMs = 10;
const int refreshRateHz = refreshRateMs * 10;
//100 points shown a second i want to show a 4 second strip
const int secondsDisplayed = 4;
const int convertToSeconds = 1000;
//Points per second (Hz) * seconds I want displayed = total graph points
const int shownGraphPoints = (refreshRateHz) * (secondsDisplayed);
final Random random = Random();

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((
      state,
    ) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Initialize the chart widget
          Expanded(child: LiveEkgChart()),
        ],
      ),
    );
  }
}

class LiveEkgChart extends StatefulWidget {
  const LiveEkgChart({super.key});

  @override
  State<LiveEkgChart> createState() => _LiveEkgChartState();
}

class _LiveEkgChartState extends State<LiveEkgChart> {
  late int _currentNumPoints;
  late List<EkgSampleData> _ekgData;
  ChartSeriesController<EkgSampleData, num>? _chartSeriesController;
  late ZoomPanBehavior _zoomPanBehavior;

  late bool _scrollEnabled;

  @override
  void initState() {
    super.initState();

    _currentNumPoints = 0;
    _ekgData = [EkgSampleData(x: 0, y: 0)];

    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
    _scrollEnabled = false;

    // Start this *after* initializing everything else
    Timer.periodic(Duration(milliseconds: 10), _updateDataSource);
  }

  void _enableScroll() {
    setState(() {
      _scrollEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double? maximum;
    int? autoScrollingDelta;
    if (_scrollEnabled) {
      maximum = null;
      autoScrollingDelta = shownGraphPoints;
    } else {
      maximum = shownGraphPoints.toDouble();
      autoScrollingDelta = null;
    }

    return SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,

      primaryXAxis: NumericAxis(
        maximum: maximum,
        autoScrollingDelta: autoScrollingDelta,
      ),
      primaryYAxis: NumericAxis(),

      title: ChartTitle(text: 'Ekg Chart'),

      series: <CartesianSeries<EkgSampleData, num>>[
        LineSeries<EkgSampleData, num>(
          dataSource: _ekgData,
          xValueMapper: (EkgSampleData ekgData, _) => ekgData.x,
          yValueMapper: (EkgSampleData ekgData, _) => ekgData.y,
          // Enable data label
          dataLabelSettings: DataLabelSettings(isVisible: true),
          //Initialize the onRendererCreated event and store the controller for the respective series
          onRendererCreated:
              (ChartSeriesController<EkgSampleData, num> controller) {
                _chartSeriesController = controller;
              },
        ),
      ],
    );
  }

  /// Continuously updating the data source based on timer.
  void _updateDataSource(Timer? _) {
    if (_currentNumPoints > shownGraphPoints) {
      _enableScroll();
    }

    _ekgData.add(
      EkgSampleData(x: ++_currentNumPoints, y: _getRandomInt(10, 100)),
    );
    _chartSeriesController?.updateDataSource(
      addedDataIndexes: <int>[_ekgData.length - 1],
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
