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
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;
    
    // Responsive padding
    final horizontalPadding = (screenWidth * 0.06).clamp(16.0, 32.0);
    final verticalPadding = (screenHeight * 0.025).clamp(16.0, 24.0);
    
    // Responsive spacing
    final topSpacing = (screenHeight * 0.08).clamp(20.0, 60.0);
    final sectionSpacing = (screenHeight * 0.04).clamp(16.0, 32.0);
    final smallSpacing = (screenHeight * 0.02).clamp(8.0, 16.0);
    
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Column(
                  children: [
                    SizedBox(height: topSpacing),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Your GPT Days',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: (screenWidth * 0.065).clamp(18.0, isLargeScreen ? 32.0 : 28.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: (screenHeight * 0.05).clamp(16.0, 40.0)),
                    
                    // Percentage Display Card with Circular Progress
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all((screenWidth * 0.03).clamp(12.0, 20.0)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(20.0, 28.0)),
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
                            // Responsive circular progress size
                            final progressSize = (screenWidth * 0.25).clamp(80.0, isLargeScreen ? 140.0 : 120.0);
                            final strokeWidth = (progressSize * 0.08).clamp(6.0, 10.0);
                            final percentageFontSize = (progressSize * 0.24).clamp(18.0, isLargeScreen ? 32.0 : 28.0);
                            final labelFontSize = (progressSize * 0.12).clamp(10.0, 14.0);
                            
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
                                
                                SizedBox(height: (screenHeight * 0.03).clamp(16.0, 28.0)),
                                
                                // Days Count
                                Text(
                                  '${widget.totalDays}',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFf5576c),
                                    fontSize: (screenWidth * 0.12).clamp(36.0, isLargeScreen ? 64.0 : 56.0),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 0.9,
                                  ),
                                ),
                                SizedBox(height: (screenHeight * 0.005).clamp(2.0, 6.0)),
                                Text(
                                  'days visited',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.035).clamp(11.0, isLargeScreen ? 18.0 : 16.0),
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
                    
                    SizedBox(height: sectionSpacing),
                    
                    // Days Text Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all((screenWidth * 0.06).clamp(16.0, 28.0)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(20.0, 28.0)),
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
                          "You've visited GPT on ${widget.totalDays} days — that's ${widget.yearPercentage}% of your year. Consistency is key! Your dedication shows in every conversation. Some people have coffee habits, you have GPT habits. Every day you showed up, you invested in yourself and your growth. 📅✨",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.038).clamp(13.0, isLargeScreen ? 18.0 : 16.0),
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: sectionSpacing),
                    
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
                    
                    SizedBox(height: sectionSpacing),
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

