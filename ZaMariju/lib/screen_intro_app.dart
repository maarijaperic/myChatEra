import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroAppScreen extends StatefulWidget {
  final Function(BuildContext)? onContinue;

  const IntroAppScreen({
    super.key,
    this.onContinue,
  });

  @override
  State<IntroAppScreen> createState() => _IntroAppScreenState();
}

class _IntroAppScreenState extends State<IntroAppScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;
  late AnimationController _logoController;

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

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _particlesController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    try {
      return Image.asset(
        'assets/images/logo_transparentno.png',
        width: 140,
        height: 140,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFFB4A2),
                ],
              ),
              borderRadius: BorderRadius.circular(35),
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFFB4A2),
            ],
          ),
          borderRadius: BorderRadius.circular(35),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft gradient background (like Share with People)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFAFAFA), // Off white
                  Color(0xFFF5F5F5), // Light gray
                  Color(0xFFF0F0F0), // Soft gray
                  Color(0xFFEBEBEB), // Medium gray
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
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
                  horizontal: (screenWidth * 0.06).clamp(20.0, 32.0),
                  vertical: (screenHeight * 0.04).clamp(20.0, 32.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),

                    // Logo with animation
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        final scaleAnimation = CurvedAnimation(
                          parent: _logoController,
                          curve: Curves.easeOutCubic,
                        );
                        final fadeAnimation = CurvedAnimation(
                          parent: _logoController,
                          curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
                        );

                        return Opacity(
                          opacity: fadeAnimation.value,
                          child: Transform.scale(
                            scale: 0.8 + (0.2 * scaleAnimation.value),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B9D)
                                        .withOpacity(0.2),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: _buildLogo(),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // Title
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Text(
                        'Welcome to MyChatEra AI',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1F1F21),
                          fontSize: (screenWidth * 0.08).clamp(28.0, isLargeScreen ? 44.0 : 36.0),
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Subtitle
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.3,
                      child: Text(
                        'Discover insights about your AI conversations',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF636366),
                          fontSize: (screenWidth * 0.04).clamp(14.0, isLargeScreen ? 20.0 : 16.0),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // Introduction text card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          (screenWidth * 0.05).clamp(20.0, 28.0),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFF5FB).withOpacity(0.8),
                              const Color(0xFFF4F1FF).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFFF6B9D).withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What is MyChatEra AI?',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.045).clamp(18.0, isLargeScreen ? 24.0 : 22.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'MyChatEra AI analyzes your AI conversation history to reveal fascinating insights about your communication patterns, personality traits, and usage habits.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF636366),
                                fontSize: (screenWidth * 0.037).clamp(14.0, isLargeScreen ? 18.0 : 16.0),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.1,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Get ready to discover your unique AI conversation style! 🎉',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.037).clamp(14.0, isLargeScreen ? 18.0 : 16.0),
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.08),

                    // Continue button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: SizedBox(
                        width: double.infinity,
                        height: (screenHeight * 0.07).clamp(56.0, 70.0),
                        child: ElevatedButton(
                          onPressed: () {
                            print('🔵 IntroAppScreen: Continue button pressed');
                            if (widget.onContinue != null) {
                              widget.onContinue!(context);
                              print('🔵 IntroAppScreen: onContinue callback executed');
                            } else {
                              print('⚠️ IntroAppScreen: onContinue callback is null!');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F1F21),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (screenWidth * 0.04).clamp(16.0, 24.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: (screenHeight * 0.02).clamp(16.0, 20.0),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: (screenWidth * 0.045)
                                  .clamp(16.0, isLargeScreen ? 22.0 : 20.0),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
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
