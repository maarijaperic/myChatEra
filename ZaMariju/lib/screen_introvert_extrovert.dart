import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class IntrovertExtrovertScreen extends StatefulWidget {
  final String question;
  final String personalityType;
  final int introvertPercentage;
  final int extrovertPercentage;
  final String explanation;
  final String subtitle;

  const IntrovertExtrovertScreen({
    super.key,
    required this.question,
    required this.personalityType,
    required this.introvertPercentage,
    required this.extrovertPercentage,
    required this.explanation,
    required this.subtitle,
  });

  @override
  State<IntrovertExtrovertScreen> createState() => _IntrovertExtrovertScreenState();
}

class _IntrovertExtrovertScreenState extends State<IntrovertExtrovertScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chartController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _particlesController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _chartController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chartController.dispose();
    _particlesController.dispose();
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
          
          // Subtle animated particles
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return CustomPaint(
                painter: _SubtleParticlesPainter(_particlesController.value),
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
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Main heading
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Text(
                        'Are you an Introvert or an Extrovert?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: (screenWidth * 0.065).clamp(24.0, 28.0),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          height: 1.3,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Circular Progress Charts Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
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
                        child: Column(
                          children: [
                            // Two circular charts side by side
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Introvert Chart
                                _CircularProgressChart(
                                  controller: _chartController,
                                  percentage: widget.introvertPercentage,
                                  label: 'Introvert',
                                  color: const Color(0xFF667eea),
                                  icon: Icons.nightlight_round,
                                ),
                                
                                // Extrovert Chart
                                _CircularProgressChart(
                                  controller: _chartController,
                                  percentage: widget.extrovertPercentage,
                                  label: 'Extrovert',
                                  color: const Color(0xFFFF6B9D),
                                  icon: Icons.wb_sunny_rounded,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Personality Type Result
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.personalityType == 'AMBIVERT'
                                      ? [const Color(0xFF667eea), const Color(0xFFFF6B9D)]
                                      : widget.introvertPercentage > widget.extrovertPercentage
                                          ? [const Color(0xFF667eea), const Color(0xFF8B9AFF)]
                                          : [const Color(0xFFFF6B9D), const Color(0xFFFF8E9E)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.personalityType,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: (screenWidth * 0.055).clamp(20.0, 24.0),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Explanation Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: const EdgeInsets.all(24),
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
                          widget.explanation,
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
                    
                    // Subtitle
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF777777),
                          fontSize: (screenWidth * 0.035).clamp(13.0, 15.0),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.3,
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
                          shareText: 'ChatGPT says I\'m ${widget.personalityType} (${widget.introvertPercentage}% Introvert, ${widget.extrovertPercentage}% Extrovert). The perfect balance! 🌙☀️ #ChatGPTWrapped',
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

// Circular Progress Chart Widget
class _CircularProgressChart extends StatelessWidget {
  final AnimationController controller;
  final int percentage;
  final String label;
  final Color color;
  final IconData icon;

  const _CircularProgressChart({
    required this.controller,
    required this.percentage,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartSize = (screenWidth * 0.25).clamp(100.0, 120.0);
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animatedPercentage = (percentage * controller.value).round();
        
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
                      value: controller.value * (percentage / 100),
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
                        '$animatedPercentage%',
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

// Subtle particles painter
class _SubtleParticlesPainter extends CustomPainter {
  final double animationValue;

  _SubtleParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw subtle floating dots
    for (int i = 0; i < 20; i++) {
      final x = (i * 47.0) % size.width;
      final y = (i * 31.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final float = 0.3 + 0.4 * sin(timeOffset);
      final dotSize = 1.0 + (1.5 * float);

      canvas.drawCircle(
        Offset(x, y),
        dotSize,
        paint..color = Colors.white.withOpacity(float * 0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}