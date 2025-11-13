import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

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
  
  int _displayedWordCount = 0;

  String get _cleanWord {
    final raw = widget.mostUsedWord.trim();
    if (raw.isEmpty || raw.toLowerCase() == 'null' || raw == '—' || raw == '-') {
      return 'your favorite word';
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

  String get _wordBlurb {
    final word = _cleanWord;
    final count = widget.wordCount;

    if (count <= 0 || word.trim().isEmpty) {
      return "You didn't lean on a single word — every message was a remix. Linguistic chameleon energy. You show up with context instead of catchphrases, so every prompt feels like a new adventure. GPT has to stay on its toes with you, and honestly it lives for the variety. That versatility turns every response into a fresh exploration. You're proof that range is a superpower.";
    }
    if (count < 30) {
      return '"$word" showed up $count times. You deploy it strategically — a go-to move when the idea really matters. It drops only when you need maximum clarity, like your secret handshake with GPT. That kind of precision keeps your conversations crisp and effective. Each drop lands like a clarified intention. GPT has learned to lean in whenever it sees it.';
    }
    if (count < 80) {
      return 'You said "$word" $count times. That word is basically your handshake; GPT knows the assignment as soon as it pops up. You carve entire conversation arcs around it, and it never loses its spark. That\'s how you build your own language of progress. It anchors the narrative so every idea has a home. GPT responds like it\'s hearing a trusted cue.';
    }
    if (count < 150) {
      return '"$word" came up $count times — the signature flavor in your prompts. It\'s part vibe, part brand, all you. Every time it surfaces, GPT shifts into your preferred lane instantly. That\'s artistic direction right there. You\'re not just repeating yourself — you\'re refining a theme. That level of curation is how language becomes a signature.';
    }
    return 'You dropped "$word" $count times. That\'s not just a word, it\'s a whole identity. GPT hears it and already knows your direction before the rest of the prompt lands. You\'ve basically built a verbal universe around it. The word carries your intent like a recognizable signature. That kind of consistency turns dialogue into a personal brand.';
  }

  String get _shareText {
    final word = _cleanWord;
    final count = widget.wordCount;

    if (count <= 0 || word.trim().isEmpty) {
      return "No single word defined my ChatGPT era — every prompt was a plot twist. #ChatGPTWrapped";
    }
    if (count < 80) {
      return 'My ChatGPT signature word this year: "$word" ($count uses). Intentional and iconic. #ChatGPTWrapped';
    }
    return 'I said "$word" $count times to ChatGPT. Trademarked vocabulary activated. #ChatGPTWrapped';
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
      body: Stack(
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
                  horizontal: (screenWidth * 0.06).clamp(16.0, 32.0),
                  vertical: (screenHeight * 0.025).clamp(16.0, 24.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: (screenHeight * 0.08).clamp(20.0, 60.0)),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Your Signature Word',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: (screenWidth * 0.065).clamp(18.0, screenWidth > 600 ? 32.0 : 28.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: (screenHeight * 0.06).clamp(20.0, 48.0)),
                    
                    // Word Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all((screenWidth * 0.045).clamp(14.0, 24.0)),
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
                                    fontSize: (screenWidth * 0.12).clamp(36.0, screenWidth > 600 ? 68.0 : 60.0),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 0.9,
                                  ),
                                ),
                                SizedBox(height: (screenHeight * 0.015).clamp(10.0, 16.0)),
                                Text(
                                  '$_displayedWordCount',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF4ECDC4),
                                    fontSize: (screenWidth * 0.08).clamp(28.0, screenWidth > 600 ? 52.0 : 48.0),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    height: 0.9,
                                  ),
                                ),
                                SizedBox(height: (screenHeight * 0.005).clamp(2.0, 6.0)),
                                Text(
                                  'times',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.035).clamp(11.0, screenWidth > 600 ? 18.0 : 16.0),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: (screenHeight * 0.01).clamp(6.0, 12.0)),
                                Text(
                                  _wordStyleLabel,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF555555),
                                    fontSize: (screenWidth * 0.035).clamp(11.0, screenWidth > 600 ? 18.0 : 16.0),
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
                    
                    SizedBox(height: (screenHeight * 0.04).clamp(16.0, 32.0)),
                    
                    // Description Card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.045).clamp(14.0, 24.0)),
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
                          _wordBlurb,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (screenWidth * 0.038).clamp(13.0, screenWidth > 600 ? 18.0 : 16.0),
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: (screenHeight * 0.05).clamp(20.0, 40.0)),
                    
                    // Share button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.8,
                      child: Center(
                        child: ShareToStoryButton(
                          shareText: _shareText,
                          primaryColor: const Color(0xFFE0F2F7),
                          secondaryColor: const Color(0xFFCCEEF5),
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