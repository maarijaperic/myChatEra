import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class LoveLanguageScreen extends StatefulWidget {
  final String question;
  final String loveLanguage;
  final String languageEmoji;
  final String explanation;
  final String subtitle;
  final Map<String, int> loveLanguagePercentages; // e.g., {'Words': 35, 'Acts': 25, 'Gifts': 20, 'Time': 20}

  const LoveLanguageScreen({
    super.key,
    required this.question,
    required this.loveLanguage,
    required this.languageEmoji,
    required this.explanation,
    required this.subtitle,
    required this.loveLanguagePercentages,
  });

  @override
  State<LoveLanguageScreen> createState() => _LoveLanguageScreenState();
}

class _LoveLanguageScreenState extends State<LoveLanguageScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartsController;
  late AnimationController _mainController;

  @override
  void initState() {
    super.initState();
    _heartsController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _startLoadingSequence();
  }

  Future<void> _startLoadingSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mainController.forward();
  }

  @override
  void dispose() {
    _heartsController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  Widget _buildCircularChart(String label, int percentage, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
              ),
              
              // Progress circle
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 6,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              
              // Center percentage
              Text(
                '$percentage%',
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Label
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF555555),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // More pastel gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFE8F0), // Very light pastel pink
                  Color(0xFFFFDDE8), // Light pastel pink
                  Color(0xFFFFD1E0), // Soft pastel pink
                  Color(0xFFFFC5D8), // Gentle pastel pink
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
          
          // Animated hearts
          AnimatedBuilder(
            animation: _heartsController,
            builder: (context, child) {
              return CustomPaint(
                painter: HeartsPainter(_heartsController.value),
                child: Container(),
              );
            },
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  
                  // Question
                  Text(
                    widget.question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: (MediaQuery.of(context).size.width * 0.065).clamp(20.0, 28.0),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      height: 1.1,
                    ),
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  
                  // Love Language Display Card with 4 Circular Bars
                  FadeTransition(
                    opacity: _mainController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _mainController,
                        curve: Curves.easeOutCubic,
                      )),
                      child: Container(
                        padding: const EdgeInsets.all(20),
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
                        child: Column(
                          children: [
                            // 4 Circular Progress Charts
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircularChart('Words', widget.loveLanguagePercentages['Words'] ?? 0, const Color(0xFFFF6B9D)),
                                _buildCircularChart('Acts', widget.loveLanguagePercentages['Acts'] ?? 0, const Color(0xFF4ECDC4)),
                                _buildCircularChart('Gifts', widget.loveLanguagePercentages['Gifts'] ?? 0, const Color(0xFF45B7D1)),
                                _buildCircularChart('Time', widget.loveLanguagePercentages['Time'] ?? 0, const Color(0xFF96CEB4)),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Primary Love Language
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8E9E)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.loveLanguage,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.width * 0.055).clamp(20.0, 24.0),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  
                  // Explanation Card
                  FadeTransition(
                    opacity: _mainController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _mainController,
                        curve: Curves.easeOutCubic,
                      )),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                          widget.explanation,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF555555),
                            fontSize: (MediaQuery.of(context).size.width * 0.038).clamp(14.0, 16.0),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  FadeTransition(
                    opacity: _mainController,
                    child: Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Share button
                  FadeTransition(
                    opacity: _mainController,
                    child: ShareToStoryButton(
                      shareText: 'My love language is ${widget.loveLanguage}! ${widget.languageEmoji} Love is spoken in many languages 💕 #ChatGPTWrapped',
                    ),
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartsPainter extends CustomPainter {
  final double animationValue;

  HeartsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final numHearts = 25;
    
    for (int i = 0; i < numHearts; i++) {
      final x = (i * 43.0) % size.width;
      final y = ((i * 29.0) + (animationValue * 100)) % size.height;
      final timeOffset = (animationValue * 2 * pi) + (i * 0.3);
      final pulse = 0.3 + 0.7 * sin(timeOffset);
      final heartSize = 1.5 + (2.0 * pulse);
      
      // Draw heart shape
      _drawHeart(
        canvas,
        Offset(x, y),
        heartSize,
        paint..color = Colors.white.withOpacity(pulse * 0.7),
      );
    }
    
    // Add sparkles
    for (int i = 0; i < 20; i++) {
      final x = (i * 51.0 + 20.0) % size.width;
      final y = (i * 37.0 + 15.0) % size.height;
      final timeOffset = (animationValue * 3 * pi) + (i * 0.5);
      final sparkle = 0.2 + 0.6 * sin(timeOffset);
      final sparkleSize = 0.5 + (1.5 * sparkle);
      
      canvas.drawCircle(
        Offset(x, y),
        sparkleSize,
        paint..color = Colors.white.withOpacity(sparkle * 0.9),
      );
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    
    // Heart shape using cubic bezier curves
    path.moveTo(center.dx, center.dy + size * 3);
    
    path.cubicTo(
      center.dx - size * 3, center.dy - size * 1.5,
      center.dx - size * 3, center.dy + size * 1,
      center.dx, center.dy + size * 3,
    );
    
    path.cubicTo(
      center.dx + size * 3, center.dy + size * 1,
      center.dx + size * 3, center.dy - size * 1.5,
      center.dx, center.dy + size * 3,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


