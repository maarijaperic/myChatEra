import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieTitleScreen extends StatefulWidget {
  final String movieTitle;
  final String explanation;
  final int releaseYear;
  final String? question;
  final String? subtitle;

  const MovieTitleScreen({
    super.key,
    required this.movieTitle,
    required this.explanation,
    required this.releaseYear,
    this.question,
    this.subtitle,
  });

  @override
  State<MovieTitleScreen> createState() => _MovieTitleScreenState();
}

class _MovieTitleScreenState extends State<MovieTitleScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
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
    final isLargeScreen = screenWidth > 600;
    
    // Responsive padding
    final horizontalPadding = (screenWidth * 0.06).clamp(16.0, 32.0);
    final verticalPadding = (screenHeight * 0.025).clamp(16.0, 24.0);
    
    // Responsive spacing
    final topSpacing = (screenHeight * 0.08).clamp(20.0, 60.0);
    final sectionSpacing = (screenHeight * 0.04).clamp(16.0, 32.0);
    final largeSpacing = (screenHeight * 0.06).clamp(20.0, 48.0);
    final mediumSpacing = (screenHeight * 0.03).clamp(12.0, 24.0);
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Light purple/pink gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF0F8), // Very light pink
                  Color(0xFFFFE5F0), // Light pink
                  Color(0xFFFFD6E8), // Soft pink
                  Color(0xFFFFC8E0), // Pastel pink
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
                painter: _MovieParticlesPainter(_particlesController.value),
                child: Container(),
              );
            },
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Column(
                  children: [
                    SizedBox(height: topSpacing),
                    
                    // Question/Title
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              widget.question ?? 'Your Life as a Movie Title 🎬',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: (screenWidth * 0.065).clamp(18.0, isLargeScreen ? 32.0 : 28.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: largeSpacing),
                    
                    // Movie Title Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all((screenWidth * 0.035).clamp(12.0, 20.0)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular((screenWidth * 0.05).clamp(18.0, 24.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
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
                            // Movie emoji
                            Text(
                              '🎬',
                              style: TextStyle(
                                fontSize: (screenWidth * 0.08).clamp(28.0, isLargeScreen ? 48.0 : 40.0),
                              ),
                            ),
                            SizedBox(height: (screenHeight * 0.015).clamp(10.0, 16.0)),
                            
                            // Movie title
                            Text(
                              widget.movieTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFF6B9D),
                                fontSize: (screenWidth * 0.055).clamp(18.0, isLargeScreen ? 28.0 : 24.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: (screenHeight * 0.008).clamp(4.0, 8.0)),
                            
                            // Release year
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: (screenWidth * 0.04).clamp(14.0, 20.0),
                                vertical: (screenHeight * 0.008).clamp(4.0, 8.0),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular((screenWidth * 0.03).clamp(12.0, 16.0)),
                              ),
                              child: Text(
                                '${widget.releaseYear}',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFFF6B9D),
                                  fontSize: (screenWidth * 0.035).clamp(11.0, isLargeScreen ? 18.0 : 16.0),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: mediumSpacing),
                    
                    // Explanation Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.035).clamp(12.0, 20.0)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular((screenWidth * 0.05).clamp(18.0, 24.0)),
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
                            fontSize: (screenWidth * 0.038).clamp(13.0, isLargeScreen ? 18.0 : 16.0),
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: mediumSpacing),
                    
                    // Subtitle
                    if (widget.subtitle != null)
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.6,
                        child: Text(
                          widget.subtitle!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF777777),
                            fontSize: (screenWidth * 0.035).clamp(12.0, isLargeScreen ? 18.0 : 16.0),
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    
                    SizedBox(height: sectionSpacing),
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

// Subtle particles painter for movie screen
class _MovieParticlesPainter extends CustomPainter {
  final double animationValue;

  _MovieParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B9D).withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // Draw subtle floating particles
    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i + (size.width / 16);
      final y = size.height * 0.2 +
          (size.height * 0.6) *
              (0.5 + 0.5 * sin(animationValue * 2 * pi + i * pi / 4));
      final radius = 3.0 + 2.0 * sin(animationValue * 2 * pi + i * pi / 3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_MovieParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
