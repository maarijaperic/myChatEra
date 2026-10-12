import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/card_navigator.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

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
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 26),
                    child: _BackButton(
                      onTap: () => CardNavigator.of(context)?.goToPrevious(),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                  child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.06).clamp(20.0, 24.0),
                  vertical: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    // Header
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          const GlowOrb(emoji: '💎', color: WrappedColors.pink, size: 120),
                          Text(
                            'PREMIUM',
                            style: GoogleFonts.inter(
                              color: WrappedColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          HighlightText(
                            'Unlock your\n*Premium* insights',
                            accent: WrappedColors.pinkDeep,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: WrappedColors.ink,
                              fontSize: (screenWidth * 0.075).clamp(26.0, 32.0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.0,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Discover your personality, zodiac, love language, and more.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8E8E93),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Premium Features Grid
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          Text(
                            'What\'s inside',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: WrappedColors.ink,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
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
                          const SizedBox(height: 16),
                          Text(
                            '...and many more',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8E8E93),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                  ],
                ),
              ),
            ),
                  ),
                ),
                // Unlock Button Section (pinned to the bottom, outside the back-tap zone)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    (screenWidth * 0.06).clamp(20.0, 24.0),
                    8,
                    (screenWidth * 0.06).clamp(20.0, 24.0),
                    12,
                  ),
                  child: _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: WrappedPillButton(
                        label: 'Unlock Premium',
                        icon: CupertinoIcons.lock_open_fill,
                        color: WrappedColors.pinkDeep,
                        onTap: _showSubscriptionScreen,
                      ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'One-time payment · No subscription',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8E8E93),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: Color(0xFF1F1F21),
          size: 18,
        ),
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
        paint..color = Colors.white.withOpacity((float * 0.4).clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
