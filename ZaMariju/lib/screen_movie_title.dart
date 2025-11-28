import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

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
  final GlobalKey _screenshotKey = GlobalKey();

  String get _shareText {
    final title = widget.movieTitle;
    final year = widget.releaseYear;
    return 'My life is basically "$title" ($year) according to ChatGPT. 🎬 Plot twist unlocked! #ChatGPTWrapped';
  }

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
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Light purple/pink gradient background (keep current colors)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                            'Your Life as a Movie',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.question ?? 'What movie title describes your life?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          _MovieHeroCard(
                            screenWidth: screenWidth,
                            movieTitle: widget.movieTitle,
                            releaseYear: widget.releaseYear,
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
                        child: Column(
                          children: [
                            Text(
                              widget.explanation,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.036).clamp(13.0, 15.0),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                widget.subtitle!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF777777),
                                  fontSize: (screenWidth * 0.033).clamp(12.0, 14.0),
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Share button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: SmallShareToStoryButton(
                        shareText: _shareText,
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
          ],
        ),
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

// Movie Hero Card (like Share Hero Card)
class _MovieHeroCard extends StatelessWidget {
  final double screenWidth;
  final String movieTitle;
  final int releaseYear;

  const _MovieHeroCard({
    required this.screenWidth,
    required this.movieTitle,
    required this.releaseYear,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.05).clamp(18.0, isLargeScreen ? 28.0 : 24.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.08).clamp(26.0, 36.0)),
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
              // Movie emoji
              Text(
                '🎬',
                style: TextStyle(
                  fontSize: (screenWidth * 0.10).clamp(40.0, isLargeScreen ? 60.0 : 52.0),
                ),
              ),
              SizedBox(height: (screenWidth * 0.03).clamp(12.0, 18.0)),
              // Movie title
              Text(
                movieTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFFFF6B9D),
                  fontSize: (screenWidth * 0.055).clamp(20.0, isLargeScreen ? 28.0 : 24.0),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Release year
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B9D).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$releaseYear',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFF6B9D),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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
