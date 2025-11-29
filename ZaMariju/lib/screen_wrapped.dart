import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class WrappedStatsScreen extends StatefulWidget {
  final String question;
  final int statNumber;
  final String unit;
  final String poeticMessage;
  final List<Map<String, dynamic>>? monthlyTopics; // Personalizovane mesečne teme

  const WrappedStatsScreen({
    super.key,
    required this.question,
    required this.statNumber,
    required this.unit,
    required this.poeticMessage,
    this.monthlyTopics,
  });

  @override
  State<WrappedStatsScreen> createState() => _WrappedStatsScreenState();
}

class _WrappedStatsScreenState extends State<WrappedStatsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;

  // First 6 months (Jan-Jun)
  final List<Map<String, dynamic>> monthlyObsessions = [
    {
      'month': 'JANUARY',
      'obsession': 'Your Ex!',
      'sentence': 'Starting the year with reflection and closure.',
      'emoji': '💔',
      'color': Color(0xFFFFE5E5),
      'accentColor': Color(0xFFFF6B6B),
    },
    {
      'month': 'FEBRUARY',
      'obsession': 'Baking!',
      'sentence': 'Finding comfort in sweet creations and warm kitchens.',
      'emoji': '🍰',
      'color': Color(0xFFFFF0E5),
      'accentColor': Color(0xFFFF8C42),
    },
    {
      'month': 'MARCH',
      'obsession': 'Self-Care',
      'sentence': 'Prioritizing your well-being and inner peace.',
      'emoji': '🧘',
      'color': Color(0xFFE5F5FF),
      'accentColor': Color(0xFF4A90E2),
    },
    {
      'month': 'APRIL',
      'obsession': 'Career Goals',
      'sentence': 'Focusing on growth and professional development.',
      'emoji': '💼',
      'color': Color(0xFFF0E5FF),
      'accentColor': Color(0xFF9B59B6),
    },
    {
      'month': 'MAY',
      'obsession': 'Travel Plans',
      'sentence': 'Dreaming of new adventures and destinations.',
      'emoji': '✈️',
      'color': Color(0xFFE5FFE5),
      'accentColor': Color(0xFF2ECC71),
    },
    {
      'month': 'JUNE',
      'obsession': 'Fitness',
      'sentence': 'Building strength and healthy habits.',
      'emoji': '💪',
      'color': Color(0xFFFFF5E5),
      'accentColor': Color(0xFFFFB84D),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Off white background (like Share with People)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFAFAFA), // Off white
                  Color(0xFFF5F5F5), // Light gray
                  Color(0xFFF0F0F0), // Soft gray
                  Color(0xFFEBEBEB), // Medium gray
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
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
                            'Your 2025 in Review',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.08).clamp(28.0, isLargeScreen ? 44.0 : 36.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtitle
                          Text(
                            'Monthly Obsessions',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, isLargeScreen ? 20.0 : 16.0),
                              fontWeight: FontWeight.w400,
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
                                  // Koristi personalizovane teme ako postoje, inače fallback na default
                                  final monthData = (widget.monthlyTopics != null && 
                                                   widget.monthlyTopics!.length > index)
                                      ? widget.monthlyTopics![index]
                                      : monthlyObsessions[index];
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
                                        sentence: monthData['sentence'],
                                        emoji: monthData['emoji'],
                                        color: monthData['color'],
                                        accentColor: monthData['accentColor'],
                                        delay: 0.3 + (index * 0.1),
                                        fadeController: _fadeController,
                                        screenWidth: screenWidth,
                                        screenHeight: screenHeight,
                                        isLargeScreen: isLargeScreen,
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
                          shareText: 'My 2025 Monthly Obsessions: From your ex to baking to self-care! Check out my year in review 🎉 #mychateraAI',
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

// Month Obsession Card Widget (modern design with pastel colors)
class _MonthObsessionCard extends StatelessWidget {
  final String month;
  final String obsession;
  final String sentence;
  final String emoji;
  final Color color;
  final Color accentColor;
  final double delay;
  final AnimationController fadeController;
  final double screenWidth;
  final double screenHeight;
  final bool isLargeScreen;

  const _MonthObsessionCard({
    required this.month,
    required this.obsession,
    required this.sentence,
    required this.emoji,
    required this.color,
    required this.accentColor,
    required this.delay,
    required this.fadeController,
    required this.screenWidth,
    required this.screenHeight,
    required this.isLargeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedFade(
      controller: fadeController,
      delay: delay,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            constraints: BoxConstraints(
              minHeight: (screenHeight * 0.16).clamp(120.0, 180.0),
              maxHeight: (screenHeight * 0.20).clamp(160.0, 220.0),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.6),
                  color.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: accentColor.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all((screenWidth * 0.035).clamp(12.0, 18.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Month label
                  Text(
                    month,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF636366),
                      fontSize: (screenWidth * 0.026).clamp(9.0, isLargeScreen ? 13.0 : 11.0),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  
                  // Emoji, Obsession and Sentence
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Emoji
                        Text(
                          emoji,
                          style: TextStyle(
                            fontSize: (screenWidth * 0.07).clamp(28.0, isLargeScreen ? 40.0 : 36.0),
                          ),
                        ),
                        SizedBox(height: (screenHeight * 0.008).clamp(4.0, 8.0)),
                        // Obsession
                        Flexible(
                          child: Text(
                            obsession,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.04).clamp(14.0, isLargeScreen ? 20.0 : 18.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: (screenHeight * 0.006).clamp(3.0, 5.0)),
                        // Sentence
                        Flexible(
                          child: Text(
                            sentence,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.03).clamp(10.0, isLargeScreen ? 14.0 : 12.0),
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
