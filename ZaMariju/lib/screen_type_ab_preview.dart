import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/screen_subscription.dart';

class TypeABPreviewScreen extends StatefulWidget {
  final VoidCallback onSubscribe;

  const TypeABPreviewScreen({
    super.key,
    required this.onSubscribe,
  });

  @override
  State<TypeABPreviewScreen> createState() => _TypeABPreviewScreenState();
}

class _TypeABPreviewScreenState extends State<TypeABPreviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _geometricController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _geometricController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _geometricController.dispose();
    super.dispose();
  }

  void _showSubscriptionScreen() {
    print('🔴 PREMIUM_DEBUG: TypeABPreviewScreen - _showSubscriptionScreen called');
    print('🔴 PREMIUM_DEBUG: Opening SubscriptionScreen');
    print('🔴 PREMIUM_DEBUG: widget.onSubscribe callback available');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          print('🔴 PREMIUM_DEBUG: Building SubscriptionScreen with onSubscribe callback');
          return SubscriptionScreen(
            onSubscribe: () {
              print('🔴 PREMIUM_DEBUG: SubscriptionScreen onSubscribe callback called from TypeABPreviewScreen');
              widget.onSubscribe();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🔴 PREMIUM_DEBUG: TypeABPreviewScreen build called');
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient - same as AdviceMostAskedScreen
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD8C4E8), // Light purple
                  Color(0xFFE8C8D8), // Soft purple-pink
                  Color(0xFFFFC8C4), // Light coral
                  Color(0xFFFFD4B3), // Soft orange
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
          
          // Geometric patterns
          AnimatedBuilder(
            animation: _geometricController,
            builder: (context, child) {
              return CustomPaint(
                painter: _GeometricPatternPainter(
                  animationValue: _geometricController.value,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Container(),
              );
            },
          ),
          
          // Title (not blurred) - positioned at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: Text(
                  'What advice have you asked ChatGPT for the most?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Preview content (to be blurred)
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  
                  // Advice emoji
                  Container(
                    width: 120,
                    height: 120,
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
                        '💕',
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Advice category
                  Text(
                    'RELATIONSHIPS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Most asked advice
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'How to improve my personal relationships',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Explanation box
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF5).withOpacity(0.93),
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
                      'According to the analysis of your conversations, you have sought advice about personal relationships more than any other topic. This shows that you value human connections...',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF2D2D2D),
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Blur overlay (skip the top title area)
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          
          // Lock and unlock section
          Positioned.fill(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // Lock icon
                  FadeTransition(
                    opacity: _fadeController,
                    child: GestureDetector(
                      onTap: () {
                        print('🔴 PREMIUM_DEBUG: TypeABPreviewScreen - Lock icon tapped');
                        _showSubscriptionScreen();
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.95),
                              Colors.white.withOpacity(0.85),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 25,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: -2,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🔐',
                            style: TextStyle(fontSize: 45),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Unlock text
                  FadeTransition(
                    opacity: _fadeController,
                    child: Text(
                      'Unlock Premium Insights',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  FadeTransition(
                    opacity: _fadeController,
                    child: Text(
                      'Tap to see all your insights',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

// Geometric pattern painter
class _GeometricPatternPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _GeometricPatternPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final numShapes = 8;
    
    for (int i = 0; i < numShapes; i++) {
      final angle = (i * 2 * pi / numShapes) + (animationValue * 2 * pi);
      final centerX = size.width / 2 + cos(angle) * (size.width * 0.3);
      final centerY = size.height / 2 + sin(angle) * (size.height * 0.3);
      final timeOffset = animationValue * 2 * pi + (i * pi / 4);
      final scale = 0.5 + 0.5 * sin(timeOffset);
      
      // Draw star shape
      final path = Path();
      final radius = 20 * scale;
      
      for (int j = 0; j < 10; j++) {
        final starAngle = (j * pi / 5) - (pi / 2);
        final r = (j % 2 == 0) ? radius : radius * 0.4;
        final x = centerX + cos(starAngle) * r;
        final y = centerY + sin(starAngle) * r;
        
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

