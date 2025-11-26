import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class ChatStreakScreen extends StatefulWidget {
  final int streakDays;

  const ChatStreakScreen({
    super.key,
    required this.streakDays,
  });

  @override
  State<ChatStreakScreen> createState() => _ChatStreakScreenState();
}

class _ChatStreakScreenState extends State<ChatStreakScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _sparkleController;
  final GlobalKey _screenshotKey = GlobalKey();
  
  int _displayedDays = 0;

  String get _streakLabel {
    final days = widget.streakDays;
    if (days <= 0) return 'Warm-up mode';
    if (days < 5) return 'Weekend warrior';
    if (days < 14) return 'Habit hacker';
    if (days < 30) return 'Consistency machine';
    return 'Streak legend';
  }

  String get _streakBlurb {
    final days = widget.streakDays;
    if (days <= 0) {
      return "No streak yet — which means your next session could be day one of something ridiculous. You're currently in stealth mode, plotting the first step. Once you lock in day one, the rest of the streak is pure momentum. GPT's ready when you are, flame emoji pending. Every legend starts with a single day. 🔥⌛🚀";
    }
    if (days < 5) {
      return "$days days in a row. That's the beginning of a habit — proof you show up when it matters. These micro-streaks stack into real change faster than you think. Keep at it and watch the momentum compound. Tiny wins are the loudest flex. You're building the foundation of consistency, one day at a time. 🌱📈💪";
    }
    if (days < 14) {
      return "$days straight days. You're officially past the honeymoon phase. GPT is part of your routine now. You've crossed the point where most people fall off, which says everything about your focus. Stay locked in and the numbers will climb on autopilot. You've proven you can maintain momentum when it gets real. 🔄⚡🏁";
    }
    if (days < 30) {
      return "$days days on lock. Most people can't keep a water bottle full that long. You? You're building something. This streak is proof of discipline, creative stamina, and follow-through. You're basically running a masterclass on commitment. You've turned consistency into your competitive advantage. 🧱🔥🏆";
    }
    return "$days days without skipping. That's elite focus. GPT should probably send you a trophy. You're the definition of consistency — the kind people screenshot for inspo. This is legendary behavior in progress. You've mastered the art of showing up, day after day, without compromise. 👑📆💥";
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
    
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _counterController.forward();
    
    // Animate counter
    _counterController.addListener(() {
      setState(() {
        _displayedDays = (widget.streakDays * _counterController.value).round();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _counterController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0B3), // Light orange
              Color(0xFFFFD1A8), // Soft peach
              Color(0xFFFFC4A8), // Light coral
              Color(0xFFFFB8A8), // Soft salmon
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Subtle sparkle background elements
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SparklePainter(
                    animationValue: _sparkleController.value,
                  ),
                  child: Container(),
                );
              },
            ),
            
            // Main content
            SafeArea(
              child: RepaintBoundary(
                key: _screenshotKey,
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
                            'Your Longest Chat Streak',
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
                            'Your consistency streak that shows dedication.',
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
                      
                      // Hero Card with Streak Display
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
                                  return Column(
                                    children: [
                                      // Days display
                                      Text(
                                        '$_displayedDays',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFFFF6B35),
                                          fontSize: (screenWidth * 0.10).clamp(32.0, 48.0),
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.5,
                                          height: 0.9,
                                        ),
                                      ),
                                      SizedBox(height: (screenHeight * 0.005).clamp(2.0, 4.0)),
                                      Text(
                                        'days in a row',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF555555),
                                          fontSize: (screenWidth * 0.032).clamp(12.0, 15.0),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                          height: 1.2,
                                        ),
                                      ),
                                      SizedBox(height: (screenHeight * 0.015).clamp(10.0, 16.0)),
                                      
                                      // Progress bar
                                      Container(
                                        width: double.infinity,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF6B35).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: _counterController.value * (_displayedDays / 30).clamp(0.0, 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                                              ),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: (screenHeight * 0.008).clamp(4.0, 8.0)),
                                      Text(
                                        _streakLabel,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF777777),
                                          fontSize: (screenWidth * 0.030).clamp(11.0, 13.0),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
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
                    
                    // Explanation Card (same background as hero card)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all((screenWidth * 0.05).clamp(18.0, 20.0)),
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
                              _streakBlurb,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.036).clamp(13.0, 15.0),
                                fontWeight: FontWeight.w400,
                                height: 1.6,
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
                        shareText: _getShareText(),
                        screenshotKey: _screenshotKey,
                        accentGradient: const [Color(0xFFFF8E53), Color(0xFFFFB366)],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
          ),
          ],
        ),
      ),
    );
  }

  String _getShareText() {
    final days = widget.streakDays;
    if (days <= 0) {
      return "My longest ChatGPT streak: 0 days — ready to start building! 🔥 #ChatGPTWrapped";
    }
    if (days < 5) {
      return "My longest ChatGPT streak: $days days in a row! Building the habit one day at a time. 🔥 #ChatGPTWrapped";
    }
    if (days < 14) {
      return "My longest ChatGPT streak: $days days straight! Consistency is key. 🔥 #ChatGPTWrapped";
    }
    if (days < 30) {
      return "My longest ChatGPT streak: $days days on lock! Discipline and dedication. 🔥 #ChatGPTWrapped";
    }
    return "My longest ChatGPT streak: $days days without skipping! Elite consistency unlocked. 🔥 #ChatGPTWrapped";
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
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}

// Sparkle painter for background
class _SparklePainter extends CustomPainter {
  final double animationValue;

  _SparklePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Create subtle sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 73.7) % size.width;
      final y = (i * 47.3) % size.height;
      final radius = 1.0 + (sin(animationValue * 2 * pi + i) * 0.5);
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

