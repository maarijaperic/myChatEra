import 'dart:math';
import 'package:flutter/material.dart';

class MainCharacterTopicScreen extends StatefulWidget {
  final String mainTopic;

  const MainCharacterTopicScreen({
    super.key,
    required this.mainTopic,
  });

  @override
  State<MainCharacterTopicScreen> createState() => _MainCharacterTopicScreenState();
}

class _MainCharacterTopicScreenState extends State<MainCharacterTopicScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatingController;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat();
    
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
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
    _floatingController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background - Different colors than Daily Dose
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFF667EEA), // Blue purple
                      Color(0xFF764BA2), // Deep purple
                      Color(0xFF9B59B6), // Violet
                      Color(0xFFE74C3C), // Red
                      Color(0xFFFF6B9D), // Pink
                      Color(0xFFF093FB), // Light purple
                    ],
                    stops: [
                      0.0,
                      0.2 + (0.05 * sin(_gradientController.value * 2 * pi)),
                      0.4 + (0.05 * sin(_gradientController.value * 2 * pi + 1)),
                      0.6 + (0.05 * sin(_gradientController.value * 2 * pi + 2)),
                      0.8 + (0.05 * sin(_gradientController.value * 2 * pi + 3)),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Floating topic icons (sparkles, stars, books)
          _FloatingTopicIcons(controller: _floatingController),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width * 0.06).clamp(16.0, 32.0),
                  vertical: (MediaQuery.of(context).size.height * 0.025).clamp(16.0, 24.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: (screenHeight * 0.08).clamp(20.0, 60.0)),
                    
                    // Main headline - Similar to Daily Dose
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Your Main',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: (screenWidth * 0.065).clamp(18.0, screenWidth > 600 ? 32.0 : 28.0),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '👑',
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.08).clamp(24.0, screenWidth > 600 ? 44.0 : 40.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Character Topic',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                                fontSize: (screenWidth * 0.05).clamp(16.0, screenWidth > 600 ? 28.0 : 26.0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Topic display - Big card like Daily Dose
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: (MediaQuery.of(context).size.height * 0.04).clamp(24.0, 40.0),
                          horizontal: (MediaQuery.of(context).size.width * 0.08).clamp(24.0, 40.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular((screenWidth * 0.06).clamp(20.0, 28.0)),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.mainTopic,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenWidth * 0.10).clamp(32.0, screenWidth > 600 ? 56.0 : 52.0),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'is your obsession',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: (screenWidth * 0.04).clamp(12.0, screenWidth > 600 ? 22.0 : 20.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Quote - Clean iOS style
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.05).clamp(16.0, 28.0)),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular((screenWidth * 0.04).clamp(14.0, 20.0)),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Every conversation circles back to ${widget.mainTopic}. It's your signature, your brand, your whole vibe. ✨",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (screenWidth * 0.039).clamp(13.0, screenWidth > 600 ? 20.0 : 18.0),
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Description - VIRAL potential
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.06).clamp(18.0, 32.0)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.22),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Plot twist: You're not diverse, you're focused 🎯",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenWidth * 0.042).clamp(15.0, 19.0),
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "While others dabble in random topics, you've mastered the art of hyperfixation. One topic, infinite questions. That's not limited — that's dedication. 💪",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: (screenWidth * 0.037).clamp(13.5, 17.0),
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
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

// Floating topic icons (sparkles, stars, books)
class _FloatingTopicIcons extends StatelessWidget {
  final AnimationController controller;

  const _FloatingTopicIcons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (index) {
            final size = MediaQuery.of(context).size;
            final random = Random(index * 11);
            final x = (index * 83.0 + random.nextDouble() * 100) % size.width;
            final baseY = (index * 117.0 + random.nextDouble() * 100) % size.height;
            final timeOffset = (controller.value * 2 * pi) + (index * 0.5);
            final float = sin(timeOffset) * 25;
            final opacity = (0.15 + (0.1 * sin(timeOffset))).clamp(0.0, 1.0);
            
            final iconTypes = [
              Icons.auto_stories_rounded,
              Icons.menu_book_rounded,
              Icons.library_books_rounded,
              Icons.star_rounded,
            ];
            
            return Positioned(
              left: x,
              top: baseY + float,
              child: Opacity(
                opacity: opacity,
                child: Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    return Container(
                      padding: EdgeInsets.all((screenWidth * 0.025).clamp(8.0, 14.0)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        iconTypes[index % iconTypes.length],
                        color: Colors.white,
                        size: 18 + (random.nextDouble() * 8),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
