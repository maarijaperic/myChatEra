import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class LoveLanguageScreen extends StatefulWidget {
  final String question;
  final String loveLanguage;
  final String languageEmoji;
  final String explanation;
  final String subtitle;
  final Map<String, int> loveLanguagePercentages; // e.g., {'Words': 35, 'Acts': 25, 'Gifts': 20, 'Time': 20}

  const LoveLanguageScreen({
    super.key,
    required this.question,
    required this.loveLanguage,
    required this.languageEmoji,
    required this.explanation,
    required this.subtitle,
    required this.loveLanguagePercentages,
  });

  @override
  State<LoveLanguageScreen> createState() => _LoveLanguageScreenState();
}

class _LoveLanguageScreenState extends State<LoveLanguageScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;
  late final Map<String, int> _normalizedPercentages;
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

    _normalizedPercentages = widget.loveLanguagePercentages.map(
      (key, value) => MapEntry(key.toLowerCase().trim(), value),
    );

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

  int _percentageForAliases(List<String> aliases) {
    for (final alias in aliases) {
      final key = alias.toLowerCase().trim();
      if (_normalizedPercentages.containsKey(key)) {
        return _normalizedPercentages[key]!.clamp(0, 100);
      }
    }
    return 0;
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
            // More pastel gradient background (keep current colors)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFE8F0), // Very light pastel pink
                    Color(0xFFFFDDE8), // Light pastel pink
                    Color(0xFFFFD1E0), // Soft pastel pink
                    Color(0xFFFFC5D8), // Gentle pastel pink
                  ],
                  stops: [0.0, 0.35, 0.65, 1.0],
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
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Header + hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your Love Language',
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
                          _LoveLanguageHeroCard(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            loveLanguage: widget.loveLanguage,
                            languageEmoji: widget.languageEmoji,
                            wordsPercentage: _percentageForAliases(['words of affirmation', 'words', 'affirmation']),
                            timePercentage: _percentageForAliases(['quality time', 'time']),
                            servicePercentage: _percentageForAliases(['acts of service', 'acts']),
                            giftsPercentage: _percentageForAliases(['receiving gifts', 'gifts']),
                            touchPercentage: _percentageForAliases(['physical touch', 'touch']),
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
                          '${_removeEmojis(widget.explanation)} Understanding your love language helps you communicate your needs better and recognize how others express their care.${widget.subtitle.isNotEmpty ? ' ${_removeEmojis(widget.subtitle)}' : ''} It\'s a powerful tool for building deeper connections. When you know your love language, you can create more meaningful relationships and feel truly understood.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.034).clamp(12.5, 14.5),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Small Share to Story button (smaller)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: SmallShareToStoryButton(
                        shareText: 'My love language is ${widget.loveLanguage}! Love is spoken in many languages 💕 #mychateraAI',
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

// Love Language Hero Card (like Share Hero Card)
class _LoveLanguageHeroCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String loveLanguage;
  final String languageEmoji;
  final int wordsPercentage;
  final int timePercentage;
  final int servicePercentage;
  final int giftsPercentage;
  final int touchPercentage;

  const _LoveLanguageHeroCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.loveLanguage,
    required this.languageEmoji,
    required this.wordsPercentage,
    required this.timePercentage,
    required this.servicePercentage,
    required this.giftsPercentage,
    required this.touchPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.045).clamp(16.0, isLargeScreen ? 22.0 : 18.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(20.0, 28.0)),
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
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              // Love Language Charts
              Wrap(
                alignment: WrapAlignment.center,
                spacing: (screenWidth * 0.025).clamp(8.0, 12.0),
                runSpacing: (screenHeight * 0.01).clamp(6.0, 10.0),
                children: [
                  _LoveLanguageMiniChart(
                    label: 'Words',
                    percentage: wordsPercentage,
                    color: const Color(0xFFFF6B9D),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  _LoveLanguageMiniChart(
                    label: 'Time',
                    percentage: timePercentage,
                    color: const Color(0xFF96CEB4),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  _LoveLanguageMiniChart(
                    label: 'Service',
                    percentage: servicePercentage,
                    color: const Color(0xFF4ECDC4),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  _LoveLanguageMiniChart(
                    label: 'Gifts',
                    percentage: giftsPercentage,
                    color: const Color(0xFF45B7D1),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  _LoveLanguageMiniChart(
                    label: 'Touch',
                    percentage: touchPercentage,
                    color: const Color(0xFFFFA36C),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                ],
              ),
              SizedBox(height: (screenHeight * 0.01).clamp(8.0, 12.0)),
              // Primary Love Language
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFFF8E9E)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  loveLanguage,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: (screenWidth * 0.05).clamp(18.0, isLargeScreen ? 26.0 : 22.0),
                    fontWeight: FontWeight.w700,
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

// Mini Chart for Love Language Hero Card
class _LoveLanguageMiniChart extends StatelessWidget {
  final String label;
  final int percentage;
  final Color color;
  final double screenWidth;
  final double screenHeight;

  const _LoveLanguageMiniChart({
    required this.label,
    required this.percentage,
    required this.color,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final chartSize = (screenWidth * 0.12).clamp(40.0, isLargeScreen ? 70.0 : 55.0);
    final strokeWidth = (chartSize * 0.12).clamp(3.0, 6.0);
    final percentageFontSize = (chartSize * 0.28).clamp(8.0, isLargeScreen ? 14.0 : 12.0);
    final labelFontSize = (chartSize * 0.17).clamp(7.0, isLargeScreen ? 10.0 : 9.0);
    
    return Column(
      children: [
        SizedBox(
          width: chartSize,
          height: chartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: chartSize,
                height: chartSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
              ),
              
              // Progress circle
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              
              // Center percentage
              Text(
                '$percentage%',
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: percentageFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: (screenHeight * 0.005).clamp(3.0, 5.0)),
        
        // Label
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF555555),
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
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


