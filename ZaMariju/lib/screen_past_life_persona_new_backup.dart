import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class PastLifePersonaScreen extends StatefulWidget {
  final String question;
  final String personaTitle;
  final String personaEmoji;
  final String era;
  final String description;
  final String subtitle;

  const PastLifePersonaScreen({
    super.key,
    required this.question,
    required this.personaTitle,
    required this.personaEmoji,
    required this.era,
    required this.description,
    required this.subtitle,
  });

  @override
  State<PastLifePersonaScreen> createState() => _PastLifePersonaScreenState();
}

class _PastLifePersonaScreenState extends State<PastLifePersonaScreen>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _mainController;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Light pastel brown gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8D4C8), // Light tan
                  Color(0xFFE8CCC4), // Soft beige-pink
                  Color(0xFFE8C4C8), // Light mauve
                  Color(0xFFE0C8D4), // Soft lavender
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
          
          // Animated historical patterns
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              return CustomPaint(
                painter: HistoricalPatternsPainter(_scrollController.value),
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
                  SizedBox(height: screenHeight * 0.08),
                  
                  // Question
                  Text(
                    widget.question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: (screenWidth * 0.065).clamp(20.0, 28.0),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      height: 1.1,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.05),
                  
                  // Past Life Display Card
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
                        padding: const EdgeInsets.all(24),
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
                            // Era and Persona Title
                            Text(
                              widget.era,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8B4513),
                                fontSize: (screenWidth * 0.08).clamp(24.0, 32.0),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.personaTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF654321),
                                fontSize: (screenWidth * 0.06).clamp(18.0, 24.0),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Progress bar representing past life connection
                            Container(
                              width: double.infinity,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B4513).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: 0.8, // 80% connection
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Past Life Connection',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF777777),
                                fontSize: (screenWidth * 0.032).clamp(11.0, 14.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Description Card
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
                          widget.description,
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
                  ),
                  
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Share button
                  ShareToStoryButton(
                    shareText: 'In a past life, I was a ${widget.personaTitle}! ${widget.personaEmoji} History echoes in who we are today ✨ #ChatGPTWrapped',
                  ),
                  
                  SizedBox(height: screenHeight * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoricalPatternsPainter extends CustomPainter {
  final double animationValue;

  HistoricalPatternsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating historical symbols
    for (int i = 0; i < 8; i++) {
      final x = (size.width * 0.1) + (i * size.width * 0.12);
      final y = (size.height * 0.2) + 
                (sin(animationValue * 2 * pi + i) * 20) + 
                (i * size.height * 0.1);
      
      // Draw ancient symbols
      canvas.drawCircle(
        Offset(x, y),
        3 + (sin(animationValue * pi + i) * 2),
        paint,
      );
    }

    // Draw flowing lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final path = Path();
      final startY = size.height * 0.3 + (i * size.height * 0.2);
      
      path.moveTo(0, startY);
      path.quadraticBezierTo(
        size.width * 0.5,
        startY + (sin(animationValue * pi + i) * 30),
        size.width,
        startY + 20,
      );
      
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
