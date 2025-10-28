import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class RandomQuestionScreen extends StatefulWidget {
  final String randomQuestion;
  final int averageResponseTime; // in seconds

  const RandomQuestionScreen({
    super.key,
    required this.randomQuestion,
    required this.averageResponseTime,
  });

  @override
  State<RandomQuestionScreen> createState() => _RandomQuestionScreenState();
}

class _RandomQuestionScreenState extends State<RandomQuestionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _questionController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _questionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _particlesController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    _fadeController.forward();
    _questionController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _questionController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          
          // Animated particles/sparkles
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return CustomPaint(
                painter: _QuestionParticlesPainter(_particlesController.value),
                child: Container(),
              );
            },
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          'Quick or Thoughtful ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: (MediaQuery.of(context).size.width * 0.08).clamp(28.0, 36.0),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          '🤔',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.width * 0.08).clamp(28.0, 36.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Response Time Display Card with Geometric Design
                  _AnimatedFade(
                    controller: _fadeController,
                    delay: 0.2,
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
                      child: Column(
                        children: [
                          // Response time display
                          Text(
                            '${widget.averageResponseTime}s',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF667eea),
                              fontSize: (MediaQuery.of(context).size.width * 0.12).clamp(40.0, 52.0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              height: 0.9,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Average Response',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF555555),
                              fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(12.0, 15.0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Progress bar based on response time
                          Container(
                            width: double.infinity,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF667eea).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (widget.averageResponseTime / 30).clamp(0.0, 1.0), // Scale to 30 seconds max
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF667eea), Color(0xFF8B9AFF)],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Response Speed',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF777777),
                              fontSize: (MediaQuery.of(context).size.width * 0.032).clamp(11.0, 14.0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Question Text Card
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
                        'Of all the profound questions you could ask... you chose THIS masterpiece: "${widget.randomQuestion}". ChatGPT is still processing. The audacity. The pure, unfiltered curiosity. Iconic behavior. Never change. 💀💅🌟',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF555555),
                          fontSize: (MediaQuery.of(context).size.width * 0.038).clamp(14.0, 16.0),
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
                    delay: 0.6,
                    child: Center(
                      child: ShareToStoryButton(
                        shareText: 'My most random question to ChatGPT: "${widget.randomQuestion}" — the audacity! 💀 #ChatGPTWrapped',
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.04),
                ],
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

// Question particles painter - question marks and sparkles floating
class _QuestionParticlesPainter extends CustomPainter {
  final double animationValue;

  _QuestionParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw floating sparkles
    for (int i = 0; i < 30; i++) {
      final x = (i * 37.0) % size.width;
      final y = (i * 23.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.3);
      final twinkle = 0.3 + 0.7 * sin(timeOffset);
      final starSize = 1.0 + (2.0 * twinkle);
      
      // Draw star shape
      _drawStar(canvas, Offset(x, y), starSize, paint..color = Colors.white.withOpacity(twinkle * 0.8));
    }
    
    // Add floating question marks and thought bubbles
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < 12; i++) {
      final x = (i * 73.0 + 20) % size.width;
      final baseY = (i * 89.0 + 30) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.5);
      final float = sin(timeOffset) * 20;
      final y = baseY + float;
      final opacity = 0.15 + 0.25 * sin(timeOffset);
      
      final icons = ['🤔', '💭', '❓', '💡'];
      
      textPainter.text = TextSpan(
        text: icons[i % icons.length],
        style: TextStyle(
          fontSize: 20 + (i % 3) * 6,
          color: Colors.white.withOpacity(opacity),
        ),
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
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

