import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class PastLifePersonaScreen extends StatefulWidget {
  final String question;
  final String personaTitle;
  final String personaEmoji;
  final String era;
  final String description;
  final String subtitle;

  const PastLifePersonaScreen({
    super.key,
    required this.question,
    required this.personaTitle,
    required this.personaEmoji,
    required this.era,
    required this.description,
    required this.subtitle,
  });

  @override
  State<PastLifePersonaScreen> createState() => _PastLifePersonaScreenState();
}

class _PastLifePersonaScreenState extends State<PastLifePersonaScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;
  
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
          // Pastel brown gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF5E6D3), // Very light pastel brown
                  Color(0xFFE8D5C4), // Light pastel brown
                  Color(0xFFDCC9B5), // Soft pastel brown
                  Color(0xFFD0BDA6), // Pastel brown
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
                painter: _PastLifeParticlesPainter(_bubblesController.value),
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
                      child: Text(
                        'Who were you in a past life?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: (screenWidth * 0.058).clamp(16.0, screenWidth > 600 ? 28.0 : 26.0),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          height: 1.1,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Past Life Persona Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: (screenWidth * 0.04).clamp(12.0, 16.0)),
                        padding: EdgeInsets.all((screenWidth * 0.045).clamp(16.0, 20.0)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(20.0, 28.0)),
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
                            // Top Label (Tag) - A PAST LIFE PERSONA
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: (screenWidth * 0.035).clamp(10.0, 14.0),
                                vertical: (screenWidth * 0.012).clamp(4.0, 6.0),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6E9DA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'A PAST LIFE PERSONA',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF8B7E74),
                                  fontSize: (screenWidth * 0.03).clamp(11.0, 12.0),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: (screenHeight * 0.01).clamp(8.0, 12.0)),
                            
                            // Subheader Line - Era
                            Text(
                              widget.era,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFC08A58),
                                fontSize: (screenWidth * 0.035).clamp(13.0, 14.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                                height: 1.2,
                              ),
                            ),
                            
                            SizedBox(height: (screenHeight * 0.015).clamp(10.0, 16.0)),
                            
                            // Main Title - Persona Title with clock emoji
                            Text(
                              '${widget.personaTitle} 🕐',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF3C2F25),
                                fontSize: (screenWidth * 0.048).clamp(18.0, 20.0),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                                height: 1.3,
                              ),
                            ),
                            
                            SizedBox(height: (screenHeight * 0.02).clamp(12.0, 20.0)),
                            
                            // Body Text
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: screenWidth * 0.9,
                              ),
                              child: Text(
                                widget.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF4A4A4A),
                                  fontSize: (screenWidth * 0.038).clamp(14.0, 15.0),
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: 0.2,
                                ),
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
                          widget.description,
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
                          shareText: 'In my past life, I was a ${widget.personaTitle} in ${widget.era}. ${widget.subtitle} ✨ #ChatGPTWrapped',
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

// Past Life particles painter - bubbles and sparkles floating
class _PastLifeParticlesPainter extends CustomPainter {
  final double animationValue;

  _PastLifeParticlesPainter(this.animationValue);

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