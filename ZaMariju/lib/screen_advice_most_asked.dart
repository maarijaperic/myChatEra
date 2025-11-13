import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class AdviceMostAskedScreen extends StatefulWidget {
  final String question;
  final String mostAskedAdvice;
  final String adviceCategory;
  final String adviceEmoji;
  final String explanation;
  final String subtitle;

  const AdviceMostAskedScreen({
    super.key,
    required this.question,
    required this.mostAskedAdvice,
    required this.adviceCategory,
    required this.adviceEmoji,
    required this.explanation,
    required this.subtitle,
  });

  @override
  State<AdviceMostAskedScreen> createState() => _AdviceMostAskedScreenState();
}

class _AdviceMostAskedScreenState extends State<AdviceMostAskedScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _geometricController;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _geometricController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _geometricController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          const _AdviceGradientBackground(),
          
          // Geometric patterns
          _GeometricPatterns(controller: _geometricController),
          
          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;
                final screenWidth = constraints.maxWidth;
                final isLargeScreen = screenWidth > 600;
                
                // Responsive padding
                final horizontalPadding = ((screenWidth * 0.06).clamp(16.0, 32.0)) * 0.9;
                final cardMargin = ((screenWidth * 0.06).clamp(16.0, 32.0)) * 0.9;
                
                // Responsive spacing
                final topSpacing = (screenHeight * 0.08).clamp(32.0, 60.0);
                final sectionSpacing = (screenHeight * 0.015).clamp(8.0, 12.0);
                final bottomSpacing = (screenHeight * 0.015).clamp(12.0, 18.0);
                
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: topSpacing),
                        
                        // Question text
                        _AnimatedText(
                          controller: _mainController,
                          delay: 0.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            child: Text(
                              widget.question,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: (screenWidth * 0.055).clamp(16.0, isLargeScreen ? 28.0 : 24.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: (screenHeight * 0.04).clamp(20.0, 32.0)),
                        
                        // Advice Display Card
                        _AnimatedText(
                          controller: _mainController,
                          delay: 0.2,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: cardMargin),
                            padding: EdgeInsets.all((screenWidth * 0.03).clamp(12.0, 20.0)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular((screenWidth * 0.05).clamp(18.0, 24.0)),
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
                                // Modern advice display with progress bar
                                Column(
                                  children: [
                                    // Advice category
                                    Text(
                                      widget.adviceCategory.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF10B981),
                                        fontSize: (screenWidth * 0.06).clamp(16.0, isLargeScreen ? 28.0 : 24.0),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    SizedBox(height: (screenHeight * 0.006).clamp(3.0, 6.0)),
                                    Text(
                                      'Most Asked',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF555555),
                                        fontSize: (screenWidth * 0.032).clamp(10.0, isLargeScreen ? 16.0 : 14.0),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: (screenHeight * 0.012).clamp(8.0, 12.0)),
                                    
                                    // Most asked advice
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (screenWidth * 0.035).clamp(12.0, 18.0),
                                        vertical: (screenHeight * 0.01).clamp(6.0, 12.0),
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981), // Green background
                                        borderRadius: BorderRadius.circular((screenWidth * 0.04).clamp(14.0, 20.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.mostAskedAdvice,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            color: Colors.white, // White text
                                            fontSize: (screenWidth * 0.045).clamp(14.0, isLargeScreen ? 22.0 : 20.0),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: sectionSpacing),
                        
                        // Explanation Card
                        _AnimatedText(
                          controller: _mainController,
                          delay: 0.4,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: cardMargin),
                            padding: EdgeInsets.all((screenWidth * 0.035).clamp(12.0, 20.0)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular((screenWidth * 0.05).clamp(18.0, 24.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              "${widget.explanation} You're asking the kinds of questions that keep relationships evolving. Keep reaching for clarity, because that's how you keep leveling up together.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.038).clamp(13.0, isLargeScreen ? 18.0 : 16.0),
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: sectionSpacing),
                        
                        // Subtitle
                        _AnimatedText(
                          controller: _mainController,
                          delay: 0.6,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: (screenWidth * 0.1).clamp(24.0, 48.0)),
                            child: Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: (screenWidth * 0.04).clamp(13.0, isLargeScreen ? 20.0 : 18.0),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: (screenHeight * 0.008).clamp(4.0, 8.0)),
                        
                        // Share button
                        _AnimatedText(
                          controller: _mainController,
                          delay: 0.8,
                          child: Center(
                            child: ShareToStoryButton(
                              shareText: 'ChatGPT revealed I asked most about "${widget.mostAskedAdvice}". ${widget.adviceEmoji} Wisdom is knowing what to ask! 💡 #ChatGPTWrapped',
                            ),
                          ),
                        ),
                        
                        SizedBox(height: bottomSpacing),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceGradientBackground extends StatelessWidget {
  const _AdviceGradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E8), // Very light green
            Color(0xFFD4F0D4), // Light green
            Color(0xFFC8E8C8), // Soft green
            Color(0xFFB8E0B8), // Light green
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }
}

class _GeometricPatterns extends StatelessWidget {
  final AnimationController controller;

  const _GeometricPatterns({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GeometricPatternPainter(
            animationValue: controller.value,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: Container(),
        );
      },
    );
  }
}

class _AnimatedText extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _AnimatedText({
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


class _GeometricPatternPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _GeometricPatternPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final numShapes = 8;
    
    for (int i = 0; i < numShapes; i++) {
      final angle = (i * 2 * pi / numShapes) + (animationValue * 2 * pi);
      final centerX = size.width / 2 + cos(angle) * (size.width * 0.3);
      final centerY = size.height / 2 + sin(angle) * (size.height * 0.3);
      final timeOffset = animationValue * 2 * pi + (i * pi / 4);
      final scale = 0.5 + 0.5 * sin(timeOffset);
      
      // Draw star shape
      final path = Path();
      final radius = 20 * scale;
      
      for (int j = 0; j < 10; j++) {
        final starAngle = (j * pi / 5) - (pi / 2);
        final r = (j % 2 == 0) ? radius : radius * 0.4;
        final x = centerX + cos(starAngle) * r;
        final y = centerY + sin(starAngle) * r;
        
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

