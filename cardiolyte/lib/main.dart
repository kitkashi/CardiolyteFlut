import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// ─── Constants ───────────────────────────────────────────────────────────────
const int refreshRateMs = 10;
const int refreshRateHz = refreshRateMs * 10;
const int secondsDisplayed = 4;
const int shownGraphPoints = refreshRateHz * secondsDisplayed;
final Random random = Random();

// ─── Theme ───────────────────────────────────────────────────────────────────
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

// ═══════════════════════════════════════════════════════════════════════════════
//  ROOT APP
// ═══════════════════════════════════════════════════════════════════════════════
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
        fontFamily: 'sans-serif',
      ),
      home: const HomePage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  HOME PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    Text(
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

              // ── Past Readings card ───────────────────────────────────────
              _NavCard(
                icon: Icons.history_rounded,
                iconBgColor: const Color(0xFFFFE4F0),
                iconColor: kPrimary,
                title: 'Past Readings',
                subtitle: 'View your ECG history',
                trailingWidget: _EkgMiniIcon(color: kPrimary.withOpacity(0.4)),
                onTap: () {
                  // Navigate to past readings (placeholder)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Past Readings coming soon')),
                  );
                },
              ),
              const SizedBox(height: 16),

              // ── Tips & Education card ─────────────────────────────────────
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

              // ── Status pill ──────────────────────────────────────────────
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
            // Background decorative circles
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
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Play button
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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

