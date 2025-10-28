import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';
import 'dart:math';

class ChatStreakScreen extends StatefulWidget {
  final int streakDays;

  const ChatStreakScreen({
    super.key,
    required this.streakDays,
  });

  @override
  State<ChatStreakScreen> createState() => _ChatStreakScreenState();
}

class _ChatStreakScreenState extends State<ChatStreakScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _counterController;
  late AnimationController _sparkleController;
  
  int _displayedDays = 0;

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
    
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _counterController.forward();
    
    // Animate counter
    _counterController.addListener(() {
      setState(() {
        _displayedDays = (widget.streakDays * _counterController.value).round();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _counterController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0B3), // Light orange
              Color(0xFFFFD1A8), // Soft peach
              Color(0xFFFFC4A8), // Light coral
              Color(0xFFFFB8A8), // Soft salmon
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Subtle sparkle background elements
            AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SparklePainter(
                    animationValue: _sparkleController.value,
                  ),
                  child: Container(),
                );
              },
            ),
            
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Main headline with fire emoji
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Your Longest Chat Streak ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              '🔥',
                              style: TextStyle(
                                fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Streak Display Card with Loading Bar
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.2,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: AnimatedBuilder(
                            animation: _counterController,
                            builder: (context, child) {
                              return Column(
                                children: [
                                  // Days display
                                  Text(
                                    '$_displayedDays',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFFF6B35),
                                      fontSize: (screenWidth * 0.12).clamp(40.0, 52.0),
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                      height: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'days in a row',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF555555),
                                      fontSize: (screenWidth * 0.035).clamp(12.0, 15.0),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Progress bar
                                  Container(
                                    width: double.infinity,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _counterController.value * (_displayedDays / 30).clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                                          ),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Streak Progress',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF777777),
                                      fontSize: (screenWidth * 0.032).clamp(11.0, 14.0),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Explanation Card
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.4,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            "You chatted ${widget.streakDays} days in a row. GPT says that's dedication. Your consistency is impressive — most people can't even remember to drink water daily, but you? You've got this AI relationship thing down to a science. Pure commitment. 🔥",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF555555),
                              fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.05),
                      
                      // Share button - floating outside of cards
                      _AnimatedFade(
                        controller: _fadeController,
                        delay: 0.7,
                        child: Center(
                          child: ShareToStoryButton(
                            shareText: 'I chatted with ChatGPT for ${widget.streakDays} days straight. 🔥 #ChatGPTWrapped',
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

// Sparkle painter for background
class _SparklePainter extends CustomPainter {
  final double animationValue;

  _SparklePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Create subtle sparkles
    for (int i = 0; i < 15; i++) {
      final x = (i * 73.7) % size.width;
      final y = (i * 47.3) % size.height;
      final radius = 1.0 + (sin(animationValue * 2 * pi + i) * 0.5);
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}






