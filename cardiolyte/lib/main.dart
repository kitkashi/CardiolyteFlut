import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:cardiolyte/BleService.dart';
import 'package:cardiolyte/infoPage.dart';

// Constants
// X-axis values are millisecond timestamps from the BLE device.
// Show a 10-second window: 10s × 1000ms = 10,000 ms range.
const int secondsDisplayed = 10;
const int shownRangeOfXValues = secondsDisplayed * 1000;

// Theme
const Color kPrimary = Color(0xFFE91E8C);
const Color kPrimaryLight = Color(0xFFF48FB1);
const Color kBackground = Color(0xFFFCF4F8);
const Color kCardBg = Colors.white;
const Color kTextDark = Color(0xFF1A1A2E);
const Color kTextMuted = Color(0xFF7B7B9D);
const Color kDivider = Color(0xFFF0E0EA);

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const CardioLyteApp());
}

//  ROOT APP
class CardioLyteApp extends StatelessWidget {
  const CardioLyteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioLyte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimary,
        scaffoldBackgroundColor: kBackground,
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

//  HOME PAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Innitializing Bluetooth
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _sub;

  @override
  void initState() {
    super.initState();
    _sub = FlutterBluePlus.adapterState.listen((s) {
      if (mounted) setState(() => _adapterState = s);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  bool get _bluetoothOn => _adapterState == BluetoothAdapterState.on;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── App branding ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'CardioLyte',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // ── START Reading card ────────────────────────────────────────
              _StartReadingCard(bluetoothOn: _bluetoothOn),
              const SizedBox(height: 16),

              // ── Past Readings card ────────────────────────────────────────
              _NavCard(
                icon: Icons.history_rounded,
                iconBgColor: const Color(0xFFFFE4F0),
                iconColor: kPrimary,
                title: 'Past Readings',
                subtitle: 'View your ECG history',
                trailingWidget: _EkgMiniIcon(color: kPrimary.withOpacity(0.4)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Past Readings coming soon')),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Tips & Education card
              _NavCard(
                icon: Icons.menu_book_rounded,
                iconBgColor: const Color(0xFFE8F4FD),
                iconColor: const Color(0xFF2196F3),
                title: 'Tips & Education',
                subtitle: 'Learn about heart health',
                trailingWidget: _EkgMiniIcon(
                  color: const Color(0xFF2196F3).withOpacity(0.4),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TipsAndEducationPage(),
                  ),
                ),
              ),

              const Spacer(),

              // ── Bluetooth status pill ─────────────────────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimary.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _bluetoothOn ? kPrimary : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _bluetoothOn
                            ? 'Ready to monitor your cardiac health'
                            : 'Bluetooth is off — please enable it',
                        style: TextStyle(
                          fontSize: 13,
                          color: _bluetoothOn ? kPrimary : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── START Reading gradient card ────────────────────────────────────────────────
class _StartReadingCard extends StatelessWidget {
  const _StartReadingCard({required this.bluetoothOn});

  final bool bluetoothOn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiveEkgPage()),
      ),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE91E8C), Color(0xFFFF6FB7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'START',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'Reading',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Begin your ECG analysis now',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Generic nav card ───────────────────────────────────────────────────────────
class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailingWidget,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailingWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: kTextMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            trailingWidget,
          ],
        ),
      ),
    );
  }
}

// ── Tiny ECG squiggle icon ─────────────────────────────────────────────────────
class _EkgMiniIcon extends StatelessWidget {
  const _EkgMiniIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 24),
      painter: _EkgPainter(color: color),
    );
  }
}

class _EkgPainter extends CustomPainter {
  const _EkgPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final mid = h / 2;

    path.moveTo(0, mid);
    path.lineTo(w * 0.2, mid);
    path.lineTo(w * 0.3, mid - h * 0.3);
    path.lineTo(w * 0.4, h);
    path.lineTo(w * 0.5, 0);
    path.lineTo(w * 0.6, mid + h * 0.2);
    path.lineTo(w * 0.7, mid);
    path.lineTo(w, mid);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_EkgPainter old) => old.color != color;
}

// ═══════════════════════════════════════════════════════════════════════════════
//  LIVE EKG PAGE
// ═══════════════════════════════════════════════════════════════════════════════
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