// ── Chart widget (original logic preserved) ────────────────────────────────────
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
    Timer.periodic(const Duration(milliseconds: 10), _updateDataSource);
  }

  void _enableScroll() {
    setState(() => _scrollEnabled = true);
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

    return Column(
      children: [
        // Live indicator bar
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
                xValueMapper: (d, _) => d.x,
                yValueMapper: (d, _) => d.y,
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

  void _updateDataSource(Timer? _) {
    if (_currentNumPoints > shownGraphPoints) _enableScroll();
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

int _getRandomInt(int min, int max) => min + random.nextInt(max - min);

// ═══════════════════════════════════════════════════════════════════════════════
//  TIPS & EDUCATION PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class TipsAndEducationPage extends StatelessWidget {
  const TipsAndEducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible header ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kTextDark,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 20,
                bottom: 16,
                right: 20,
              ),
              title: const Text(
                'Tips & Education',
                style: TextStyle(
                  color: kTextDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE3F2FD), Color(0xFFFCE4EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.favorite_rounded,
                      color: kPrimary.withOpacity(0.2),
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Content sections ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Lead Placement Diagram ────────────────────────────────
                _LeadPlacementCard(),
                const SizedBox(height: 8),

                // Section 1 – Understanding EKG
                _SectionHeader(
                  icon: Icons.monitor_heart_rounded,
                  iconColor: kPrimary,
                  iconBg: const Color(0xFFFFE4F0),
                  title: 'Understanding Your EKG',
                ),
                _InfoCard(
                  question: 'What is an EKG?',
                  answer:
                      'An EKG (electrocardiogram) measures the electrical signals that make your heart beat. This app displays your live heart signal and may identify patterns worth paying attention to, but it does not replace a doctor\'s evaluation or emergency care.',
                  icon: Icons.electrical_services_rounded,
                ),
                _InfoCard(
                  question: 'How Do I Take an EKG Reading?',
                  answer:
                      'To improve EKG quality, sit still, relax your arms, keep the electrodes firmly attached, and avoid talking or moving during the reading. Following these steps ensures the most accurate rhythm is captured on our mobile application, providing better and more accurate health insights.',
                  icon: Icons.self_improvement_rounded,
                ),

                const SizedBox(height: 8),

                // Section 2 – App Insights
                _SectionHeader(
                  icon: Icons.insights_rounded,
                  iconColor: const Color(0xFF7B1FA2),
                  iconBg: const Color(0xFFF3E5F5),
                  title: 'App Insights',
                ),
                _InfoCard(
                  question: 'What Do the App Insights Mean?',
                  answer:
                      'App insights may help flag rhythm patterns such as a regular rhythm or a possible irregular rhythm, but signal quality, motion, poor electrode contact, and device limitations can affect results. They are meant to start a conversation with your healthcare provider, and not act as a diagnosis.',
                  icon: Icons.analytics_rounded,
                ),
                _InfoCard(
                  question: 'What Does CardioLyte Do?',
                  answer:
                      'This app uses electrode data to provide helpful information, but it cannot rule out all heart problems. Some conditions require additional leads, longer monitoring, imaging, lab tests, or in-person evaluation. Single-lead ECG tools have important limitations and are not meant to assess every condition.',
                  icon: Icons.devices_rounded,
                ),

                const SizedBox(height: 8),

                // Section 3 – How Do I Use My Insights?
                _SectionHeader(
                  icon: Icons.medical_information_rounded,
                  iconColor: const Color(0xFF0288D1),
                  iconBg: const Color(0xFFE1F5FE),
                  title: 'How Do I Use My Insights?',
                ),
                _InfoCard(
                  question: 'Follow-Up Care',
                  answer:
                      'If your reading looks unusual, do not panic. One reading does not always mean there is a serious problem, but repeated abnormal readings or symptoms should be reviewed by a licensed healthcare professional.',
                  icon: Icons.local_hospital_rounded,
                ),
                _InfoCard(
                  question: 'What to Share with Your Provider',
                  answer:
                      'Bring or send the ECG recording, the date and time it happened, what symptoms you felt, how long they lasted, and what you were doing at the time. This information can help a medical professional decide whether further testing is needed to identify any signs of irregularities.',
                  icon: Icons.share_rounded,
                ),
                _InfoCard(
                  question: 'When to Contact Your Provider',
                  answer:
                      'Schedule follow-up with a healthcare provider if you notice repeated irregular readings, frequent palpitations, fast or slow heart rate, dizziness, shortness of breath, weakness, or reduced ability to exercise.',
                  icon: Icons.schedule_rounded,
                ),

                const SizedBox(height: 8),

                // Section 4 – Emergency Warning Signs
                _SectionHeader(
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFD32F2F),
                  iconBg: const Color(0xFFFFEBEE),
                  title: 'When to Seek Medical Help',
                ),
                _EmergencyCard(),

                const SizedBox(height: 24),

                // Disclaimer footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFF57F17),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'CardioLyte is intended for informational purposes only. It is not a medical device and should not be used as a substitute for professional medical advice, diagnosis, or treatment.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D4037),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Lead Placement Card ────────────────────────────────────────────────────────
class _LeadPlacementCard extends StatefulWidget {
  const _LeadPlacementCard();

  @override
  State<_LeadPlacementCard> createState() => _LeadPlacementCardState();
}

class _LeadPlacementCardState extends State<_LeadPlacementCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row (tap to collapse) ──────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(16),
                  bottom: _expanded ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cable_rounded,
                      color: Color(0xFF0288D1),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Electrode Placement Guide',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: kTextDark,
                          ),
                        ),
                        Text(
                          'Lead I, II & III positioning',
                          style: TextStyle(
                            fontSize: 12,
                            color: kTextMuted,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: kTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Image + disclaimer ─────────────────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                Divider(color: kDivider, height: 1),
                // Diagram image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(0),
                  ),
                  child: Image.asset(
                    'assets/images/lead_placement.png',
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Graceful fallback if asset path not yet configured
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              color: Colors.grey[400],
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add lead_placement.png to\nassets/images/ and declare\nit in pubspec.yaml',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Disclaimer banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.info_rounded,
                        color: Color(0xFF0288D1),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Electrode placement may vary slightly based on patient anatomy and clinical setting. Always follow local protocol and device guidelines.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF01579B),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kTextDark,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expandable Q&A card ────────────────────────────────────────────────────────
class _InfoCard extends StatefulWidget {
  const _InfoCard({
    required this.question,
    required this.answer,
    required this.icon,
  });

  final String question;
  final String answer;
  final IconData icon;

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(widget.icon, color: kPrimary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: kTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _anim,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Divider(color: kDivider, height: 1),
                    const SizedBox(height: 12),
                    Text(
                      widget.answer,
                      style: const TextStyle(
                        fontSize: 13,
                        color: kTextMuted,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Emergency card ─────────────────────────────────────────────────────────────
class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  static const List<String> _symptoms = [
    'Chest pressure or pain',
    'Shortness of breath',
    'Fainting or loss of consciousness',
    'Cold sweat',
    'Nausea with chest symptoms',
    'Pain spreading to arm, back, neck, or jaw',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEBEE), Color(0xFFFFF3F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.emergency_rounded, color: Color(0xFFD32F2F), size: 20),
              SizedBox(width: 8),
              Text(
                'Call Emergency Services Immediately',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Do not rely on the app if you experience any of the following:',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7B0000),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          ..._symptoms.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFFD32F2F),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4A0000),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
