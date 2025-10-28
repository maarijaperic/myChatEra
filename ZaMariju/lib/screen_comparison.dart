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
                            'Your GPT Wrapped',
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
                            'A beautiful partnership with AI',
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
                    
                    // Comparison Stats section (2x2 grid)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Column(
                        children: [
                          // Top row
                          Row(
                            children: [
                              Expanded(
                                child: _ComparisonCard(
                                  icon: widget.firstEmoji,
                                  title: widget.firstValue.toString(),
                                  subtitle: '${widget.firstName} Messages',
                                  color: const Color(0xFFE8F4FD),
                                ),
                              ),
                              const SizedBox(width: 16),
                    Expanded(
                                child: _ComparisonCard(
                                  icon: widget.secondEmoji,
                                  title: widget.secondValue.toString(),
                                  subtitle: '${widget.secondName} Responses',
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
                                child: _ComparisonCard(
                                  icon: '💬',
                                  title: '${widget.firstValue + widget.secondValue}',
                                  subtitle: 'Total Exchange',
                                  color: const Color(0xFFFFF0E8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ComparisonCard(
                                  icon: '🤝',
                                  title: '${(widget.firstValue / (widget.firstValue + widget.secondValue) * 100).round()}%',
                                  subtitle: 'You Lead',
                                  color: const Color(0xFFE8F8E8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.08),
                    
                    // Conversation Flow section
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'Conversation Flow',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF2D2D2D),
                              fontSize: (screenWidth * 0.06).clamp(22.0, 26.0),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Flow chart
                          _ConversationFlowChart(
                            controller: _chartController,
                            screenWidth: screenWidth,
                            userMessages: widget.firstValue,
                            gptResponses: widget.secondValue,
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
                          shareText: 'My GPT Wrapped: ${widget.firstValue} messages, ${widget.secondValue} responses! A beautiful partnership with AI 🤝 #ChatGPTWrapped',
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

// Comparison Card Widget
class _ComparisonCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ComparisonCard({
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

// Conversation Flow Chart Widget
class _ConversationFlowChart extends StatelessWidget {
  final AnimationController controller;
  final double screenWidth;
  final int userMessages;
  final int gptResponses;

  const _ConversationFlowChart({
    required this.controller,
    required this.screenWidth,
    required this.userMessages,
    required this.gptResponses,
  });

  @override
  Widget build(BuildContext context) {
    final totalMessages = userMessages + gptResponses;
    final userPercentage = userMessages / totalMessages;
    final gptPercentage = gptResponses / totalMessages;
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animatedUserPercentage = userPercentage * controller.value;
        final animatedGptPercentage = gptPercentage * controller.value;
        
        return Column(
          children: [
            // User messages bar
            Row(
              children: [
                Text(
                  'You',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF6BA3F5)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: animatedUserPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF6BA3F5)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(userPercentage * 100).round()}%',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // GPT responses bar
            Row(
              children: [
                Text(
                  'GPT',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2D2D2D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10A37F), Color(0xFF34D399)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: animatedGptPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10A37F), Color(0xFF34D399)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(gptPercentage * 100).round()}%',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
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