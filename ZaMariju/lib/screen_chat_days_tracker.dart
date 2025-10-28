import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:gpt_wrapped2/widgets/share_button.dart';

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
    
    return Scaffold(
      body: Stack(
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
                            'Your GPT Days ',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            '📅',
                            style: TextStyle(
                              fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Percentage Display Card with Circular Progress
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
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
                                // Circular progress chart
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Background circle
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFf5576c).withOpacity(0.1),
                                        ),
                                      ),
                                      
                                      // Progress circle
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: CircularProgressIndicator(
                                          value: _counterController.value * (widget.yearPercentage / 100),
                                          strokeWidth: 8,
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
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'of year',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF555555),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Days Count
                                Text(
                                  '${widget.totalDays}',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFf5576c),
                                    fontSize: (screenWidth * 0.12).clamp(40.0, 52.0),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 0.9,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'days visited',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.035).clamp(12.0, 15.0),
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
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Days Text Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
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
                        child: Text(
                          "You've visited GPT on ${widget.totalDays} days — that's ${widget.yearPercentage}% of your year. Consistency is key! Your dedication shows in every conversation. Some people have coffee habits, you have GPT habits. 📅✨",
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
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Share button - floating outside of cards
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.8,
                      child: Center(
                        child: ShareToStoryButton(
                          shareText: 'I visited ChatGPT on ${widget.totalDays} days this year — that\'s ${widget.yearPercentage}% of 2024! 😳 #ChatGPTWrapped',
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

