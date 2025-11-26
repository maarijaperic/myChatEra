import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class RedGreenFlagsScreen extends StatefulWidget {
  final String question;
  final String greenFlagTitle;
  final String redFlagTitle;
  final List<String> greenFlags;
  final List<String> redFlags;
  final String subtitle;

  const RedGreenFlagsScreen({
    super.key,
    required this.question,
    required this.greenFlagTitle,
    required this.redFlagTitle,
    required this.greenFlags,
    required this.redFlags,
    required this.subtitle,
  });

  @override
  State<RedGreenFlagsScreen> createState() => _RedGreenFlagsScreenState();
}

class _RedGreenFlagsScreenState extends State<RedGreenFlagsScreen>
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pastel pink gradient background (lighter shade)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8FA), // Very very light pink
                  Color(0xFFFFF0F5), // Very light pink
                  Color(0xFFFFE8ED), // Lighter pink
                  Color(0xFFFFE0E6), // Light pink
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
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Header
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Red & Green Flags',
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
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.025),
                    
                    // Flags Details Cards
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          _FlagDetailCard(
                            title: widget.greenFlagTitle,
                            flags: widget.greenFlags,
                            isGreen: true,
                            screenWidth: screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _FlagDetailCard(
                            title: widget.redFlagTitle,
                            flags: widget.redFlags,
                            isGreen: false,
                            screenWidth: screenWidth,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: SmallShareToStoryButton(
                        shareText: 'Check out my ChatGPT Red and Green Flags! 🟢🔴 #ChatGPTWrapped',
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

// Flag Detail Card
class _FlagDetailCard extends StatelessWidget {
  final String title;
  final List<String> flags;
  final bool isGreen;
  final double screenWidth;

  const _FlagDetailCard({
    required this.title,
    required this.flags,
    required this.isGreen,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all((screenWidth * 0.035).clamp(14.0, 16.0)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isGreen
                  ? [
                      const Color(0xFF10B981).withOpacity(0.1),
                      const Color(0xFF34D399).withOpacity(0.05),
                    ]
                  : [
                      const Color(0xFFEF4444).withOpacity(0.1),
                      const Color(0xFFF87171).withOpacity(0.05),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: (isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                  .withOpacity(0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                    .withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              ...flags.map((flag) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.only(right: 8, top: 2),
                        decoration: BoxDecoration(
                          color: (isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isGreen ? Icons.check : Icons.close,
                          size: 11,
                          color: isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          flag,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF2D2D2D),
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
