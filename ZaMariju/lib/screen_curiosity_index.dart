import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class CuriosityIndexScreen extends StatefulWidget {
  final double averageResponseTime; // in seconds
  final String speedLabel; // e.g., "lightning-fast", "quick", "thoughtful"

  const CuriosityIndexScreen({
    super.key,
    required this.averageResponseTime,
    required this.speedLabel,
  });

  @override
  State<CuriosityIndexScreen> createState() => _CuriosityIndexScreenState();
}

class _CuriosityIndexScreenState extends State<CuriosityIndexScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;
  final GlobalKey _screenshotKey = GlobalKey();
  
  String get _capitalizedSpeedLabel {
    final trimmed = widget.speedLabel.trim();
    if (trimmed.isEmpty) {
      return 'dialed-in';
    }
    return '${trimmed[0].toUpperCase()}${trimmed.length > 1 ? trimmed.substring(1) : ''}';
  }

  String get _speedDescriptor {
    final seconds = widget.averageResponseTime;
    if (seconds <= 0) return 'Ghosting GPT (for now)';
    if (seconds <= 1.5) return 'Lightning brain';
    if (seconds <= 4) return 'Rapid-fire curious';
    if (seconds <= 10) return 'Thoughtful strategist';
    return 'Deep dive contemplator';
  }

  double _getProgressValue() {
    final seconds = widget.averageResponseTime;
    // Normalize to 0-1 range (0s = 1.0, 15s+ = 0.0)
    if (seconds <= 0) return 0.0;
    if (seconds >= 15) return 0.0;
    return (1.0 - (seconds / 15.0)).clamp(0.0, 1.0);
  }


  String get _shareText {
    final seconds = widget.averageResponseTime;
    final label = _capitalizedSpeedLabel;
    if (seconds <= 0) {
      return "Apparently I ghosted ChatGPT all year. Plot twist coming soon. #ChatGPTWrapped";
    }
    if (seconds <= 4) {
      return "I reply to ChatGPT in ${seconds.toStringAsFixed(1)} seconds. ${label} mode activated. #ChatGPTWrapped";
    }
    if (seconds <= 10) {
      return "My ChatGPT response time is ${seconds.toStringAsFixed(1)} seconds — thoughtful and on point. #ChatGPTWrapped";
    }
    return "I take ${seconds.toStringAsFixed(1)} seconds per ChatGPT reply. Slow and intentional wins. #ChatGPTWrapped";
  }

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
    final isLargeScreen = screenWidth > 600;
    
    return Scaffold(
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Stack(
          children: [
            // Light pink gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF0F5), // Very light pink
                    Color(0xFFFFE4E9), // Light pink
                    Color(0xFFFFD1DC), // Soft pink
                    Color(0xFFFFB6C1), // Light pink
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            
            // Animated particles
            AnimatedBuilder(
              animation: _bubblesController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _CuriosityParticlesPainter(_bubblesController.value),
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
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Quick or Thoughtful',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.08).clamp(26.0, 34.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your response speed reveals your thinking style.',
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
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Hero Card with Response Time
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all((screenWidth * 0.07).clamp(28.0, 38.0)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.55),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(36),
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
                            // Response time display
                            Text(
                              '${widget.averageResponseTime.toStringAsFixed(1)}s',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFF6B9D),
                                fontSize: (screenWidth * 0.10).clamp(32.0, isLargeScreen ? 52.0 : 48.0),
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 0.9,
                              ),
                            ),
                            SizedBox(height: (screenHeight * 0.005).clamp(2.0, 4.0)),
                            Text(
                              widget.speedLabel,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.032).clamp(12.0, isLargeScreen ? 16.0 : 15.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: (screenHeight * 0.005).clamp(2.0, 4.0)),
                            Text(
                              'Average response time',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.032).clamp(12.0, isLargeScreen ? 16.0 : 15.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: (screenHeight * 0.015).clamp(10.0, 14.0)),
                            // Progress bar
                            Container(
                              width: double.infinity,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _getProgressValue(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB1)],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: (screenHeight * 0.01).clamp(6.0, 10.0)),
                            Text(
                              _speedDescriptor,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF3A506B),
                                fontSize: (screenWidth * 0.032).clamp(12.0, isLargeScreen ? 16.0 : 15.0),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.035),
                    
                    // Highlight cards - 2 cards in one row
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.45,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _CuriosityHighlightCard(
                                  icon: Icons.label,
                                  title: 'Style',
                                  subtitle: widget.speedLabel,
                                  gradient: const [Color(0xFFFF6B9D), Color(0xFFFF8FB1)],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _CuriosityHighlightCard(
                                  icon: Icons.psychology,
                                  title: 'Persona',
                                  subtitle: _speedDescriptor,
                                  gradient: const [Color(0xFFFF4D6D), Color(0xFFFF6B9D)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.045),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: SmallShareToStoryButton(
                        shareText: _shareText,
                        screenshotKey: _screenshotKey,
                        accentGradient: const [Color(0xFFFF8FB1), Color(0xFFFFB5D8)],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
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

// Curiosity particles painter - bubbles and sparkles floating
class _CuriosityParticlesPainter extends CustomPainter {
  final double animationValue;

  _CuriosityParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw floating bubbles
    for (int i = 0; i < 20; i++) {
      final x = (i * 47.0) % size.width;
      final y = (i * 31.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final float = sin(timeOffset) * 15;
      final bubbleY = y + float;
      final opacity = 0.2 + 0.3 * sin(timeOffset);
      final bubbleSize = 3.0 + (2.0 * sin(timeOffset));
      
      canvas.drawCircle(
        Offset(x, bubbleY),
        bubbleSize,
        paint..color = Colors.white.withOpacity(opacity),
      );
    }
    
    // Add floating sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 67.0 + 30) % size.width;
      final y = (i * 43.0 + 20) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.6);
      final twinkle = 0.3 + 0.7 * sin(timeOffset);
      final starSize = 1.0 + (1.5 * twinkle);
      
      _drawStar(canvas, Offset(x, y), starSize, paint..color = Colors.white.withOpacity(twinkle * 0.6));
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;
    
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - (pi / 2);
      final outerX = center.dx + cos(angle) * outerRadius;
      final outerY = center.dy + sin(angle) * outerRadius;
      final innerAngle = angle + (pi / 5);
      final innerX = center.dx + cos(innerAngle) * innerRadius;
      final innerY = center.dy + sin(innerAngle) * innerRadius;
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Highlight Card Widget (like Daily Dose)
class _CuriosityHighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _CuriosityHighlightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}








