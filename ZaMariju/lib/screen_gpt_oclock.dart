import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class GptOClockScreen extends StatefulWidget {
  final String peakTime; // 'night', 'morning', 'afternoon', 'lunch break', etc.
  final int peakHour; // 0-23
  final String timeDescription; // e.g., "at night", "morning", "lunch break"
  final String timeEmoji; // 🌙, ☀️, 🌅, etc.

  const GptOClockScreen({
    super.key,
    required this.peakTime,
    required this.peakHour,
    required this.timeDescription,
    required this.timeEmoji,
  });

  @override
  State<GptOClockScreen> createState() => _GptOClockScreenState();
}

class _GptOClockScreenState extends State<GptOClockScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;
  final GlobalKey _screenshotKey = GlobalKey();

  String get _formattedHour {
    final hour = widget.peakHour.clamp(0, 23);
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:00 $suffix';
  }

  String get _timePersona {
    switch (widget.peakTime) {
      case 'morning':
        return 'Sunrise strategist';
      case 'afternoon':
        return 'Daylight decision-maker';
      case 'evening':
        return 'Golden-hour thinker';
      case 'night':
        return 'Moonlight mastermind';
      default:
        if (widget.peakHour >= 0 && widget.peakHour < 5) {
          return 'Night-owl visionary';
        }
        if (widget.peakHour < 12) {
          return 'Early-bird planner';
        }
        if (widget.peakHour < 18) {
          return 'Peak-hour strategist';
        }
        return 'After-hours architect';
    }
  }

  // Get gradient colors based on peak time
  List<Color> _getTimePeriodGradient() {
    switch (widget.peakTime) {
      case 'morning':
        return [const Color(0xFFFFD700), const Color(0xFFFFE55C)]; // Gold/Yellow
      case 'afternoon':
        return [const Color(0xFFFF8C42), const Color(0xFFFFB366)]; // Orange
      case 'evening':
        return [const Color(0xFFFF6B9D), const Color(0xFFFF8FB1)]; // Pink
      case 'night':
        return [const Color(0xFF667eea), const Color(0xFF764ba2)]; // Purple
      default:
        if (widget.peakHour >= 0 && widget.peakHour < 5) {
          return [const Color(0xFF4A5568), const Color(0xFF718096)]; // Dark gray
        }
        if (widget.peakHour < 12) {
          return [const Color(0xFFFFD700), const Color(0xFFFFE55C)]; // Gold/Yellow
        }
        if (widget.peakHour < 18) {
          return [const Color(0xFFFF8C42), const Color(0xFFFFB366)]; // Orange
        }
        return [const Color(0xFF667eea), const Color(0xFF764ba2)]; // Purple
    }
  }

  List<Color> _getPersonaGradient() {
    switch (widget.peakTime) {
      case 'morning':
        return [const Color(0xFFFFE55C), const Color(0xFFFFF4A3)]; // Light yellow
      case 'afternoon':
        return [const Color(0xFFFF6B35), const Color(0xFFFF8E53)]; // Orange
      case 'evening':
        return [const Color(0xFFFF4D6D), const Color(0xFFFF6B9D)]; // Pink
      case 'night':
        return [const Color(0xFF764ba2), const Color(0xFF9F7AEA)]; // Purple
      default:
        if (widget.peakHour >= 0 && widget.peakHour < 5) {
          return [const Color(0xFF718096), const Color(0xFFA0AEC0)]; // Gray
        }
        if (widget.peakHour < 12) {
          return [const Color(0xFFFFE55C), const Color(0xFFFFF4A3)]; // Light yellow
        }
        if (widget.peakHour < 18) {
          return [const Color(0xFFFF6B35), const Color(0xFFFF8E53)]; // Orange
        }
        return [const Color(0xFF764ba2), const Color(0xFF9F7AEA)]; // Purple
    }
  }

  String get _shareText {
    final hour = widget.peakHour.clamp(0, 23);
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$displayHour:00 $suffix';
    
    return "My ChatGPT peak time is $timeStr ${widget.timeDescription}. ${_timePersona} mode activated! 🕐 #ChatGPTWrapped";
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
    
    return Scaffold(
      body: RepaintBoundary(
        key: _screenshotKey,
        child: Stack(
          children: [
            // Light pastel blue gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE0F2F7), // Very light blue
                    Color(0xFFCCEEF5), // Light blue
                    Color(0xFFB8E8F0), // Soft blue
                    Color(0xFFA3E2EB), // Pastel blue
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
                  painter: _PeakTimeParticlesPainter(_bubblesController.value),
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
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your Peak Time',
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
                            'The time when your ChatGPT conversations peak.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF5C5C5E),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Hero Card (like Daily Dose with orange colors)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: _PeakTimeHeroCard(
                        formattedHour: _formattedHour,
                        timeDescription: widget.timeDescription,
                        timePersona: _timePersona,
                        timeEmoji: widget.timeEmoji,
                        screenWidth: screenWidth,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Highlight cards - 2 cards in one row (like Daily Dose)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.45,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _PeakTimeHighlightCard(
                                icon: Icons.wb_sunny_rounded,
                                title: 'Time Period',
                                subtitle: widget.timeDescription,
                                gradient: _getTimePeriodGradient(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: _PeakTimeHighlightCard(
                                icon: Icons.person_outline_rounded,
                                title: 'Persona',
                                subtitle: _timePersona,
                                gradient: _getPersonaGradient(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Small Share to Story button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: SmallShareToStoryButton(
                        shareText: _shareText,
                        screenshotKey: _screenshotKey,
                        accentGradient: const [Color(0xFFFF8C42), Color(0xFFFFB366)],
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

// Peak time particles painter - bubbles and sparkles floating
class _PeakTimeParticlesPainter extends CustomPainter {
  final double animationValue;

  _PeakTimeParticlesPainter(this.animationValue);

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

// Peak Time Hero Card (like Daily Dose with orange colors)
class _PeakTimeHeroCard extends StatelessWidget {
  final String formattedHour;
  final String timeDescription;
  final String timePersona;
  final String timeEmoji;
  final double screenWidth;

  const _PeakTimeHeroCard({
    required this.formattedHour,
    required this.timeDescription,
    required this.timePersona,
    required this.timeEmoji,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all((screenWidth * 0.035).clamp(14.0, 18.0)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -15,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFE5D4), Color(0xFFFFD1A8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: _PeakTimeHeroChip(label: 'Peak hour'),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0E5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            timeEmoji,
                            style: GoogleFonts.inter(
                              color: const Color(0xFFFF6B35),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formattedHour,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1F1F21),
                      fontSize: (screenWidth * 0.09).clamp(32.0, 40.0),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    timeDescription,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B6B6D),
                      fontSize: (screenWidth * 0.032).clamp(12.0, 14.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFFFD1A8).withOpacity(0.35),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.75,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _PeakTimeHeroStatCard(
                          label: 'Period',
                          value: timeDescription,
                          icon: Icons.access_time_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _PeakTimeHeroStatCard(
                          label: 'Persona',
                          value: timePersona,
                          icon: Icons.person_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeakTimeHeroChip extends StatelessWidget {
  final String label;

  const _PeakTimeHeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD1A8)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFFFF6B35),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PeakTimeHeroStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PeakTimeHeroStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5D4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF6B35),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8A8A8D),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F1F21),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Highlight Card Widget (like Daily Dose)
class _PeakTimeHighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _PeakTimeHighlightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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

