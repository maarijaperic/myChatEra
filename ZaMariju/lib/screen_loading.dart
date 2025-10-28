import 'dart:math';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const LoadingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _dotsController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _particlesController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _startSequence();
  }

  Future<void> _startSequence() async {
    _fadeController.forward();
    // Wait for 4 seconds then navigate
    await Future.delayed(const Duration(milliseconds: 4000));
    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _dotsController.dispose();
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
          // Gradient background - same as daily dose
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B35), // Sunrise orange
                  Color(0xFFFF8C42), // Bright orange
                  Color(0xFFFFAA88), // Coral
                  Color(0xFFFF6F91), // Coral pink
                  Color(0xFFB084CC), // Lavender purple
                  Color(0xFF9B72AA), // Deep lavender
                ],
                stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
              ),
            ),
          ),

          // Animated particles
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return CustomPaint(
                painter: _LoadingParticlesPainter(_particlesController.value),
                child: Container(),
              );
            },
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Loading icon
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // "Analyzing your chats" text with animated dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Analyzing your chats',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _dotsController,
                        builder: (context, child) {
                          final progress = _dotsController.value;
                          String dots = '';
                          if (progress < 0.33) {
                            dots = '.';
                          } else if (progress < 0.66) {
                            dots = '..';
                          } else {
                            dots = '...';
                          }
                          return SizedBox(
                            width: 30,
                            child: Text(
                              dots,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Subtle loading bar
                  SizedBox(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedBuilder(
                        animation: _dotsController,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            minHeight: 4,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Particles painter
class _LoadingParticlesPainter extends CustomPainter {
  final double animationValue;

  _LoadingParticlesPainter(this.animationValue);

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
      _drawStar(canvas, Offset(x, y), starSize,
          paint..color = Colors.white.withOpacity(twinkle * 0.7));
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
        paint..color = Colors.white.withOpacity(sparkle * 0.8),
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

