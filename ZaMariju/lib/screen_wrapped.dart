import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class WrappedStatsScreen extends StatefulWidget {
  final String question;
  final int statNumber;
  final String unit;
  final String poeticMessage;

  const WrappedStatsScreen({
    super.key,
    required this.question,
    required this.statNumber,
    required this.unit,
    required this.poeticMessage,
  });

  @override
  State<WrappedStatsScreen> createState() => _WrappedStatsScreenState();
}

class _WrappedStatsScreenState extends State<WrappedStatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chartController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
    await Future.delayed(const Duration(milliseconds: 600));
    _chartController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chartController.dispose();
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
          // Soft beige gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF5F1E8), // Soft beige
                  Color(0xFFF0E6D2), // Light cream
                  Color(0xFFE8DCC6), // Warm beige
                  Color(0xFFE0D2B8), // Soft tan
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
          
          // Subtle animated particles
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Header section
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'Your 2025 in Review',
                          textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF2D2D2D),
                              fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                            fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtitle
                          Text(
                            'A year of growth and discovery',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF666666),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Stats section (2x2 grid)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          // Top row
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  icon: '💬',
                                  title: '2847',
                                  subtitle: 'Total Messages',
                                  color: const Color(0xFFE8F4FD),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  icon: '📅',
                                  title: '312',
                                  subtitle: 'Active Days',
                                  color: const Color(0xFFF0F8E8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Bottom row
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  icon: '🔥',
                                  title: '23 days',
                                  subtitle: 'Longest Streak',
                                  color: const Color(0xFFFFF0E8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _StatCard(
                                  icon: '✅',
                                  title: 'October',
                                  subtitle: 'Top Month',
                                  color: const Color(0xFFE8F8E8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.08),
                    
                    // Monthly Activity section
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'Monthly Activity',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF2D2D2D),
                              fontSize: (screenWidth * 0.06).clamp(22.0, 26.0),
                          fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Bar chart
                          _MonthlyBarChart(
                            controller: _chartController,
                            screenWidth: screenWidth,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Poetic message
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.6,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.poeticMessage,
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
                    
                    // Share button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.8,
                      child: Center(
                        child: ShareToStoryButton(
                          shareText: 'My 2025 in Review: 2847 messages, 312 active days, 23-day streak! A year of growth and discovery 🎉 #ChatGPTWrapped',
                          primaryColor: const Color(0xFFE8F4FD),
                          secondaryColor: const Color(0xFFD1E7F5),
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

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF2D2D2D),
              fontSize: (screenWidth * 0.06).clamp(20.0, 24.0),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF666666),
              fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Monthly Bar Chart Widget
class _MonthlyBarChart extends StatelessWidget {
  final AnimationController controller;
  final double screenWidth;

  const _MonthlyBarChart({
    required this.controller,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final heights = [0.7, 0.8, 0.6, 0.9, 0.8, 0.7, 
                    0.8, 0.9, 0.8, 1.0, 0.7, 0.6]; // October is highest
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(12, (index) {
            final animatedHeight = heights[index] * controller.value;
            final barWidth = (screenWidth - 48 - 11 * 8) / 12; // Account for spacing
            
            return Column(
              children: [
                // Bar
                Container(
                  width: barWidth,
                  height: 120 * animatedHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFFFF7A00), Color(0xFFFFB366)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                // Month label
                Text(
                  months[index],
                  style: GoogleFonts.inter(
                    color: const Color(0xFF666666),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }),
        );
      },
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

// Subtle particles painter
class _SubtleParticlesPainter extends CustomPainter {
  final double animationValue;

  _SubtleParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw subtle floating dots
    for (int i = 0; i < 15; i++) {
      final x = (i * 67.0) % size.width;
      final y = (i * 43.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final float = 0.2 + 0.3 * sin(timeOffset);
      final dotSize = 1.0 + (1.0 * float);

      canvas.drawCircle(
        Offset(x, y),
        dotSize,
        paint..color = Colors.white.withOpacity(float * 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}