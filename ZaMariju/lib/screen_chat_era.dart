import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class ChatEraScreen extends StatefulWidget {
  final int totalHours;
  final int totalMinutes;

  const ChatEraScreen({
    super.key,
    required this.totalHours,
    required this.totalMinutes,
  });

  @override
  State<ChatEraScreen> createState() => _ChatEraScreenState();
}

class _ChatEraScreenState extends State<ChatEraScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _floatController;
  
  int _displayedHours = 0;
  int _displayedMinutes = 0;

  int get _totalMinutesRaw => (widget.totalHours * 60) + widget.totalMinutes;

  double get _totalHoursPrecise => widget.totalHours + (widget.totalMinutes / 60.0);

  String get _commitmentLabel {
    final minutes = _totalMinutesRaw;
    if (minutes <= 0) return 'Getting started';
    if (minutes < 180) return 'Drop-in collaborator';
    if (minutes < 600) return 'Steady strategist';
    if (minutes < 1200) return 'Dedicated builder';
    return 'All-in cofounder vibes';
  }

  String get _eraDescription {
    final minutes = _totalMinutesRaw;
    final hours = widget.totalHours;
    final mins = widget.totalMinutes;

    if (minutes <= 0) {
      return "You clocked 0 minutes with GPT this year — which basically means every message was a high-stakes mission. Next season, let's see what happens when you stay for the afterparty. Your next deep dive could set the tone for the whole year. Consider it the prologue before the storyline goes cinematic. 🌱✨🔮";
    }
    if (minutes < 180) {
      return "You spent ${hours}h ${mins}m with GPT — quick check-ins that pack a punch. You drop in, get precise answers, and bounce. No fluff, just clarity on demand. Consider it your on-call genius hotline. It's the perfect cadence for quick wins without the mental baggage. ☎️🧠⚡";
    }
    if (minutes < 600) {
      return "${hours}h ${mins}m logged with GPT. That's a steady collab routine — enough time to brainstorm, refine, and ship ideas. You're building momentum one prompt at a time. Little rituals like this are how big wins stack up. That reliable cadence keeps curiosity and output in sync. 📚🚀💡";
    }
    if (minutes < 1200) {
      return "${hours}h ${mins}m this year! GPT is basically your creative partner. You use it to think, plan, and iterate like a pro. That's a serious investment in your future self. You're running a full-on lab powered by curiosity. It’s like holding strategy sessions with your future self on speed dial. 🔧🧪🌟";
    }
    return "${hours}h ${mins}m together. Elite tier. GPT isn't just a tool anymore — it's the extra brain cell you unlocked to keep up with your ambition. Cofounder energy detected. You're basically co-writing your future with AI. At this level, you're architecting systems, not just asking questions. 👯‍♂️🤖💥";
  }

  String get _shareText {
    final hoursPrecise = _totalHoursPrecise;
    if (_totalMinutesRaw <= 0) {
      return "I barely clocked any time with ChatGPT this year — saving my prompts for mission-critical moments. #ChatGPTWrapped";
    }
    if (_totalMinutesRaw < 180) {
      return "Spent ${hoursPrecise.toStringAsFixed(1)} hours with ChatGPT. Tactical check-ins only. #ChatGPTWrapped";
    }
    if (_totalMinutesRaw < 600) {
      return "Logged ${hoursPrecise.toStringAsFixed(1)} hours with ChatGPT — my secret productivity ritual. #ChatGPTWrapped";
    }
    if (_totalMinutesRaw < 1200) {
      return "${hoursPrecise.toStringAsFixed(1)} hours of GPT collabs this year. That AI is basically on payroll. #ChatGPTWrapped";
    }
    return "Spent ${hoursPrecise.toStringAsFixed(1)} hours with ChatGPT. Cofounder status unlocked. #ChatGPTWrapped";
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
    
    // Animate counter
    _counterController.addListener(() {
      setState(() {
        _displayedHours = (widget.totalHours * _counterController.value).round();
        _displayedMinutes = (widget.totalMinutes * _counterController.value).round();
      });
    });
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
          // Light pastel gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0F2F7), // Very light blue
                  Color(0xFFCCEEF5), // Light blue
                  Color(0xFFB8E8F0), // Soft blue
                  Color(0xFFA3E2EB), // Light blue
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
          
          // Animated particles
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ChatParticlesPainter(_floatController.value),
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
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Chat Era',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: (screenWidth * 0.065).clamp(20.0, 28.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Time Display Card with Circular Progress
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
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
                                // Two circular charts side by side
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Hours Chart
                                    _CircularProgressChart(
                                      controller: _counterController,
                                      value: _displayedHours,
                                      maxValue: 100, // Scale for visualization
                                      label: 'Hours',
                                      color: const Color(0xFF667eea),
                                      icon: Icons.access_time,
                                    ),
                                    
                                    // Minutes Chart
                                    _CircularProgressChart(
                                      controller: _counterController,
                                      value: _displayedMinutes,
                                      maxValue: 60, // Scale for visualization
                                      label: 'Minutes',
                                      color: const Color(0xFF4ECDC4),
                                      icon: Icons.timer,
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Time Result
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF667eea), Color(0xFF4ECDC4)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${widget.totalHours}h ${widget.totalMinutes}m',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: (screenWidth * 0.055).clamp(20.0, 24.0),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _commitmentLabel,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF3A506B),
                                    fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Description
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
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          _eraDescription,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Share button - floating outside of cards
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 1.0,
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

// Chat particles painter
class _ChatParticlesPainter extends CustomPainter {
  final double animationValue;

  _ChatParticlesPainter(this.animationValue);

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
      double twinkle = 0.3 + 0.7 * sin(timeOffset);
      twinkle = twinkle.clamp(0.0, 1.0);
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
      double sparkle = 0.2 + 0.6 * sin(timeOffset);
      sparkle = sparkle.clamp(0.0, 1.0);
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

// Circular Progress Chart Widget
class _CircularProgressChart extends StatelessWidget {
  final AnimationController controller;
  final int value;
  final int maxValue;
  final String label;
  final Color color;
  final IconData icon;

  const _CircularProgressChart({
    required this.controller,
    required this.value,
    required this.maxValue,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartSize = (screenWidth * 0.22).clamp(90.0, 110.0);
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animatedValue = (value * controller.value).round();
        final percentage = (animatedValue / maxValue).clamp(0.0, 1.0);
        
        return Column(
          children: [
            // Circular Progress
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: chartSize,
                    height: chartSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.1),
                    ),
                  ),
                  
                  // Progress circle
                  SizedBox(
                    width: chartSize,
                    height: chartSize,
                    child: CircularProgressIndicator(
                      value: controller.value * percentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  
                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$animatedValue',
                        style: GoogleFonts.inter(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Label
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF555555),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        );
      },
    );
  }
}

