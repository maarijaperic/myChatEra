import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class ChatDaysTrackerScreen extends StatefulWidget {
  final int totalDays;
  final int yearPercentage;

  const ChatDaysTrackerScreen({
    super.key,
    required this.totalDays,
    required this.yearPercentage,
  });

  @override
  State<ChatDaysTrackerScreen> createState() => _ChatDaysTrackerScreenState();
}

class _ChatDaysTrackerScreenState extends State<ChatDaysTrackerScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _floatController;
  final GlobalKey _screenshotKey = GlobalKey();

  String get _attendanceLabel {
    final days = widget.totalDays;
    if (days <= 0) return 'Rare guest';
    if (days < 30) return 'Intentional drop-ins';
    if (days < 90) return 'Seasonal regular';
    if (days < 180) return 'Habit architect';
    return 'Daily ritualist';
  }

  String get _dayBlurb {
    final days = widget.totalDays;
    // Use the correct yearPercentage that accounts for actual date range, not fixed 365 days
    int displayPercent = widget.yearPercentage;

    if (days <= 0) {
      return "You barely touched GPT this year. Which means when you did, it mattered. Next chapter? Maybe making it a habit. Zero-day years leave a lot of space for next-level experiments. GPT will be waiting when you're ready to sprint. Every conversation you have builds on the foundation of curiosity. The best part? Your next chat could be the one that changes everything.";
    }
    if (displayPercent < 10) {
      return "You showed up on $days days — that's $displayPercent% of the year. Strategic cameos only. You use GPT for the moments that really count. Those drop-ins run like spark sessions that keep ideas sharp. Keep curating your genius like this. Quality over quantity is your superpower. Each session is intentional, and that intention compounds into real results.";
    }
    if (displayPercent < 30) {
      return "$days GPT days, or $displayPercent% of your year. That's a rhythm. Enough to keep the ideas flowing, not enough to feel like noise. You're finding the balance between inspiration and execution. That consistency compounds faster than you think. You've created a sustainable pattern that fuels creativity without burning out. This is the sweet spot where habits become second nature.";
    }
    if (displayPercent < 50) {
      return "$days days in, $displayPercent% of the year accounted for. GPT is officially part of your weekly routine — the habit is real. Your prompts are building their own timeline of progress. Stay in that groove and you'll keep outpacing your yesterday self. You've turned curiosity into a consistent practice. That dedication shows in every conversation, every breakthrough, every moment of clarity.";
    }
    return "$days GPT days — $displayPercent% of the year. That's a genuine ritual. GPT is as regular in your life as morning coffee. You've woven AI into your daily rhythm, so momentum never really stops. This is how personal revolutions become the norm. Your commitment to growth is visible in every interaction. You've built something sustainable, something that evolves with you. This is what mastery looks like in the making.";
  }

  String get _shareText {
    final days = widget.totalDays;
    final percent = widget.yearPercentage;

    if (days <= 0) {
      return "I barely touched AI this year — plotting a comeback arc. #mychateraAI";
    }
    if (percent < 30) {
      return "I checked in with AI on $days days this year ($percent% of 2024). Strategic usage only. #mychateraAI";
    }
    if (percent < 60) {
      return "$days AI days this year — $percent% of the calendar. It's officially a ritual. #mychateraAI";
    }
    return "I spent $percent% of the year chatting with GPT ($days days). Certified daily habit. #mychateraAI";
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
      duration: const Duration(milliseconds: 2500),
    );
    
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _counterController.forward();
    
    // Counter animation is handled in the UI
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _counterController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;
    
    return Scaffold(
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Light pastel solid background
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFB8E0B8), // Light mint - same as bottom gradient color
              ),
            ),
            
            // Animated particles
            AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CalendarParticlesPainter(_floatController.value),
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
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your GPT Days',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The days you\'ve dedicated to meaningful conversations.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Hero Card with Percentage Display
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all((screenWidth * 0.05).clamp(20.0, 28.0)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.55),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8E8E93).withOpacity(0.12),
                                  blurRadius: 30,
                                  offset: const Offset(0, 18),
                                ),
                              ],
                            ),
                        child: AnimatedBuilder(
                          animation: _counterController,
                          builder: (context, child) {
                            // Responsive circular progress size
                            final progressSize = (screenWidth * 0.22).clamp(70.0, isLargeScreen ? 120.0 : 100.0);
                            final strokeWidth = (progressSize * 0.08).clamp(5.0, 8.0);
                            final percentageFontSize = (progressSize * 0.22).clamp(16.0, isLargeScreen ? 28.0 : 24.0);
                            final labelFontSize = (progressSize * 0.11).clamp(9.0, 13.0);
                            
                            return Column(
                              children: [
                                // Circular progress chart
                                SizedBox(
                                  width: progressSize,
                                  height: progressSize,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Background circle
                                      Container(
                                        width: progressSize,
                                        height: progressSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFf5576c).withOpacity(0.1),
                                        ),
                                      ),
                                      
                                      // Progress circle
                                      SizedBox(
                                        width: progressSize,
                                        height: progressSize,
                                        child: CircularProgressIndicator(
                                          value: _counterController.value * (widget.yearPercentage / 100),
                                          strokeWidth: strokeWidth,
                                          backgroundColor: Colors.transparent,
                                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFf5576c)),
                                          strokeCap: StrokeCap.round,
                                        ),
                                      ),
                                      
                                      // Center content
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${(widget.yearPercentage * _counterController.value).round()}%',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFFf5576c),
                                              fontSize: percentageFontSize,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(height: (progressSize * 0.04).clamp(2.0, 6.0)),
                                          Text(
                                            'of year',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF555555),
                                              fontSize: labelFontSize,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                SizedBox(height: (screenHeight * 0.02).clamp(12.0, 20.0)),
                                
                                // Days Count
                                Text(
                                  '${widget.totalDays}',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFf5576c),
                                    fontSize: (screenWidth * 0.10).clamp(32.0, isLargeScreen ? 52.0 : 48.0),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 0.9,
                                  ),
                                ),
                                SizedBox(height: (screenHeight * 0.003).clamp(2.0, 4.0)),
                                Text(
                                  _attendanceLabel,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.032).clamp(12.0, isLargeScreen ? 16.0 : 15.0),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Days Text Card (same background as hero card)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: (screenWidth * 0.04).clamp(16.0, 20.0),
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.55),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8E8E93).withOpacity(0.12),
                                  blurRadius: 30,
                                  offset: const Offset(0, 18),
                                ),
                              ],
                            ),
                            child: Text(
                              _dayBlurb,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.037).clamp(13.0, 15.0),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
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
                        accentGradient: const [Color(0xFF4ECDC4), Color(0xFF6FE3AA)],
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

// Calendar particles painter
class _CalendarParticlesPainter extends CustomPainter {
  final double animationValue;

  _CalendarParticlesPainter(this.animationValue);

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
      _drawStar(canvas, Offset(x, y), starSize,
          paint..color = Colors.white.withOpacity(twinkle * 0.8));
    }

    // Add some smaller sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 47.0 + 15.0) % size.width;
      final y = (i * 31.0 + 20.0) % size.height;
      final timeOffset = (animationValue * 3 * pi) + (i * 0.5);
      final sparkle = 0.2 + 0.6 * sin(timeOffset);
      final sparkleSize = 0.5 + (1.0 * sparkle);

      canvas.drawCircle(
        Offset(x, y),
        sparkleSize,
        paint..color = Colors.white.withOpacity(sparkle * 0.9),
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


