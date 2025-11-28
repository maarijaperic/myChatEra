import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class DailyDoseScreen extends StatefulWidget {
  final int messagesPerDay;

  const DailyDoseScreen({
    super.key,
    required this.messagesPerDay,
  });

  @override
  State<DailyDoseScreen> createState() => _DailyDoseScreenState();
}

class _DailyDoseScreenState extends State<DailyDoseScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _bubblesController;
  late AnimationController _gradientController;
  final GlobalKey _screenshotKey = GlobalKey();
  
  int _displayedMessages = 0;

  String get _activityLabel {
    final messages = widget.messagesPerDay;
    if (messages <= 0) return 'Starting the journey';
    if (messages < 10) return 'Intentional check-ins';
    if (messages < 30) return 'Steady daily rhythm';
    if (messages < 60) return 'Productivity groove';
    return 'GPT power user';
  }


  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _bubblesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _counterController.forward();
    
    // Animate counter
    _counterController.addListener(() {
      setState(() {
        _displayedMessages = (widget.messagesPerDay * _counterController.value).round();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _counterController.dispose();
    _bubblesController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  String get _moodLabel {
    final messages = widget.messagesPerDay;
    if (messages <= 0) return 'Quiet season';
    if (messages < 10) return 'Slow drip';
    if (messages < 30) return 'Flow state';
    if (messages < 60) return 'Momentum mode';
    return 'Turbo mode';
  }

  String get _moodEmoji {
    final messages = widget.messagesPerDay;
    if (messages <= 0) return '🌙';
    if (messages < 10) return '🌱';
    if (messages < 30) return '🌤️';
    if (messages < 60) return '⚡';
    return '🚀';
  }

  double get _progressValue {
    return (widget.messagesPerDay / 80).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final highlightData = [
      _DailyDoseHighlightData(
        icon: Icons.calendar_month_rounded,
        title: 'Consistency',
        subtitle: _activityLabel,
        gradient: const [Color(0xFFFFC1DE), Color(0xFFFFE7F4)],
      ),
      _DailyDoseHighlightData(
        icon: Icons.mood_rounded,
        title: 'Mood',
        subtitle: '$_moodEmoji $_moodLabel',
        gradient: const [Color(0xFFFFD6E8), Color(0xFFFFF0F7)],
      ),
    ];
    
    return Scaffold(
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Stack(
          children: [
            // Light pink gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF0F5),
                    Color(0xFFFFE4E9),
                    Color(0xFFFFD1DC),
                    Color(0xFFFFB6C1),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            
            // Animated particles
            AnimatedBuilder(
              animation: _bubblesController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _DailyDoseParticlesPainter(_bubblesController.value),
                  child: Container(),
                );
              },
            ),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (screenWidth * 0.06).clamp(20.0, 24.0),
                    vertical: (screenHeight * 0.025).clamp(16.0, 20.0),
                  ),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Daily Dose',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.08).clamp(26.0, 34.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your GPT rhythm recapped like a share-ready moment.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF5C5C5E),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: _DailyDoseHeroCard(
                        counterController: _counterController,
                        displayedMessages: _displayedMessages,
                        progressValue: _progressValue,
                        activityLabel: _activityLabel,
                        moodEmoji: _moodEmoji,
                        moodLabel: _moodLabel,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Highlight cards - Consistency and Mood in same row
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: highlightData
                            .map((data) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: data == highlightData.first ? 0 : 8,
                                      right: data == highlightData.last ? 0 : 8,
                                    ),
                                    child: _DailyDoseHighlightCard(data: data),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: SmallShareToStoryButton(
                        shareText: 'I send ${widget.messagesPerDay} messages to ChatGPT per day! My daily dose of AI wisdom 💬 #ChatGPTWrapped',
                        screenshotKey: _screenshotKey,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

// Animated fade widget
class _AnimatedFade extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _AnimatedFade({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        (delay + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}

// Daily dose particles painter
class _DailyDoseParticlesPainter extends CustomPainter {
  final double animationValue;

  _DailyDoseParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw floating sparkles
    for (int i = 0; i < 35; i++) {
      final x = (i * 37.0) % size.width;
      final y = (i * 23.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.3);
      final twinkle = 0.3 + 0.7 * sin(timeOffset);
      final starSize = 1.0 + (2.0 * twinkle);

      // Draw star shape
      final double starOpacity = (twinkle * 0.8).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(starOpacity);
      _drawStar(canvas, Offset(x, y), starSize, paint);
    }

    // Add some smaller sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 47.0 + 15.0) % size.width;
      final y = (i * 31.0 + 20.0) % size.height;
      final timeOffset = (animationValue * 3 * pi) + (i * 0.5);
      final sparkle = 0.2 + 0.6 * sin(timeOffset);
      final sparkleSize = 0.5 + (1.0 * sparkle);

      final double circleOpacity = (sparkle * 0.9).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(circleOpacity);
      canvas.drawCircle(
        Offset(x, y),
        sparkleSize,
        paint,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - (pi / 2);
      final outerX = center.dx + cos(angle) * outerRadius;
      final outerY = center.dy + sin(angle) * outerRadius;
      final innerAngle = angle + (pi / 5);
      final innerX = center.dx + cos(innerAngle) * innerRadius;
      final innerY = center.dy + sin(innerAngle) * innerRadius;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DailyDoseHeroCard extends StatelessWidget {
  final AnimationController counterController;
  final int displayedMessages;
  final double progressValue;
  final String activityLabel;
  final String moodEmoji;
  final String moodLabel;

  const _DailyDoseHeroCard({
    required this.counterController,
    required this.displayedMessages,
    required this.progressValue,
    required this.activityLabel,
    required this.moodEmoji,
    required this.moodLabel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all((screenWidth * 0.035).clamp(14.0, 18.0)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -15,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFE2EE), Color(0xFFFFBBDD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: _HeroChip(label: 'Conversation cadence'),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEF5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '$moodEmoji $moodLabel',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFB64176),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: counterController,
                    builder: (context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$displayedMessages',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.09).clamp(32.0, 40.0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'messages per day',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6B6B6D),
                              fontSize: (screenWidth * 0.032).clamp(12.0, 14.0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFFFC3DA).withOpacity(0.35),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressValue,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB1)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroStatCard(
                          label: 'Cadence',
                          value: activityLabel,
                          icon: Icons.bolt_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _HeroStatCard(
                          label: 'Vibe',
                          value: '$moodEmoji $moodLabel',
                          icon: Icons.mood_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;

  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD5E8)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFFDB4A84),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeroStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HeroStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE2EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFDB4A84),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8A8A8D),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F1F21),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyDoseHighlightCard extends StatelessWidget {
  final _DailyDoseHighlightData data;

  const _DailyDoseHighlightCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final cardWidth = isLargeScreen ? 200.0 : (screenWidth * 0.42).clamp(150.0, 190.0);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: data.gradient.last.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data.icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.title,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.95),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyDoseHighlightData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _DailyDoseHighlightData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

