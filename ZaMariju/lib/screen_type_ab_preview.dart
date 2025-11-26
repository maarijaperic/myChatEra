import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _showSubscriptionScreen() {
    print('🔴 PREMIUM_DEBUG: TypeABPreviewScreen - _showSubscriptionScreen called');
    print('🔴 PREMIUM_DEBUG: Opening SubscriptionScreen');
    print('🔴 PREMIUM_DEBUG: widget.onSubscribe callback available');
    // Just call the onSubscribe callback - it will handle showing subscription screen
    widget.onSubscribe();
  }

  @override
  Widget build(BuildContext context) {
    print('🔴 PREMIUM_DEBUG: TypeABPreviewScreen build called');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft pastel gradient background (same as Share screen)
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
          
          // Subtle animated particles (same as Share screen)
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
                    
                    // Header
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Unlock Premium Insights',
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
                            'Discover your personality, zodiac, love language, and more.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          
                          // Preview Hero Card (smaller)
                          _PreviewHeroCard(screenWidth: screenWidth),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Premium Features Grid
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          Text(
                            'What\'s Inside',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.042).clamp(16.0, 20.0),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: (screenHeight * 0.012).clamp(10.0, 14.0)),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: const [
                              _PremiumFeatureCard(
                                icon: CupertinoIcons.person_fill,
                                title: 'MBTI Type',
                                subtitle: 'Your personality',
                                gradient: [Color(0xFFFF8FB1), Color(0xFFFFC8DD)],
                              ),
                              _PremiumFeatureCard(
                                icon: CupertinoIcons.sparkles,
                                title: 'Type A/B',
                                subtitle: 'Personality style',
                                gradient: [Color(0xFF7DD6FF), Color(0xFFB5F1FF)],
                              ),
                              _PremiumFeatureCard(
                                icon: CupertinoIcons.star_fill,
                                title: 'Zodiac Sign',
                                subtitle: 'Astrological match',
                                gradient: [Color(0xFF6FE3AA), Color(0xFFA9F5CE)],
                              ),
                              _PremiumFeatureCard(
                                icon: CupertinoIcons.heart_fill,
                                title: 'Love Language',
                                subtitle: 'How you love',
                                gradient: [Color(0xFF8D9CFF), Color(0xFFBEC8FF)],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'And many more!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8E8E93),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Unlock Button Section
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: GestureDetector(
                        onTap: _showSubscriptionScreen,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: (screenWidth * 0.045).clamp(14.0, 18.0),
                            vertical: (screenHeight * 0.017).clamp(12.0, 14.0),
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF6B9D),
                                Color(0xFFFF8E9E),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B9D).withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  CupertinoIcons.lock_open_fill,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unlock Premium',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Tap to choose your plan',
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                CupertinoIcons.chevron_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Message Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.045).clamp(16.0, 18.0)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFFFF), Color(0xFFF6F7FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Get personalized insights about your personality, relationships, and communication style based on your ChatGPT conversations. 🌟',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.034).clamp(12.0, 14.0),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            letterSpacing: 0.2,
                          ),
                        ),
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
    );
  }
}

// Preview Hero Card (blurred preview content)
class _PreviewHeroCard extends StatelessWidget {
  final double screenWidth;

  const _PreviewHeroCard({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.03).clamp(12.0, isLargeScreen ? 20.0 : 16.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.055).clamp(20.0, 26.0)),
      child: Stack(
        children: [
          // Blurred backdrop
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B9D).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Preview',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF6B9D),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.lock_fill, size: 11, color: Color(0xFF8E8E93)),
                            const SizedBox(width: 4),
                            Text(
                              'Locked',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8E8E93),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (screenWidth * 0.018).clamp(6.0, 10.0)),
                  Text(
                    'What advice have you asked ChatGPT for the most?',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1F1F21),
                      fontSize: (screenWidth * 0.032).clamp(12.0, isLargeScreen ? 16.0 : 14.0),
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: (screenWidth * 0.018).clamp(6.0, 10.0)),
                  Container(
                    padding: EdgeInsets.all((screenWidth * 0.018).clamp(5.0, 7.0)),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2D2D2D), Color(0xFF434343)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '💕',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'RELATIONSHIPS',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'How to improve my personal relationships',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

// Premium Feature Card
class _PremiumFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _PremiumFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final cardWidth = isLargeScreen ? 160.0 : 140.0;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all((screenWidth * 0.03).clamp(10.0, 12.0)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.85),
              fontSize: 11,
              fontWeight: FontWeight.w400,
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
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}

// Subtle particles painter (same as Share screen)
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
