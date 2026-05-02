import 'package:flutter/material.dart';
import 'package:cardiolyte/main.dart';

//  TIPS & EDUCATION PAGE
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

          // ── Content ───────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Lead placement diagram
                const _LeadPlacementCard(),
                const SizedBox(height: 8),

                // Section 1 – Understanding EKG
                const _SectionHeader(
                  icon: Icons.monitor_heart_rounded,
                  iconColor: kPrimary,
                  iconBg: Color(0xFFFFE4F0),
                  title: 'Understanding Your EKG',
                ),
                const _InfoCard(
                  question: 'What is an EKG?',
                  answer:
                      'An EKG (electrocardiogram) measures the electrical signals that make your heart beat. This app displays your live heart signal and may identify patterns worth paying attention to, but it does not replace a doctor\'s evaluation or emergency care.',
                  icon: Icons.electrical_services_rounded,
                ),
                const _InfoCard(
                  question: 'How Do I Take an EKG Reading?',
                  answer:
                      'To improve EKG quality, sit still, relax your arms, keep the electrodes firmly attached, and avoid talking or moving during the reading. Following these steps ensures the most accurate rhythm is captured on our mobile application, providing better and more accurate health insights.',
                  icon: Icons.self_improvement_rounded,
                ),

                const SizedBox(height: 8),

                // Section 2 – App Insights
                const _SectionHeader(
                  icon: Icons.insights_rounded,
                  iconColor: Color(0xFF7B1FA2),
                  iconBg: Color(0xFFF3E5F5),
                  title: 'App Insights',
                ),
                const _InfoCard(
                  question: 'What Do the App Insights Mean?',
                  answer:
                      'App insights may help flag rhythm patterns such as a regular rhythm or a possible irregular rhythm, but signal quality, motion, poor electrode contact, and device limitations can affect results. They are meant to start a conversation with your healthcare provider, and not act as a diagnosis.',
                  icon: Icons.analytics_rounded,
                ),
                const _InfoCard(
                  question: 'What Does CardioLyte Do?',
                  answer:
                      'This app uses electrode data to provide helpful information, but it cannot rule out all heart problems. Some conditions require additional leads, longer monitoring, imaging, lab tests, or in-person evaluation. Single-lead ECG tools have important limitations and are not meant to assess every condition.',
                  icon: Icons.devices_rounded,
                ),

                const SizedBox(height: 8),

                // Section 3 – How Do I Use My Insights?
                const _SectionHeader(
                  icon: Icons.medical_information_rounded,
                  iconColor: Color(0xFF0288D1),
                  iconBg: Color(0xFFE1F5FE),
                  title: 'How Do I Use My Insights?',
                ),
                const _InfoCard(
                  question: 'Follow-Up Care',
                  answer:
                      'If your reading looks unusual, do not panic. One reading does not always mean there is a serious problem, but repeated abnormal readings or symptoms should be reviewed by a licensed healthcare professional.',
                  icon: Icons.local_hospital_rounded,
                ),
                const _InfoCard(
                  question: 'What to Share with Your Provider',
                  answer:
                      'Bring or send the ECG recording, the date and time it happened, what symptoms you felt, how long they lasted, and what you were doing at the time. This information can help a medical professional decide whether further testing is needed to identify any signs of irregularities.',
                  icon: Icons.share_rounded,
                ),
                const _InfoCard(
                  question: 'When to Contact Your Provider',
                  answer:
                      'Schedule follow-up with a healthcare provider if you notice repeated irregular readings, frequent palpitations, fast or slow heart rate, dizziness, shortness of breath, weakness, or reduced ability to exercise.',
                  icon: Icons.schedule_rounded,
                ),

                const SizedBox(height: 8),

                // Section 4 – Emergency
                const _SectionHeader(
                  icon: Icons.warning_amber_rounded,
                  iconColor: Color(0xFFD32F2F),
                  iconBg: Color(0xFFFFEBEE),
                  title: 'When to Seek Medical Help',
                ),
                const _EmergencyCard(),

                const SizedBox(height: 24),

                // Disclaimer footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFF57F17),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'CardioLyte is intended for informational purposes only. '
                          'It is not a medical device and should not be used as a '
                          'substitute for professional medical advice, diagnosis, or treatment.',
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
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                Divider(color: kDivider, height: 1),
                Image.asset(
                  'assets/images/lead_placement.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
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
                            'Add lead_placement.png to\n'
                            'assets/images/ and declare it in pubspec.yaml',
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
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: Color(0xFF0288D1),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Electrode placement may vary slightly based on patient anatomy '
                          'and clinical setting. Always follow local protocol and device guidelines.',
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
          const Row(
            children: [
              Icon(Icons.emergency_rounded, color: Color(0xFFD32F2F), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Call Emergency Services Immediately',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
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
