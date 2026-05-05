import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cardiolyte/main.dart';
import 'package:cardiolyte/BleService.dart';

class LiveEkgPage extends StatelessWidget {
  const LiveEkgPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kTextDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Live ECG Reading',
          style: TextStyle(
            color: kTextDark,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: const LiveEkgChart(),
    );
  }
}

// ── Chart widget ───────────────────────────────────────────────────────────────
class LiveEkgChart extends StatefulWidget {
  const LiveEkgChart({super.key});

  @override
  State<LiveEkgChart> createState() => _LiveEkgChartState();
}

class _LiveEkgChartState extends State<LiveEkgChart> {
  late List<EkgSampleData> _ekgData;
  ChartSeriesController<EkgSampleData, num>? _chartSeriesController;
  late ZoomPanBehavior _zoomPanBehavior;
  late bool _scrollEnabled;
  late BleService bleService;

  @override
  void initState() {
    super.initState();

    bleService = BleService(updateChartIndicesCallback: updateDataSource);

    // BleService owns the list; we hold a reference to the same instance.
    _ekgData = bleService.receivedData;
    _ekgData.add(EkgSampleData(x: 0, y: 0));

    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
    _scrollEnabled = false;

    bleService.scanForDevice().then(
      (_) => bleService.connectAndSubscribeToDevice(),
    );
  }

  void _enableScroll() {
    setState(() => _scrollEnabled = true);
  }

  @override
  Widget build(BuildContext context) {
    final double? maximum;
    final int? autoScrollingDelta;

    if (_scrollEnabled) {
      maximum = null;
      autoScrollingDelta = shownRangeOfXValues;
    } else {
      maximum = shownRangeOfXValues.toDouble();
      autoScrollingDelta = null;
    }

    return Column(
      children: [
        // ── Live indicator bar ──────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVE',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '${secondsDisplayed}s window',
                style: const TextStyle(color: kTextMuted, fontSize: 12),
              ),
            ],
          ),
        ),

        // ── Chart ───────────────────────────────────────────────────────
        Expanded(
          child: SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            backgroundColor: Colors.white,
            plotAreaBorderColor: Colors.transparent,
            primaryXAxis: NumericAxis(
              maximum: maximum,
              autoScrollingDelta: autoScrollingDelta,
              majorGridLines: const MajorGridLines(
                color: Color(0xFFFCE4EC),
                width: 1,
              ),
              axisLine: const AxisLine(color: kDivider),
              labelStyle: const TextStyle(color: kTextMuted, fontSize: 10),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 1024,
              majorGridLines: const MajorGridLines(
                color: Color(0xFFFCE4EC),
                width: 1,
              ),
              axisLine: const AxisLine(color: kDivider),
              labelStyle: const TextStyle(color: kTextMuted, fontSize: 10),
            ),
            series: <CartesianSeries<EkgSampleData, num>>[
              LineSeries<EkgSampleData, num>(
                dataSource: _ekgData,
                xValueMapper: (EkgSampleData d, _) => d.x,
                yValueMapper: (EkgSampleData d, _) => d.y,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                  showZeroValue: false,
                ),
                color: kPrimary,
                width: 2,
                animationDuration: 0,
                onRendererCreated: (controller) =>
                    _chartSeriesController = controller,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Called by [BleService] with the list of newly added data indices.
  void updateDataSource(final List<int> addedDataIndices) {
    if (!_scrollEnabled) {
      // x values are millisecond timestamps — non-nullable per EkgSampleData
      final int maxX = addedDataIndices.map((i) => _ekgData[i].x).reduce(max);
      if (maxX > shownRangeOfXValues) {
        _enableScroll();
      }
    }

    _chartSeriesController?.updateDataSource(
      addedDataIndexes: addedDataIndices,
    );
  }
}

/// Data model — non-nullable fields to match [BleService.receivedData].
class EkgSampleData {
  EkgSampleData({required this.x, required this.y});

  int x;
  int y;
}
