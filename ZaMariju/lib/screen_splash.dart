import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _controller.forward();

    // Navigate after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLogo() {
    // Try to load logo from assets, fallback to placeholder
    try {
      return Image.asset(
        'assets/images/logo_transparentno.png',
        width: 150,
        height: 150,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // If image not found, use placeholder
          return CustomPaint(
            size: const Size(150, 150),
            painter: _LogoPlaceholderPainter(),
          );
        },
      );
    } catch (e) {
      // Fallback to placeholder if asset not configured
      return CustomPaint(
        size: const Size(150, 150),
        painter: _LogoPlaceholderPainter(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5), // Off-white
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B9D).withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Try to load logo image, fallback to placeholder
                          _buildLogo(),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Placeholder logo painter (matches your description)
class _LogoPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFF6B9D), // Deep pink
          Color(0xFFFFB4A2), // Salmon/peach
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create the speech bubble with flowing tail (matching your description)
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Speech bubble part (left side)
    path.moveTo(centerX - 30, centerY - 35);
    path.cubicTo(
      centerX - 50, centerY - 35,
      centerX - 60, centerY - 25,
      centerX - 60, centerY - 5,
    );
    path.cubicTo(
      centerX - 60, centerY + 15,
      centerX - 50, centerY + 25,
      centerX - 30, centerY + 25,
    );
    
    // Start the flowing tail
    path.cubicTo(
      centerX - 20, centerY + 25,
      centerX - 15, centerY + 35,
      centerX - 10, centerY + 50,
    );
    
    // Large loop going down and around
    path.cubicTo(
      centerX - 5, centerY + 70,
      centerX + 10, centerY + 85,
      centerX + 35, centerY + 80,
    );
    
    // Loop back up
    path.cubicTo(
      centerX + 55, centerY + 75,
      centerX + 65, centerY + 50,
      centerX + 60, centerY + 20,
    );
    
    // Connect back to top
    path.cubicTo(
      centerX + 55, centerY - 10,
      centerX + 40, centerY - 30,
      centerX + 20, centerY - 35,
    );
    
    // Close with rounded top
    path.cubicTo(
      centerX + 10, centerY - 40,
      centerX - 10, centerY - 40,
      centerX - 30, centerY - 35,
    );
    
    canvas.drawPath(path, paint);
    
    // Add the three dots (typing indicator) inside speech bubble
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final dotRadius = 3.0;
    final dotY = centerY;
    
    canvas.drawCircle(Offset(centerX - 45, dotY), dotRadius, dotPaint);
    canvas.drawCircle(Offset(centerX - 35, dotY), dotRadius, dotPaint);
    canvas.drawCircle(Offset(centerX - 25, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

