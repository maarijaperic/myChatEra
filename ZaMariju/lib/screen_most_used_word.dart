import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class MostUsedWordScreen extends StatefulWidget {
  final String mostUsedWord;
  final int wordCount;

  const MostUsedWordScreen({
    super.key,
    required this.mostUsedWord,
    required this.wordCount,
  });

  @override
  State<MostUsedWordScreen> createState() => _MostUsedWordScreenState();
}

class _MostUsedWordScreenState extends State<MostUsedWordScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _bubblesController;
  final GlobalKey _screenshotKey = GlobalKey();
  
  int _displayedWordCount = 0;

  String get _cleanWord {
    final raw = widget.mostUsedWord.trim();
    // Never use fallback - if word is empty, it means analysis failed
    // But we should always have a word from stats if analysis worked
    if (raw.isEmpty || raw.toLowerCase() == 'null' || raw == '—' || raw == '-' || raw.toLowerCase() == 'your favorite word') {
      // This should not happen if stats are calculated correctly
      print('⚠️ WARNING: mostUsedWord is empty/null - this indicates analysis failed');
      return raw.isNotEmpty ? raw : 'word'; // Return empty or minimal fallback
    }
    return raw;
  }

  String get _wordStyleLabel {
    final count = widget.wordCount;
    if (count <= 0) {
      return 'Minimalist communicator';
    }
    if (count < 30) {
      return 'Intentional storyteller';
    }
    if (count < 80) {
      return 'Signature catchphrase energy';
    }
    if (count < 150) {
      return 'Certified keyword lover';
    }
    return 'Iconic brand voice';
  }

  String _getPersonaLabel() {
    final count = widget.wordCount;
    if (count <= 0) {
      return 'Versatile';
    }
    if (count < 30) {
      return 'Precise';
    }
    if (count < 80) {
      return 'Distinctive';
    }
    if (count < 150) {
      return 'Memorable';
    }
    return 'Iconic';
  }

  String get _shareText {
    final word = _cleanWord;
    final count = widget.wordCount;

    if (count <= 0 || word.trim().isEmpty) {
      return "No single word defined my AI era — every prompt was a plot twist. #mychateraAI";
    }
    if (count < 80) {
      return 'My AI signature word this year: "$word" ($count uses). Intentional and iconic. #mychateraAI';
    }
    return 'I said "$word" $count times to AI. Trademarked vocabulary activated. #mychateraAI';
  }
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    
    await Future.delayed(const Duration(milliseconds: 800));
    _counterController.forward();
    
    // Animate counter
    _counterController.addListener(() {
      setState(() {
        _displayedWordCount = (widget.wordCount * _counterController.value).round();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _counterController.dispose();
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
            // Pastel brown gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5E6D3), // Very light pastel brown
                    Color(0xFFE8D5C4), // Light pastel brown
                    Color(0xFFDCC9B5), // Soft pastel brown
                    Color(0xFFD0BDA6), // Pastel brown
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
                  painter: _WordParticlesPainter(_bubblesController.value),
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
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Your Signature Word',
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
                            'The word that defined your year with GPT, captured like a shareable moment.',
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
                    
                    SizedBox(height: screenHeight * 0.045),
                    
                    // Word Hero Card (styled like Share screen)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular((screenWidth * 0.08).clamp(26.0, 36.0)),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all((screenWidth * 0.06).clamp(22.0, 32.0)),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.75),
                                  Colors.white.withOpacity(0.55),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular((screenWidth * 0.08).clamp(26.0, 36.0)),
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8E8E93).withOpacity(0.12),
                                  blurRadius: 30,
                                  offset: const Offset(0, 18),
                                ),
                              ],
                            ),
                            child: AnimatedBuilder(
                              animation: _counterController,
                              builder: (context, child) {
                                return Column(
                                  children: [
                                    // Word display
                                    Text(
                                      _cleanWord,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFFF6B35),
                                        fontSize: (screenWidth * 0.12).clamp(40.0, 56.0),
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                        height: 0.9,
                                      ),
                                    ),
                                    SizedBox(height: (screenHeight * 0.015).clamp(8.0, 16.0)),
                                    Text(
                                      '$_displayedWordCount',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF4ECDC4),
                                        fontSize: (screenWidth * 0.08).clamp(28.0, 44.0),
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                        height: 0.9,
                                      ),
                                    ),
                                    SizedBox(height: (screenHeight * 0.005).clamp(2.0, 4.0)),
                                    Text(
                                      'times',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF555555),
                                        fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: (screenHeight * 0.01).clamp(6.0, 10.0)),
                                    Text(
                                      _wordStyleLabel,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF555555),
                                        fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Word Stats Cards (2 rows, 2 cards per row)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Column(
                        children: [
                          // First row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _WordStatCard(
                                    icon: Icons.text_fields,
                                    title: 'Word',
                                    subtitle: _cleanWord,
                                    gradient: const [Color(0xFFFF8FB1), Color(0xFFFFC8DD)],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: _WordStatCard(
                                    icon: Icons.trending_up,
                                    title: 'Frequency',
                                    subtitle: '${widget.wordCount} uses',
                                    gradient: const [Color(0xFF7DD6FF), Color(0xFFB5F1FF)],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Second row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _WordStatCard(
                                    icon: Icons.star,
                                    title: 'Impact',
                                    subtitle: _wordStyleLabel,
                                    gradient: const [Color(0xFF6FE3AA), Color(0xFFA9F5CE)],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: _WordStatCard(
                                    icon: Icons.person,
                                    title: 'Persona',
                                    subtitle: _getPersonaLabel(),
                                    gradient: const [Color(0xFFFFD93D), Color(0xFFFFE88C)],
                                  ),
                                ),
                              ),
                            ],
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
                        accentGradient: const [Color(0xFF8B6F47), Color(0xFFA0826D)],
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

// Word particles painter - bubbles and sparkles floating
class _WordParticlesPainter extends CustomPainter {
  final double animationValue;

  _WordParticlesPainter(this.animationValue);

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

// Word Stat Card (styled like Share channel cards)
class _WordStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _WordStatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final cardWidth = isLargeScreen ? 190.0 : (screenWidth * 0.42).clamp(150.0, 190.0);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
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