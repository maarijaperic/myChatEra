import 'package:flutter/material.dart';

class MovieTitleScreen extends StatefulWidget {
  final String movieTitle;
  final String explanation;
  final int releaseYear;

  const MovieTitleScreen({
    super.key,
    required this.movieTitle,
    required this.explanation,
    required this.releaseYear,
  });

  @override
  State<MovieTitleScreen> createState() => _MovieTitleScreenState();
}

class _MovieTitleScreenState extends State<MovieTitleScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _titleController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _titleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E), // Deep navy
                  Color(0xFF16213E), // Dark blue
                  Color(0xFF0F3460), // Ocean blue
                  Color(0xFFE94560), // Hollywood red
                  Color(0xFFFF6B9D), // Pink
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    
                    // Main headline
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Text(
                        'Your Life as a Movie Title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (screenWidth * 0.058).clamp(20.0, 26.0),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Movie poster frame
                    AnimatedBuilder(
                      animation: _titleController,
                      builder: (context, child) {
                        final slideAnimation = CurvedAnimation(
                          parent: _titleController,
                          curve: Curves.easeOutCubic,
                        );
                        
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - slideAnimation.value)),
                            child: Opacity(
                            opacity: slideAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFE94560).withOpacity(0.3),
                                    const Color(0xFF0F3460).withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFFFD700).withOpacity(0.6), // Gold border
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFD700).withOpacity(0.3),
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Movie title with emoji
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '🎬 ',
                                        style: TextStyle(
                                          fontSize: (screenWidth * 0.055).clamp(19.0, 25.0),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.movieTitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: (screenWidth * 0.055).clamp(19.0, 25.0),
                                            fontWeight: FontWeight.w800,
                                            height: 1.2,
                                            letterSpacing: 0.5,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.5),
                                                offset: const Offset(2, 2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Year and rating
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          '${widget.releaseYear}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.95),
                                            fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 2),
                                            child: Text(
                                              '⭐',
                                              style: TextStyle(
                                                fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: screenHeight * 0.015),
                    
                    // "Why this movie?" label
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '🎭',
                              style: TextStyle(
                                fontSize: (screenWidth * 0.045).clamp(16.0, 20.0),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Why This Movie?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.015),
                    
                    // Explanation text box
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.7,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          widget.explanation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: (screenWidth * 0.038).clamp(14.0, 17.0),
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.015),
                    
                    // Additional commentary
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.9,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.18),
                              Colors.white.withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Plot twist: Your chats are cinema-worthy 🍿",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenWidth * 0.042).clamp(15.0, 19.0),
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Based on your conversations, GPT analyzed your vibe, your drama levels, your plot twists, and your character development. The result? This movie perfectly captures your energy. Now we just need a Hollywood producer to notice. 🎬✨",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: (screenWidth * 0.038).clamp(14.0, 17.0),
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
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
