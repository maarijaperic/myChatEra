import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/instagram_share_button.dart';

class MostUsedWordScreen extends StatefulWidget {
  final List<MapEntry<String, int>> topWords; // List of (word, count) pairs

  const MostUsedWordScreen({
    super.key,
    required this.topWords,
  });

  @override
  State<MostUsedWordScreen> createState() => _MostUsedWordScreenState();
}

class _MostUsedWordScreenState extends State<MostUsedWordScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bubblesController;
  final GlobalKey _screenshotKey = GlobalKey();

  List<MapEntry<String, int>> get _topWords {
    return widget.topWords.take(5).toList();
  }

  String get _shareText {
    if (_topWords.isEmpty) {
      return "No words defined my AI era — every prompt was a plot twist. #mychateraAI";
    }
    return 'My top AI words this year: ${_topWords.map((e) => '"${e.key}"').join(", ")}. Vocabulary activated. #mychateraAI';
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
            // Soft pastel lavender background – clean & modern
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5F3FF), // Very light lavender
                    Color(0xFFEDE9FE), // Light lavender
                    Color(0xFFE9E0FA), // Soft lavender
                    Color(0xFFDDD6FE), // Pastel violet
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
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
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Top 5 Most Used Words',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.078).clamp(26.0, 34.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          Text(
                            'Your vocabulary in your AI chats',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6B7280),
                              fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Top 5 Words List - beautiful gradient cards
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: _topWords.asMap().entries.map((entry) {
                          final index = entry.key;
                          final wordEntry = entry.value;
                          final word = wordEntry.key;
                          
                          // Different gradient for each word card
                          final gradients = [
                            [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)], // Purple
                            [const Color(0xFFEC4899), const Color(0xFFF472B6)], // Pink
                            [const Color(0xFF06B6D4), const Color(0xFF22D3EE)], // Cyan
                            [const Color(0xFF10B981), const Color(0xFF34D399)], // Emerald
                            [const Color(0xFFF59E0B), const Color(0xFFFBBF24)], // Amber
                          ];
                          final gradient = gradients[index % gradients.length];
                          
                          return Padding(
                            padding: EdgeInsets.only(bottom: index < _topWords.length - 1 ? 16 : 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all((screenWidth * 0.05).clamp(20.0, 24.0)),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.9),
                                        Colors.white.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: gradient.first.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: gradient.last.withOpacity(0.15),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Rank number with gradient background
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: gradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(
                                              color: gradient.last.withOpacity(0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.045),
                                      // Word with larger, bolder text
                                      Expanded(
                                        child: Text(
                                          word,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF1F1F21),
                                            fontSize: (screenWidth * 0.06).clamp(20.0, 26.0),
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.3,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
                        accentGradient: const [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
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
