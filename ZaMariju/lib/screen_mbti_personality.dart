import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class MBTIPersonalityScreen extends StatefulWidget {
  final String question;
  final String mbtiType;
  final String mbtiEmoji;
  final String personalityName;
  final String explanation;
  final String subtitle;

  const MBTIPersonalityScreen({
    super.key,
    required this.question,
    required this.mbtiType,
    required this.mbtiEmoji,
    required this.personalityName,
    required this.explanation,
    required this.subtitle,
  });

  @override
  State<MBTIPersonalityScreen> createState() => _MBTIPersonalityScreenState();
}

class _MBTIPersonalityScreenState extends State<MBTIPersonalityScreen>
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
            child: RepaintBoundary(
              key: _screenshotKey,
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
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Header + hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'MBTI Personality',
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
                            'Discover your personality type based on your ChatGPT conversations.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(13.0, 15.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          _MBTIHeroCard(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            mbtiType: widget.mbtiType,
                            mbtiEmoji: widget.mbtiEmoji,
                            personalityName: widget.personalityName,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Message card (like Share with People)
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
                        shareText: 'My MBTI personality type: ${widget.mbtiType} - ${widget.personalityName}! 85% match according to ChatGPT. ${widget.mbtiEmoji} #ChatGPTWrapped',
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

// MBTI Hero Card (like Share Hero Card) - optimized for responsive design
class _MBTIHeroCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String mbtiType;
  final String mbtiEmoji;
  final String personalityName;

  const _MBTIHeroCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.mbtiType,
    required this.mbtiEmoji,
    required this.personalityName,
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
              // Circular Progress with Emoji (smaller)
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
                            value: 0.85,
                            strokeWidth: strokeWidth,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Emoji in center
                        Center(
                          child: Text(
                            mbtiEmoji,
                            style: TextStyle(fontSize: emojiSize),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: (screenWidth * 0.025).clamp(10.0, 14.0)),
              // MBTI Type
              Text(
                mbtiType,
                style: GoogleFonts.inter(
                  color: const Color(0xFFFF6B35),
                  fontSize: (screenWidth * 0.075).clamp(24.0, isLargeScreen ? 40.0 : 32.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 0.9,
                ),
              ),
              SizedBox(height: (screenHeight * 0.004).clamp(2.0, 4.0)),
              // Personality Name
              Text(
                personalityName,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F1F21),
                  fontSize: (screenWidth * 0.038).clamp(14.0, isLargeScreen ? 18.0 : 16.0),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              SizedBox(height: (screenHeight * 0.006).clamp(4.0, 6.0)),
              // Match percentage
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
                  '85% Match',
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
