import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class RoastScreen extends StatefulWidget {
  final String roastText;

  const RoastScreen({
    super.key,
    required this.roastText,
  });

  @override
  State<RoastScreen> createState() => _RoastScreenState();
}

class _RoastScreenState extends State<RoastScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
    
    // Show loading for 2 seconds
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pastel gradient background - more vibrant
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFD4B8), // Light orange
                  Color(0xFFFFBFA8), // Soft coral
                  Color(0xFFFFB8B8), // Light pink
                  Color(0xFFFFB8C8), // Soft rose
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
                painter: _FireParticlesPainter(_floatController.value),
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
                    
                    // Title
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Text(
                        'Roast Me',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Loading or Result content
                    if (_isLoading) ...[
                      // Loading state
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.15),
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Preparing your roast...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.15),
                        ],
                      ),
                    ] else ...[
                      // Fire emoji in white circle
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.0,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFD).withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🔥',
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.04),
                      
                      // Roast text box
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.2,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDF5).withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.roastText,
                            textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Color(0xFF2D2D2D),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.03),
                      
                      // Fun subtitle
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.4,
                        child: Text(
                          'Can you handle the heat? 🔥😂',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.03),
                      
                      // Share button
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.6,
                        child: Center(
                          child: ShareToStoryButton(
                            shareText: 'ChatGPT roasted me and I can\'t even be mad about it. 🔥😂 #ChatGPTWrapped #Roasted',
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.02),
                    ],
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

// Fire particles painter
class _FireParticlesPainter extends CustomPainter {
  final double animationValue;

  _FireParticlesPainter(this.animationValue);

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
    
    // Add fire emojis floating
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < 8; i++) {
      final x = (i * 73.0 + 20) % size.width;
      final baseY = (i * 89.0 + 30) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.5);
      final float = sin(timeOffset) * 20;
      final y = baseY + float;
      final opacity = 0.1 + 0.2 * sin(timeOffset);
      
      textPainter.text = TextSpan(
        text: '🔥',
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
