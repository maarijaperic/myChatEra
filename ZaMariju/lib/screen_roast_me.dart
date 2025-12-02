import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class RoastMeScreen extends StatefulWidget {
  final String question;
  final String roastText;
  final String subtitle;

  const RoastMeScreen({
    super.key,
    required this.question,
    required this.roastText,
    required this.subtitle,
  });

  @override
  State<RoastMeScreen> createState() => _RoastMeScreenState();
}

class _RoastMeScreenState extends State<RoastMeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;
  final GlobalKey _screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bubblesController = AnimationController(
      duration: const Duration(milliseconds: 3000),
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
    _bubblesController.dispose();
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
            // Soft pastel gradient background (lighter shade)
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

            // Subtle animated particles (like Share with People)
            AnimatedBuilder(
              animation: _bubblesController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SubtleParticlesPainter(_bubblesController.value),
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
                    vertical: (screenHeight * 0.02).clamp(16.0, 20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.06),

                      // Header + hero card
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.0,
                        child: Column(
                          children: [
                            Text(
                              'Roast Me',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.08).clamp(26.0, 34.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Based on our previous interactions, here\'s your roast!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF636366),
                                fontSize: (screenWidth * 0.04).clamp(13.0, 15.0),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _RoastHeroCard(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Roast text card (like Share with People)
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.2,
                        child: Container(
                          padding: EdgeInsets.all((screenWidth * 0.045).clamp(16.0, 20.0)),
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
                                '${widget.roastText} But honestly, we love that for you - at least you\'re getting things done!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF555555),
                                  fontSize: (screenWidth * 0.036).clamp(13.0, 15.0),
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.subtitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF555555),
                                  fontSize: (screenWidth * 0.036).clamp(13.0, 15.0),
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: 0.2,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Small Share to Story button
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.4,
                        child: SmallShareToStoryButton(
                          shareText: 'AI roasted me based on our conversations and I can\'t even be mad! 🔥😂 #mychateraAI #Roasted',
                          screenshotKey: _screenshotKey,
                          accentGradient: const [Color(0xFFFF6B35), Color(0xFFFF8C42)],
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

// Roast Hero Card (like MBTI Hero Card) - optimized for responsive design
class _RoastHeroCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const _RoastHeroCard({
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.04).clamp(14.0, isLargeScreen ? 24.0 : 18.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(22.0, 28.0)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
            children: [
              // Circular Progress with Fire Emoji (smaller)
              Builder(
                builder: (context) {
                  final progressSize = (screenWidth * 0.18).clamp(70.0, isLargeScreen ? 110.0 : 90.0);
                  final strokeWidth = (progressSize * 0.08).clamp(5.0, 7.0);
                  final emojiSize = (progressSize * 0.35).clamp(22.0, isLargeScreen ? 40.0 : 32.0);
                  return SizedBox(
                    width: progressSize,
                    height: progressSize,
                    child: Stack(
                      children: [
                        // Background circle
                        Container(
                          width: progressSize,
                          height: progressSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFF6B35).withOpacity(0.1),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: progressSize,
                          height: progressSize,
                          child: CircularProgressIndicator(
                            value: 1.0, // Full circle for roast
                            strokeWidth: strokeWidth,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Fire emoji in center
                        Center(
                          child: Text(
                            '🔥',
                            style: TextStyle(fontSize: emojiSize),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: (screenWidth * 0.025).clamp(10.0, 14.0)),
              // Roast Title
              Text(
                'ROASTED',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFF6B35),
                  fontSize: (screenWidth * 0.075).clamp(24.0, isLargeScreen ? 40.0 : 32.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 0.9,
                ),
              ),
              SizedBox(height: (screenHeight * 0.004).clamp(2.0, 4.0)),
              // Subtitle
              Text(
                'Based on your chats',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F1F21),
                  fontSize: (screenWidth * 0.038).clamp(14.0, isLargeScreen ? 18.0 : 16.0),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              SizedBox(height: (screenHeight * 0.006).clamp(4.0, 6.0)),
              // Fun badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.03).clamp(10.0, 12.0),
                  vertical: (screenHeight * 0.004).clamp(4.0, 5.0),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '100% Roasted 🔥',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFF6B35),
                    fontSize: (screenWidth * 0.030).clamp(11.0, 12.0),
                    fontWeight: FontWeight.w600,
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
