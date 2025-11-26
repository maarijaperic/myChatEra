import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

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
  late AnimationController _particlesController;
  final GlobalKey _screenshotKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _particlesController.dispose();
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
          
          // Subtle animated particles (like Share with People)
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
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Header + hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your Past Life',
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
                            widget.question,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _PastLifeHeroCard(
                            screenWidth: screenWidth,
                            personaTitle: widget.personaTitle,
                            personaEmoji: widget.personaEmoji,
                            era: widget.era,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Message card (like Share with People)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.04).clamp(18.0, 20.0)),
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
                        child: Text(
                          '${widget.description} Exploring your past life persona offers a unique perspective on your current personality and interests. These insights can reveal patterns and traits that have carried through time, helping you understand yourself on a deeper level. Embrace the wisdom of your past self and let it guide your present journey.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.036).clamp(13.0, 15.0),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: SmallShareToStoryButton(
                        shareText: 'In my past life, I was a ${widget.personaTitle} in ${widget.era}. ${widget.subtitle} ✨ #ChatGPTWrapped',
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

// Past Life Hero Card (like Share Hero Card)
class _PastLifeHeroCard extends StatelessWidget {
  final double screenWidth;
  final String personaTitle;
  final String personaEmoji;
  final String era;

  const _PastLifeHeroCard({
    required this.screenWidth,
    required this.personaTitle,
    required this.personaEmoji,
    required this.era,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.035).clamp(14.0, isLargeScreen ? 20.0 : 18.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.055).clamp(18.0, 24.0)),
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
              // Emoji
              Text(
                personaEmoji,
                style: TextStyle(
                  fontSize: (screenWidth * 0.09).clamp(36.0, isLargeScreen ? 48.0 : 46.0),
                ),
              ),
              SizedBox(height: (screenWidth * 0.025).clamp(10.0, 14.0)),
              // Era
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6E9DA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  era.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8B7E74),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Persona Title
              Text(
                personaTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF3C2F25),
                  fontSize: (screenWidth * 0.048).clamp(18.0, isLargeScreen ? 26.0 : 22.0),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Subtle particles painter (like Share with People)
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
