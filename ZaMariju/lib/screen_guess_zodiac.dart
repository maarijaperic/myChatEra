import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class GuessZodiacScreen extends StatefulWidget {
  final String question;
  final String zodiacSign;
  final String zodiacEmoji;
  final String zodiacName;
  final String explanation;
  final String subtitle;

  const GuessZodiacScreen({
    super.key,
    required this.question,
    required this.zodiacSign,
    required this.zodiacEmoji,
    required this.zodiacName,
    required this.explanation,
    required this.subtitle,
  });

  @override
  State<GuessZodiacScreen> createState() => _GuessZodiacScreenState();
}

class _GuessZodiacScreenState extends State<GuessZodiacScreen>
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

  String _removeEmojis(String text) {
    return text.replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]', unicode: true), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft pastel gradient background (like Share with People)
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
                            'Your Zodiac Sign',
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
                          SizedBox(height: screenHeight * 0.045),
                          _ZodiacHeroCard(
                            screenWidth: screenWidth,
                            zodiacSign: widget.zodiacSign,
                            zodiacEmoji: widget.zodiacEmoji,
                            zodiacName: widget.zodiacName,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Message card (like Share with People)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: (screenWidth * 0.04).clamp(16.0, 18.0),
                          vertical: (screenHeight * 0.018).clamp(14.0, 16.0),
                        ),
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
                          '${_removeEmojis(widget.explanation)} Your conversations reveal patterns that align with this zodiac sign\'s characteristics, showing how your communication style reflects your astrological nature.${widget.subtitle.isNotEmpty ? ' ${_removeEmojis(widget.subtitle)}' : ''}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.034).clamp(12.5, 14.5),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
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
                        shareText: 'My zodiac sign: ${widget.zodiacSign} - ${widget.zodiacName}! 92% match according to ChatGPT. ${_removeEmojis(widget.subtitle)} ${widget.zodiacEmoji} #ChatGPTWrapped',
                        screenshotKey: _screenshotKey,
                        accentGradient: const [Color(0xFFFF8FB1), Color(0xFFFFB5D8)],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
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

// Zodiac Hero Card (like Share Hero Card)
class _ZodiacHeroCard extends StatelessWidget {
  final double screenWidth;
  final String zodiacSign;
  final String zodiacEmoji;
  final String zodiacName;

  const _ZodiacHeroCard({
    required this.screenWidth,
    required this.zodiacSign,
    required this.zodiacEmoji,
    required this.zodiacName,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.035).clamp(14.0, isLargeScreen ? 24.0 : 18.0);

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
                  final strokeWidth = (progressSize * 0.07).clamp(5.0, 7.0);
                  final emojiSize = (progressSize * 0.32).clamp(22.0, isLargeScreen ? 40.0 : 32.0);
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
                            color: const Color(0xFF9C27B0).withOpacity(0.1),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: progressSize,
                          height: progressSize,
                          child: CircularProgressIndicator(
                            value: 0.92,
                            strokeWidth: strokeWidth,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Emoji in center
                        Center(
                          child: Text(
                            zodiacEmoji,
                            style: TextStyle(fontSize: emojiSize),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: (screenWidth * 0.025).clamp(10.0, 14.0)),
              // Zodiac Sign (smaller)
              Text(
                zodiacSign,
                style: GoogleFonts.inter(
                  color: const Color(0xFF9C27B0),
                  fontSize: (screenWidth * 0.075).clamp(24.0, isLargeScreen ? 40.0 : 32.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 0.9,
                ),
              ),
              const SizedBox(height: 4),
              // Zodiac Name (smaller)
              Text(
                zodiacName,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F1F21),
                  fontSize: (screenWidth * 0.038).clamp(14.0, isLargeScreen ? 18.0 : 16.0),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              // Match percentage (smaller)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.03).clamp(10.0, 12.0),
                  vertical: (screenWidth * 0.01).clamp(4.0, 5.0),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '92% Match',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF9C27B0),
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
