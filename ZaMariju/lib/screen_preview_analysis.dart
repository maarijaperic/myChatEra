import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';

class PreviewAnalysisScreen extends StatefulWidget {
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const PreviewAnalysisScreen({
    super.key,
    this.stats,
    this.premiumInsights,
  });

  @override
  State<PreviewAnalysisScreen> createState() => _PreviewAnalysisScreenState();
}

class _PreviewAnalysisScreenState extends State<PreviewAnalysisScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();

    try {
      print('🔵 PreviewAnalysisScreen: initState called');
      print('🔵 PreviewAnalysisScreen: stats is null = ${widget.stats == null}');
      print('🔵 PreviewAnalysisScreen: premiumInsights is null = ${widget.premiumInsights == null}');

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _particlesController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _startAnimations();
    } catch (e, stackTrace) {
      print('❌ PreviewAnalysisScreen: Error in initState: $e');
      print('❌ PreviewAnalysisScreen: Stack trace: $stackTrace');
    }
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
    try {
      print('🔵 PreviewAnalysisScreen: build called');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get stats or use demo data
    final hours = widget.stats?.totalHours ?? 127;
    final minutes = widget.stats?.totalMinutes ?? 42;
    final messagesPerDay = widget.stats?.messagesPerDay ?? 47;
    final streakDays = widget.stats?.longestStreak ?? 14;
    final totalDays = widget.stats?.totalDays ?? 102;
    final mostUsedWord = widget.stats?.mainTopic ?? 'literally';
    final wordCount = widget.stats?.mostUsedWordCount ?? 247;

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

          // Subtle animated particles (TEMPORARILY DISABLED due to painting errors)
          // if (_particlesController.value.isFinite)
          //   AnimatedBuilder(
          //     animation: _particlesController,
          //     builder: (context, child) {
          //       try {
          //         return CustomPaint(
          //           painter: _SubtleParticlesPainter(_particlesController.value),
          //           child: Container(),
          //         );
          //       } catch (e) {
          //         print('❌ PreviewAnalysisScreen: Error building particles: $e');
          //         return Container(); // Return empty container on error
          //       }
          //     },
          //   ),

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
                    SizedBox(height: screenHeight * 0.04),

                    // Header
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your Analysis Preview',
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
                            'A glimpse into your ChatGPT journey',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Stats Cards Grid
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          // Row 1: Hours and Messages
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Hours',
                                  value: '$hours',
                                  subtitle: 'h $minutes min',
                                  gradient: const [
                                    Color(0xFFFF8FB1),
                                    Color(0xFFFFC8DD),
                                  ],
                                  screenWidth: screenWidth,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  title: 'Messages/Day',
                                  value: '$messagesPerDay',
                                  subtitle: 'average',
                                  gradient: const [
                                    Color(0xFF7DD6FF),
                                    Color(0xFFB5F1FF),
                                  ],
                                  screenWidth: screenWidth,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Row 2: Streak and Days
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Longest Streak',
                                  value: '$streakDays',
                                  subtitle: 'days',
                                  gradient: const [
                                    Color(0xFF6FE3AA),
                                    Color(0xFFA9F5CE),
                                  ],
                                  screenWidth: screenWidth,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  title: 'Total Days',
                                  value: '$totalDays',
                                  subtitle: 'active',
                                  gradient: const [
                                    Color(0xFF8D9CFF),
                                    Color(0xFFBEC8FF),
                                  ],
                                  screenWidth: screenWidth,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Row 3: Most Used Word (full width)
                          _StatCard(
                            title: 'Most Used Word',
                            value: mostUsedWord,
                            subtitle: '$wordCount times',
                            gradient: const [
                              Color(0xFFFFB366),
                              Color(0xFFFFD9B3),
                            ],
                            screenWidth: screenWidth,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Premium Insights Preview (if available)
                    if (widget.premiumInsights != null)
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.4,
                        child: Column(
                          children: [
                            Text(
                              'Premium Insights',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.06).clamp(22.0, 26.0),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _PremiumInsightChip(
                                  label: widget.premiumInsights!.mbtiType,
                                  subtitle: 'MBTI',
                                  gradient: const [
                                    Color(0xFFFF8FB1),
                                    Color(0xFFFFC8DD),
                                  ],
                                ),
                                _PremiumInsightChip(
                                  label: widget.premiumInsights!.zodiacSign,
                                  subtitle: 'Zodiac',
                                  gradient: const [
                                    Color(0xFF6FE3AA),
                                    Color(0xFFA9F5CE),
                                  ],
                                ),
                                _PremiumInsightChip(
                                  label: widget.premiumInsights!.loveLanguage,
                                  subtitle: 'Love Language',
                                  gradient: const [
                                    Color(0xFF8D9CFF),
                                    Color(0xFFBEC8FF),
                                  ],
                                ),
                                _PremiumInsightChip(
                                  label: widget.premiumInsights!.personalityType,
                                  subtitle: 'Type A/B',
                                  gradient: const [
                                    Color(0xFFFFB366),
                                    Color(0xFFFFD9B3),
                                  ],
                                ),
                                _PremiumInsightChip(
                                  label: widget.premiumInsights!.introExtroType,
                                  subtitle: 'Personality',
                                  gradient: const [
                                    Color(0xFF9B59B6),
                                    Color(0xFFD7BDE2),
                                  ],
                                ),
                                _PremiumInsightChip(
                                  label: widget.premiumInsights!.mostAskedAdvice.split(' ').take(3).join(' '),
                                  subtitle: 'Top Advice',
                                  gradient: const [
                                    Color(0xFFE74C3C),
                                    Color(0xFFF1948A),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.05),

                    // Back Button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: CupertinoButton.filled(
                        padding: EdgeInsets.symmetric(
                          horizontal: (screenWidth * 0.08).clamp(24.0, 32.0),
                          vertical: (screenHeight * 0.022).clamp(14.0, 18.0),
                        ),
                        borderRadius: BorderRadius.circular(28),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back to Share',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
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
    } catch (e, stackTrace) {
      print('❌ PreviewAnalysisScreen: Error in build: $e');
      print('❌ PreviewAnalysisScreen: Stack trace: $stackTrace');
      // Return a safe fallback widget
      return Scaffold(
        body: Center(
          child: Text('Error loading preview: $e'),
        ),
      );
    }
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final List<Color> gradient;
  final double screenWidth;
  final bool isFullWidth;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.gradient,
    required this.screenWidth,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: isFullWidth ? double.infinity : null,
          padding: EdgeInsets.all((screenWidth * 0.04).clamp(16.0, 20.0)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradient.first.withOpacity(0.25),
                gradient.last.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: gradient.first.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient.last.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF636366),
                  fontSize: (screenWidth * 0.032).clamp(12.0, 14.0),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F1F21),
                  fontSize: (screenWidth * 0.055).clamp(20.0, 28.0),
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: const Color(0xFF8E8E93),
                  fontSize: (screenWidth * 0.030).clamp(11.0, 13.0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Premium Insight Chip Widget
class _PremiumInsightChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final List<Color> gradient;

  const _PremiumInsightChip({
    required this.label,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
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

// Subtle particles painter
class _SubtleParticlesPainter extends CustomPainter {
  final double animationValue;

  _SubtleParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Validate size before painting
    if (size.width <= 0 || size.height <= 0 || 
        size.width.isInfinite || size.height.isInfinite ||
        size.width.isNaN || size.height.isNaN) {
      print('❌ _SubtleParticlesPainter: Invalid size: width=${size.width}, height=${size.height}');
      return;
    }
    
    // Validate animationValue
    if (animationValue.isNaN || animationValue.isInfinite) {
      print('❌ _SubtleParticlesPainter: Invalid animationValue: $animationValue');
      return;
    }
    
    try {
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
        
        // Validate values before drawing
        if (dotSize <= 0 || dotSize.isNaN || dotSize.isInfinite ||
            x.isNaN || x.isInfinite || y.isNaN || y.isInfinite) {
          continue; // Skip invalid dots
        }

      canvas.drawCircle(
        Offset(x, y),
          dotSize.clamp(0.1, 10.0), // Ensure valid size
          paint..color = Colors.white.withOpacity((float * 0.4).clamp(0.0, 1.0)),
      );
      }
    } catch (e, stackTrace) {
      print('❌ _SubtleParticlesPainter: Error in paint: $e');
      print('❌ _SubtleParticlesPainter: Stack trace: $stackTrace');
      // Don't crash, just skip painting
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

