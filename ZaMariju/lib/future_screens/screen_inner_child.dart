import 'dart:math';
import 'package:flutter/material.dart';

class InnerChildScreen extends StatefulWidget {
  final String question;
  final String childMessage;
  final String childEmoji;
  final String healingTip;
  final String subtitle;

  const InnerChildScreen({
    super.key,
    required this.question,
    required this.childMessage,
    required this.childEmoji,
    required this.healingTip,
    required this.subtitle,
  });

  @override
  State<InnerChildScreen> createState() => _InnerChildScreenState();
}

class _InnerChildScreenState extends State<InnerChildScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _mainController;
  late AnimationController _pulseController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _startLoadingSequence();
  }

  Future<void> _startLoadingSequence() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
    _mainController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF89F7FE), // Soft cyan
                  Color(0xFF66A6FF), // Soft blue
                  Color(0xFFA8EDEA), // Mint
                  Color(0xFFFED6E3), // Soft pink
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          
          // Animated soft elements
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return CustomPaint(
                painter: SoftElementsPainter(_floatingController.value),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  
                  // Question
                  Text(
                    widget.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  
                  // Loading or Result content
                  if (_isLoading) ...[
                    // Loading state
                    Column(
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Connecting with your inner child...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Result state
                    FadeTransition(
                      opacity: _mainController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _mainController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Column(
                          children: [
                            // Inner Child Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                '🕊 YOUR INNER CHILD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Child Emoji with pulse animation
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                final scale = 1.0 + (0.08 * sin(_pulseController.value * 2 * pi));
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.4),
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.childEmoji,
                                        style: const TextStyle(fontSize: 65),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Child Message
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                              child: Text(
                                widget.childMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Healing Tip Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '✨ ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        'Healing Tip',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.95),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        ' ✨',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.healingTip,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Subtitle
                            Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SoftElementsPainter extends CustomPainter {
  final double animationValue;

  SoftElementsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw floating soft circles
    final numCircles = 20;
    
    for (int i = 0; i < numCircles; i++) {
      final x = (i * 59.0) % size.width;
      final baseY = (i * 43.0) % size.height;
      final float = sin((animationValue * 2 * pi) + (i * 0.5)) * 30;
      final y = baseY + float;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final pulse = 0.4 + 0.6 * sin(timeOffset);
      final circleSize = (8 + (i % 3) * 5) * pulse;
      
      // Draw soft circles
      canvas.drawCircle(
        Offset(x, y),
        circleSize,
        paint..color = Colors.white.withOpacity(0.2 * pulse),
      );
    }
    
    // Draw stars/sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 71.0 + 30.0) % size.width;
      final y = (i * 47.0 + 20.0) % size.height;
      final timeOffset = (animationValue * 3 * pi) + (i * 0.6);
      final twinkle = 0.3 + 0.7 * sin(timeOffset);
      
      _drawSoftStar(
        canvas,
        Offset(x, y),
        1.5 * twinkle,
        paint..color = Colors.white.withOpacity(twinkle * 0.8),
      );
    }
    
    // Draw gentle waves
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final yOffset = (size.height / 4) * (i + 1) + (animationValue * 50) % 100;
      
      path.moveTo(0, yOffset);
      for (double x = 0; x <= size.width; x += 20) {
        final y = yOffset + sin((x / 50) + (animationValue * 2 * pi) + (i * 1.0)) * 15;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, wavePaint..color = Colors.white.withOpacity(0.08 + i * 0.02));
    }
  }

  void _drawSoftStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size * 2;
    final innerRadius = size;
    
    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2);
      final outerX = center.dx + cos(angle) * outerRadius;
      final outerY = center.dy + sin(angle) * outerRadius;
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      
      final innerAngle = angle + (pi / 4);
      final innerX = center.dx + cos(innerAngle) * innerRadius;
      final innerY = center.dy + sin(innerAngle) * innerRadius;
      path.lineTo(innerX, innerY);
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


























