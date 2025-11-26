import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class TypeABPersonalityScreen extends StatefulWidget {
  final String question;
  final String personalityType;
  final String typeEmoji;
  final int typeAPercentage;
  final int typeBPercentage;
  final String explanation;
  final String subtitle;

  const TypeABPersonalityScreen({
    super.key,
    required this.question,
    required this.personalityType,
    required this.typeEmoji,
    required this.typeAPercentage,
    required this.typeBPercentage,
    required this.explanation,
    required this.subtitle,
  });

  @override
  State<TypeABPersonalityScreen> createState() => _TypeABPersonalityScreenState();
}

class _TypeABPersonalityScreenState extends State<TypeABPersonalityScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chartController;
  late AnimationController _particlesController;
  final GlobalKey _screenshotKey = GlobalKey();

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
          // Soft pastel gradient background (like Share with People)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF5FB),
                  Color(0xFFF4F1FF),
                  Color(0xFFEFF6FF),
                  Color(0xFFEAF9FF),
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
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Header + hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Type A or Type B?',
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
                            'Discover your personality type based on your ChatGPT behavior.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          _TypeABHeroCard(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            chartController: _chartController,
                            typeAPercentage: widget.typeAPercentage,
                            typeBPercentage: widget.typeBPercentage,
                            personalityType: widget.personalityType,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Message card (like Share with People)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.05).clamp(20.0, 24.0)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFFFF), Color(0xFFF6F7FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
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
                            Text(
                              '${widget.explanation} Understanding your personality type helps you leverage your strengths and work on areas that need growth.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: SmallShareToStoryButton(
                        shareText: 'ChatGPT says I\'m ${widget.personalityType} (${widget.typeAPercentage}% Type A, ${widget.typeBPercentage}% Type B). ${widget.typeEmoji} #ChatGPTWrapped',
                        screenshotKey: _screenshotKey,
                        accentGradient: const [Color(0xFFFF8FB1), Color(0xFFFFB5D8)],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Type A/B Hero Card (like Share Hero Card)
class _TypeABHeroCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final AnimationController chartController;
  final int typeAPercentage;
  final int typeBPercentage;
  final String personalityType;

  const _TypeABHeroCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.chartController,
    required this.typeAPercentage,
    required this.typeBPercentage,
    required this.personalityType,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.04).clamp(16.0, isLargeScreen ? 24.0 : 20.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(20.0, 28.0)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.75),
                Colors.white.withOpacity(0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8E8E93).withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              // Two circular charts side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Type A Chart
                  _CircularProgressChart(
                    controller: chartController,
                    percentage: typeAPercentage,
                    label: 'Type A',
                    color: const Color(0xFFFF6B35),
                    icon: Icons.flash_on_rounded,
                  ),
                  
                  // Type B Chart
                  _CircularProgressChart(
                    controller: chartController,
                    percentage: typeBPercentage,
                    label: 'Type B',
                    color: const Color(0xFF4ECDC4),
                    icon: Icons.spa_rounded,
                  ),
                ],
              ),
              
              SizedBox(height: (screenHeight * 0.015).clamp(12.0, 18.0)),
              
              // Personality Type Result
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.05).clamp(16.0, 20.0),
                  vertical: (screenHeight * 0.01).clamp(8.0, 12.0),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: typeAPercentage > typeBPercentage
                        ? [const Color(0xFFFF6B35), const Color(0xFFFF8A65)]
                        : [const Color(0xFF4ECDC4), const Color(0xFF7EDDD6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  personalityType,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: (screenWidth * 0.05).clamp(20.0, isLargeScreen ? 28.0 : 24.0),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;
    final chartSize = (screenWidth * 0.18).clamp(70.0, isLargeScreen ? 110.0 : 100.0);
    final strokeWidth = (chartSize * 0.07).clamp(5.0, 8.0);
    final iconSize = (chartSize * 0.22).clamp(14.0, isLargeScreen ? 24.0 : 20.0);
    final percentageFontSize = (chartSize * 0.16).clamp(12.0, isLargeScreen ? 20.0 : 18.0);
    final labelFontSize = (chartSize * 0.12).clamp(9.0, isLargeScreen ? 14.0 : 12.0);
    
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
                      strokeWidth: strokeWidth,
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
                        size: iconSize,
                      ),
                      SizedBox(height: (chartSize * 0.03).clamp(2.0, 6.0)),
                      Text(
                        '$animatedPercentage%',
                        style: GoogleFonts.inter(
                          color: color,
                          fontSize: percentageFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: (screenHeight * 0.012).clamp(8.0, 14.0)),
            
            // Label
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF555555),
                fontSize: labelFontSize,
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
