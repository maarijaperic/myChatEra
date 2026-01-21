import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class GptOClockScreen extends StatefulWidget {
  final Map<String, int> activityByPeriods; // Map of time periods to message counts

  const GptOClockScreen({
    super.key,
    required this.activityByPeriods, // {'8 AM': 150, '12 PM': 200, '6 PM': 180, '2 AM': 120}
  });

  @override
  State<GptOClockScreen> createState() => _GptOClockScreenState();
}

class _GptOClockScreenState extends State<GptOClockScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;
  late AnimationController _chartController;
  final GlobalKey _screenshotKey = GlobalKey();

  List<MapEntry<String, int>> get _sortedPeriods {
    final periods = widget.activityByPeriods.entries.toList();
    periods.sort((a, b) => b.value.compareTo(a.value));
    return periods;
  }

  int get _maxCount {
    if (widget.activityByPeriods.isEmpty) return 1;
    return widget.activityByPeriods.values.reduce((a, b) => a > b ? a : b);
  }

  String get _peakPeriod {
    if (_sortedPeriods.isEmpty) return '8 AM';
    return _sortedPeriods.first.key;
  }

  String get _peakPeriodEmoji {
    switch (_peakPeriod) {
      case '8 AM':
        return '🌅';
      case '12 PM':
        return '☀️';
      case '6 PM':
        return '🌆';
      case '2 AM':
        return '🌙';
      default:
        return '🕐';
    }
  }

  String get _shareText {
    return "My AI peak time is $_peakPeriod $_peakPeriodEmoji. Most active when others are sleeping! 🕐 #mychateraAI";
  }



  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _bubblesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _chartController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bubblesController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Stack(
          children: [
            // Light pastel blue gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE0F2F7), // Very light blue
                    Color(0xFFCCEEF5), // Light blue
                    Color(0xFFB8E8F0), // Soft blue
                    Color(0xFFA3E2EB), // Pastel blue
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
                  painter: _PeakTimeParticlesPainter(_bubblesController.value),
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
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your Peak Time',
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
                            'When you\'re most active with AI',
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
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Activity Chart
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: _ActivityChart(
                        activityByPeriods: widget.activityByPeriods,
                        maxCount: _maxCount,
                        peakPeriod: _peakPeriod,
                        peakEmoji: _peakPeriodEmoji,
                        chartController: _chartController,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: SmallShareToStoryButton(
                        shareText: _shareText,
                        screenshotKey: _screenshotKey,
                        accentGradient: const [Color(0xFFFF8C42), Color(0xFFFFB366)],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
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

// Peak time particles painter - bubbles and sparkles floating
class _PeakTimeParticlesPainter extends CustomPainter {
  final double animationValue;

  _PeakTimeParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw floating bubbles
    for (int i = 0; i < 20; i++) {
      final x = (i * 47.0) % size.width;
      final y = (i * 31.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final float = sin(timeOffset) * 15;
      final bubbleY = y + float;
      final opacity = 0.2 + 0.3 * sin(timeOffset);
      final bubbleSize = 3.0 + (2.0 * sin(timeOffset));
      
      canvas.drawCircle(
        Offset(x, bubbleY),
        bubbleSize,
        paint..color = Colors.white.withOpacity(opacity),
      );
    }
    
    // Add floating sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 67.0 + 30) % size.width;
      final y = (i * 43.0 + 20) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.6);
      final twinkle = 0.3 + 0.7 * sin(timeOffset);
      final starSize = 1.0 + (1.5 * twinkle);
      
      _drawStar(canvas, Offset(x, y), starSize, paint..color = Colors.white.withOpacity(twinkle * 0.6));
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

// Activity Chart Widget
class _ActivityChart extends StatelessWidget {
  final Map<String, int> activityByPeriods;
  final int maxCount;
  final String peakPeriod;
  final String peakEmoji;
  final AnimationController chartController;
  final double screenWidth;
  final double screenHeight;

  const _ActivityChart({
    required this.activityByPeriods,
    required this.maxCount,
    required this.peakPeriod,
    required this.peakEmoji,
    required this.chartController,
    required this.screenWidth,
    required this.screenHeight,
  });

  List<Color> _getPeriodGradient(String period) {
    switch (period) {
      case '8 AM':
        return [const Color(0xFFFFD700), const Color(0xFFFFE55C)]; // Gold/Yellow
      case '12 PM':
        return [const Color(0xFFFF8C42), const Color(0xFFFFB366)]; // Orange
      case '6 PM':
        return [const Color(0xFFFF6B9D), const Color(0xFFFF8FB1)]; // Pink
      case '2 AM':
        return [const Color(0xFF667eea), const Color(0xFF764ba2)]; // Purple
      default:
        return [const Color(0xFF667eea), const Color(0xFF764ba2)];
    }
  }

  String _getPeriodEmoji(String period) {
    switch (period) {
      case '8 AM':
        return '🌅';
      case '12 PM':
        return '☀️';
      case '6 PM':
        return '🌆';
      case '2 AM':
        return '🌙';
      default:
        return '🕐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final periods = ['8 AM', '12 PM', '6 PM', '2 AM'];
    final chartHeight = (screenHeight * 0.25).clamp(180.0, 250.0);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all((screenWidth * 0.06).clamp(20.0, 28.0)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.85),
                Colors.white.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8E8E93).withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Peak period header
              Row(
                children: [
                  Text(
                    peakEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peak: $peakPeriod',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1F1F21),
                            fontSize: (screenWidth * 0.045).clamp(18.0, 22.0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${activityByPeriods[peakPeriod] ?? 0} messages',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF636366),
                            fontSize: (screenWidth * 0.032).clamp(13.0, 15.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: (screenHeight * 0.03).clamp(20.0, 28.0)),
              
              // Chart bars
              SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: periods.asMap().entries.map((entry) {
                    final index = entry.key;
                    final period = entry.value;
                    final count = activityByPeriods[period] ?? 0;
                    final heightRatio = maxCount > 0 ? (count / maxCount) : 0.0;
                    final isPeak = period == peakPeriod;
                    
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index > 0 ? 8 : 0,
                          right: index < periods.length - 1 ? 8 : 0,
                        ),
                        child: AnimatedBuilder(
                          animation: chartController,
                          builder: (context, child) {
                            final animatedHeight = heightRatio * chartController.value;
                            
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Bar
                                Container(
                                  width: double.infinity,
                                  height: chartHeight * animatedHeight.clamp(0.05, 1.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: _getPeriodGradient(period),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    boxShadow: isPeak
                                        ? [
                                            BoxShadow(
                                              color: _getPeriodGradient(period).first.withOpacity(0.4),
                                              blurRadius: 12,
                                              offset: const Offset(0, -4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: isPeak
                                      ? Center(
                                          child: Text(
                                            _getPeriodEmoji(period),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(height: (screenHeight * 0.01).clamp(8.0, 12.0)),
                                // Time label
                                Text(
                                  period,
                                  style: GoogleFonts.inter(
                                    color: isPeak
                                        ? const Color(0xFF1F1F21)
                                        : const Color(0xFF8A8A8D),
                                    fontSize: (screenWidth * 0.032).clamp(12.0, 14.0),
                                    fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: (screenHeight * 0.005).clamp(4.0, 6.0)),
                                // Count label
                                Text(
                                  '$count',
                                  style: GoogleFonts.inter(
                                    color: isPeak
                                        ? const Color(0xFF1F1F21)
                                        : const Color(0xFF8A8A8D),
                                    fontSize: (screenWidth * 0.028).clamp(11.0, 13.0),
                                    fontWeight: isPeak ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

