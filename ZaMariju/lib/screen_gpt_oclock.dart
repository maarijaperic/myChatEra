import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class GptOClockScreen extends StatefulWidget {
  final String peakTime; // 'night', 'morning', 'afternoon', 'lunch break', etc.
  final int peakHour; // 0-23
  final String timeDescription; // e.g., "at night", "morning", "lunch break"
  final String timeEmoji; // 🌙, ☀️, 🌅, etc.

  const GptOClockScreen({
    super.key,
    required this.peakTime,
    required this.peakHour,
    required this.timeDescription,
    required this.timeEmoji,
  });

  @override
  State<GptOClockScreen> createState() => _GptOClockScreenState();
}

class _GptOClockScreenState extends State<GptOClockScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;

  String get _formattedHour {
    final hour = widget.peakHour.clamp(0, 23);
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:00 $suffix';
  }

  String get _timePersona {
    switch (widget.peakTime) {
      case 'morning':
        return 'Sunrise strategist';
      case 'afternoon':
        return 'Daylight decision-maker';
      case 'evening':
        return 'Golden-hour thinker';
      case 'night':
        return 'Moonlight mastermind';
      default:
        if (widget.peakHour >= 0 && widget.peakHour < 5) {
          return 'Night-owl visionary';
        }
        if (widget.peakHour < 12) {
          return 'Early-bird planner';
        }
        if (widget.peakHour < 18) {
          return 'Peak-hour strategist';
        }
        return 'After-hours architect';
    }
  }

  String get _timeBlurb {
    final descriptor = widget.timeDescription;
    final persona = _timePersona;
    final hourString = _formattedHour;

    if (widget.peakHour < 5) {
      return "You're most active ${descriptor.toLowerCase()} at $hourString. While everyone else is asleep, you're building dreams with GPT. $persona energy. The quiet gives your ideas room to breathe and evolve. It's basically your secret lab while the rest of the world resets. That space lets you build without distractions steering the wheel. 🌙🔬✨";
    }
    if (widget.peakHour < 12) {
      return "$hourString is your sweet spot. You start the day by thinking out loud with GPT — clarity before the world even wakes up. $persona unlocked. You’re building direction before the inbox even loads. That early spark keeps your day calibrated. It's how you set intention before the world asks for anything. 🌅🧭⚙️";
    }
    if (widget.peakHour < 18) {
      return "$hourString chats hit different. You carve out daylight to ideate with GPT, turning breaks into breakthroughs. $persona in full effect. These sessions Prime your brain without draining it. Afternoon clarity is your productivity cheat code. You’re the one turning quick pauses into momentum builders. ☀️🧠🎯";
    }
    return "$hourString is prime time. You wind down by spinning up new ideas with GPT. The world gets quiet, your brain gets loud. $persona mode. Night sessions turn reflections into game plans. You're closing out the day with momentum locked in. That’s how you turn evenings into launch pads for tomorrow. 🌆📝🚀";
  }

  String get _shareText {
    final hourString = _formattedHour;
    final persona = _timePersona;
    return "My peak ChatGPT window is $hourString — $persona hours only. #ChatGPTWrapped";
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
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bubblesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
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
                          Flexible(
                            child: Text(
                              'Your Peak Time',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: (screenWidth * 0.065).clamp(20.0, 28.0),
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
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Time Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all((screenWidth * 0.05).clamp(20.0, 28.0)),
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
                        child: Column(
                          children: [
                            // Time display
                            Text(
                              _formattedHour,
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
                              widget.timeDescription,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.035).clamp(12.0, 15.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _timePersona,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.035).clamp(12.0, 15.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Description Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: const EdgeInsets.all(18),
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
                          '${_timeBlurb} ${widget.timeEmoji}',
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
                    
                    // Share button
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