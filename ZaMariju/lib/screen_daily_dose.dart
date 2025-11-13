import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

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
  
  int _displayedMessages = 0;

  String get _activityLabel {
    final messages = widget.messagesPerDay;
    if (messages <= 0) return 'Starting the journey';
    if (messages < 10) return 'Intentional check-ins';
    if (messages < 30) return 'Steady daily rhythm';
    if (messages < 60) return 'Productivity groove';
    return 'GPT power user';
  }

  String get _dailyDoseBlurb {
    final messages = widget.messagesPerDay;
    if (messages <= 0) {
      return "You averaged 0 messages a day — which means you only show up when it's time for the big questions. You're saving your prompt power for the moments that matter most. When you do drop in, GPT gets the good stuff with zero warm-up. Every log-in becomes a deliberate power move that hits with precision. When you spark it up again, it’ll feel like a comeback montage. 🧠🎯✨";
    }
    if (messages < 10) {
      return "You average $messages messages a day — the thoughtful check-in energy is strong. Every chat feels intentional, like a mini strategy session. Keep that laser focus and let GPT handle the heavy lifting. Your prompts move the needle without draining your battery. That’s the kind of calm consistency that wins long term. 🔍💬🙌";
    }
    if (messages < 30) {
      return "You average $messages messages every day. That's a steady coworking rhythm with GPT — consistent enough to build momentum, flexible enough to keep things fun. You're building a habit that keeps ideas fresh and progress moving. Those daily reps are quietly building your personal operating system. You’re crafting wins that future-you will brag about. 📈🤝✨";
    }
    if (messages < 60) {
      return "You average $messages messages a day. Translation: GPT is basically on your team. You're iterating, refining, and thinking out loud like a pro problem-solver. Hustle recognized and fully backed by AI. You’re turning quick ideas into fully baked plans before they cool off. That pace is how visionaries stay ahead of the curve. 🚀🧩🔥";
    }
    return "You average $messages messages a day. That's elite power-user territory — GPT is basically your digital co-founder at this point. You're running sprints, brainstorming, and shipping ideas on demand. Absolute main-character productivity. You’re outlining the sequel while everyone else is still pitching the trailer. Keep that throttle open; breakthroughs are basically on subscription now. 👑⚡🛠️";
  }

  String get _shareText {
    final messages = widget.messagesPerDay;
    if (messages <= 0) {
      return "I barely messaged ChatGPT this year, which means every convo was a boss-level move. Next year, I'm unleashing the questions. #ChatGPTWrapped";
    }
    if (messages < 10) {
      return "I drop around $messages thoughtful messages a day into ChatGPT — intentional check-ins only. #ChatGPTWrapped";
    }
    if (messages < 30) {
      return "I average $messages messages a day with ChatGPT. Consistent, curious, and always building. #ChatGPTWrapped";
    }
    if (messages < 60) {
      return "I send $messages ChatGPT messages every day. GPT is literally on my team. #ChatGPTWrapped";
    }
    return "$messages ChatGPT messages a day. Certified power user status unlocked. #ChatGPTWrapped";
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        children: [
          // Light pink gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF0F5), // Very light pink
                  Color(0xFFFFE4E9), // Light pink
                  Color(0xFFFFD1DC), // Soft pink
                  Color(0xFFFFB6C1), // Light pink
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Daily Dose',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: (screenWidth * 0.075).clamp(22.0, 32.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Number Display Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _counterController,
                          builder: (context, child) {
                            return Column(
                              children: [
                                // Large number display
                                Text(
                                  '$_displayedMessages',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFFF6B35),
                                    fontSize: (screenWidth * 0.12).clamp(40.0, 52.0),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 0.9,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'messages/day',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.035).clamp(12.0, 15.0),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Progress bar
                                Container(
                                  width: double.infinity,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: (_displayedMessages / 100).clamp(0.0, 1.0),
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
                                const SizedBox(height: 12),
                                Text(
                                  _activityLabel,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF777777),
                                    fontSize: (screenWidth * 0.032).clamp(11.0, 14.0),
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
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Text Description Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          _dailyDoseBlurb,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Share button - floating outside of cards
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.8,
                      child: Center(
                        child: ShareToStoryButton(
                          shareText: _shareText,
                          primaryColor: const Color(0xFFE0F2F7),
                          secondaryColor: const Color(0xFFCCEEF5),
                        ),
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

