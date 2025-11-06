import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IntroScreen extends StatefulWidget {
  final VoidCallback onStart;

  const IntroScreen({
    super.key,
    required this.onStart,
  });

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;
    
    // Responsive padding
    final horizontalPadding = (screenWidth * 0.1).clamp(24.0, 48.0);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5), // Off-white
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // App Name
                  Text(
                    'MyChatEra',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.12).clamp(36.0, isLargeScreen ? 64.0 : 56.0),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D2D2D),
                      letterSpacing: -1.0,
                    ),
                  ),

                  SizedBox(height: (screenHeight * 0.015).clamp(10.0, 16.0)),

                  // Tagline
                  Text(
                    'Discover your year in AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.045).clamp(16.0, isLargeScreen ? 24.0 : 22.0),
                      color: const Color(0xFF2D2D2D).withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Main CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: (screenHeight * 0.07).clamp(48.0, 64.0),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Use the IntroScreen's context for navigation
                        widget.onStart();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF6B9D),
                              Color(0xFFFFB4A2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular((screenWidth * 0.04).clamp(14.0, 20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Analyze Your Chats Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (screenWidth * 0.042).clamp(15.0, isLargeScreen ? 22.0 : 20.0),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Privacy note
                  Text(
                    'All analysis happens securely.\nWe never store your passwords or conversations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF2D2D2D).withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
