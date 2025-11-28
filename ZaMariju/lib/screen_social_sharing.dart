import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/screen_preview_analysis.dart';

class SocialSharingScreen extends StatefulWidget {
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const SocialSharingScreen({
    super.key,
    this.stats,
    this.premiumInsights,
  });

  @override
  State<SocialSharingScreen> createState() => _SocialSharingScreenState();
}

class _SocialSharingScreenState extends State<SocialSharingScreen>
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
        fit: StackFit.expand,
        children: [
          // Soft pastel gradient background
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.06).clamp(20.0, 24.0),
                  vertical: (screenHeight * 0.025).clamp(16.0, 20.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    
                    // Header + hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Share with People',
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
                            'Turn your GPT Wrapped into a moment worth sharing.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.045),
                          _ShareHeroCard(
                            screenWidth: screenWidth,
                            onPreviewTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PreviewAnalysisScreen(
                                    stats: widget.stats,
                                    premiumInsights: widget.premiumInsights,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Share to Story Button (functional)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          ShareToStoryButton(
                            shareText: 'Just shared my GPT Wrapped story! #GPTWrapped',
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Message
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
                              'You can always share!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.05).clamp(18.0, 22.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Use the share button on any screen to share your favorite insights directly to Instagram Story. Your journey with ChatGPT is worth sharing! 🌟',
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
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Stay Tuned Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all((screenWidth * 0.05).clamp(20.0, 28.0)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF6B9D).withOpacity(0.15),
                                  const Color(0xFFFFB4A2).withOpacity(0.15),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: const Color(0xFFFF6B9D).withOpacity(0.3),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B9D).withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '✨ Stay Tuned for More ✨',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF1F1F21),
                                    fontSize: (screenWidth * 0.055).clamp(20.0, 26.0),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'We\'re constantly working on new features and insights to make your ChatGPT experience even more personalized. More analytics, deeper insights, and exciting discoveries are coming soon!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

class _ShareHeroCard extends StatelessWidget {
  final double screenWidth;
  final VoidCallback? onPreviewTap;

  const _ShareHeroCard({
    required this.screenWidth,
    this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.06).clamp(22.0, isLargeScreen ? 36.0 : 28.0);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Preview',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF007AFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xFF007AFF).withOpacity(0.08),
                    onPressed: onPreviewTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.play_fill, size: 16, color: Color(0xFF007AFF)),
                        const SizedBox(width: 6),
                        Text(
                          'View preview',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF007AFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: (screenWidth * 0.04).clamp(16.0, 24.0)),
              Text(
                'Share the highlights that made your GPT Wrapped unforgettable.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F1F21),
                  fontSize: (screenWidth * 0.048).clamp(18.0, isLargeScreen ? 24.0 : 22.0),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                height: (screenWidth * 0.35).clamp(160.0, isLargeScreen ? 220.0 : 190.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D2D2D), Color(0xFF434343)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 18,
                      top: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.sparkles, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Wrapped',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all((screenWidth * 0.05).clamp(16.0, 20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '2025 Recap',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ChatGPT knows you like never before.',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw subtle floating dots
    for (int i = 0; i < 15; i++) {
      final x = (i * 67.0) % size.width;
      final y = (i * 43.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final float = 0.2 + 0.3 * sin(timeOffset);
      final dotSize = 1.0 + (1.0 * float);

      canvas.drawCircle(
        Offset(x, y),
        dotSize,
        paint..color = Colors.white.withOpacity(float * 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}