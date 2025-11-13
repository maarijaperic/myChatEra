import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class ComparisonStatsScreen extends StatefulWidget {
  final String question;
  final String firstName;
  final int firstValue;
  final String firstEmoji;
  final String secondName;
  final int secondValue;
  final String secondEmoji;
  final String poeticMessage;

  const ComparisonStatsScreen({
    super.key,
    required this.question,
    required this.firstName,
    required this.firstValue,
    required this.firstEmoji,
    required this.secondName,
    required this.secondValue,
    required this.secondEmoji,
    required this.poeticMessage,
  });

  @override
  State<ComparisonStatsScreen> createState() => _ComparisonStatsScreenState();
}

class _ComparisonStatsScreenState extends State<ComparisonStatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;

  // Last 6 months (Jul-Dec)
  final List<Map<String, dynamic>> monthlyObsessions = [
    {
      'month': 'JULY',
      'obsession': 'Summer Vibes',
      'emoji': '☀️',
      'color': Color(0xFFFFF5E5),
      'accentColor': Color(0xFFFFB84D),
    },
    {
      'month': 'AUGUST',
      'obsession': 'Learning',
      'emoji': '📚',
      'color': Color(0xFFE5F5FF),
      'accentColor': Color(0xFF4A90E2),
    },
    {
      'month': 'SEPTEMBER',
      'obsession': 'New Hobbies',
      'emoji': '🎨',
      'color': Color(0xFFF0E5FF),
      'accentColor': Color(0xFF9B59B6),
    },
    {
      'month': 'OCTOBER',
      'obsession': 'Productivity',
      'emoji': '⚡',
      'color': Color(0xFFFFF0E5),
      'accentColor': Color(0xFFFF8C42),
    },
    {
      'month': 'NOVEMBER',
      'obsession': 'Gratitude',
      'emoji': '🙏',
      'color': Color(0xFFE5FFE5),
      'accentColor': Color(0xFF2ECC71),
    },
    {
      'month': 'DECEMBER',
      'obsession': 'Reflection',
      'emoji': '✨',
      'color': Color(0xFFFFE5FF),
      'accentColor': Color(0xFFFF6B9D),
    },
  ];

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
    final isLargeScreen = screenWidth > 600;
    
    // Responsive padding
    final horizontalPadding = (screenWidth * 0.05).clamp(16.0, 24.0);
    final verticalPadding = (screenHeight * 0.02).clamp(12.0, 20.0);
    
    // Responsive spacing
    final topSpacing = (screenHeight * 0.04).clamp(20.0, 32.0);
    final sectionSpacing = (screenHeight * 0.04).clamp(24.0, 36.0);
    final cardSpacing = (screenWidth * 0.03).clamp(10.0, 16.0);
    final bottomSpacing = (screenHeight * 0.04).clamp(20.0, 32.0);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6), // Light pastel pink
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Column(
                  children: [
                    SizedBox(height: topSpacing),
                    
                    // Header section
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'Your GPT Wrapped',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1D1D1F),
                              fontSize: (screenWidth * 0.075).clamp(28.0, isLargeScreen ? 44.0 : 40.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: (screenHeight * 0.015).clamp(8.0, 16.0)),
                          // Subtitle
                          Text(
                            'Monthly Obsessions',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF86868B),
                              fontSize: (screenWidth * 0.042).clamp(14.0, isLargeScreen ? 20.0 : 18.0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: sectionSpacing),
                    
                    // Monthly Obsessions Grid (3 rows x 2 columns)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: List.generate(3, (rowIndex) {
                          return Column(
                            children: [
                              Row(
                                children: List.generate(2, (colIndex) {
                                  final index = rowIndex * 2 + colIndex;
                                  final monthData = monthlyObsessions[index];
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: colIndex == 0 ? cardSpacing / 2 : 0,
                                        left: colIndex == 1 ? cardSpacing / 2 : 0,
                                        bottom: rowIndex < 2 ? cardSpacing : 0,
                                      ),
                                      child: _MonthObsessionCard(
                                        month: monthData['month'],
                                        obsession: monthData['obsession'],
                                        emoji: monthData['emoji'],
                                        color: monthData['color'],
                                        accentColor: monthData['accentColor'],
                                        delay: 0.3 + (index * 0.1),
                                        fadeController: _fadeController,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    
                    SizedBox(height: sectionSpacing),
                    
                    // Share button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.9,
                      child: Center(
                        child: ShareToStoryButton(
                          shareText: 'My GPT Wrapped Monthly Obsessions: From summer vibes to reflection! Check out my year 🎉 #ChatGPTWrapped',
                          primaryColor: const Color(0xFF007AFF),
                          secondaryColor: const Color(0xFF0051D5),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: bottomSpacing),
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

// Month Obsession Card Widget
class _MonthObsessionCard extends StatelessWidget {
  final String month;
  final String obsession;
  final String emoji;
  final Color color;
  final Color accentColor;
  final double delay;
  final AnimationController fadeController;

  const _MonthObsessionCard({
    required this.month,
    required this.obsession,
    required this.emoji,
    required this.color,
    required this.accentColor,
    required this.delay,
    required this.fadeController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;
    
    return _AnimatedFade(
      controller: fadeController,
      delay: delay,
      child: Container(
        height: (screenHeight * 0.18).clamp(140.0, 200.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all((screenWidth * 0.04).clamp(16.0, 20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Month label
              Text(
                month,
                style: GoogleFonts.inter(
                  color: const Color(0xFF86868B),
                  fontSize: (screenWidth * 0.028).clamp(10.0, isLargeScreen ? 14.0 : 12.0),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              
              // Emoji and Obsession
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emoji,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.08).clamp(32.0, isLargeScreen ? 48.0 : 40.0),
                    ),
                  ),
                  SizedBox(height: (screenHeight * 0.01).clamp(6.0, 10.0)),
                  Text(
                    obsession,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1D1D1F),
                      fontSize: (screenWidth * 0.045).clamp(16.0, isLargeScreen ? 22.0 : 20.0),
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
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
      ..color = Colors.black.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Draw subtle floating dots
    for (int i = 0; i < 12; i++) {
      final x = (i * 67.0) % size.width;
      final y = (i * 43.0) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.4);
      final float = 0.2 + 0.3 * sin(timeOffset);
      final dotSize = 1.5 + (1.5 * float);

      canvas.drawCircle(
        Offset(x, y),
        dotSize,
        paint..color = Colors.black.withOpacity(float * 0.03),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
