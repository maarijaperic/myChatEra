import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/screen_login.dart';

class WelcomeScreen extends StatefulWidget {
  final Function(List<dynamic>? conversations) onGetStarted;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      begin: const Offset(0, 0.2),
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

  Widget _buildLogo() {
    try {
      return Image.asset(
        'assets/images/logo_transparentno.png',
        width: 120,
        height: 120,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFFB4A2),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFFB4A2),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
      );
    }
  }

  Future<void> _handleGetStarted() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          onLoginSuccess: widget.onGetStarted,
          autoShowWebView: true, // Automatically show web view
        ),
      ),
    );
  }

  void _openTerms() {
    // TODO: Replace with actual terms URL
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Usage'),
        content: const Text('Terms of Usage will be available here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openPrivacy() {
    // TODO: Replace with actual privacy policy URL
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy Policy will be available here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.08).clamp(24.0, 40.0),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      
                      // Logo
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: _buildLogo(),
                      ),
                      
                      SizedBox(height: screenHeight * 0.06),
                      
                      // Get Your Wrapped Button
                      SizedBox(
                        width: double.infinity,
                        height: (screenHeight * 0.07).clamp(56.0, 70.0),
                        child: ElevatedButton(
                          onPressed: _handleGetStarted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F1F21),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (screenWidth * 0.04).clamp(16.0, 24.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: (screenHeight * 0.02).clamp(16.0, 20.0),
                            ),
                          ),
                          child: Text(
                            'Get Your Wrapped',
                            style: GoogleFonts.inter(
                              fontSize: (screenWidth * 0.045).clamp(16.0, isLargeScreen ? 22.0 : 20.0),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.05),
                      
                      // Terms and Privacy Policy
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: (screenWidth * 0.05).clamp(16.0, 24.0),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            Text(
                              'By clicking continue you agree with the',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: (screenWidth * 0.032).clamp(11.0, 13.0),
                                color: const Color(0xFF8E8E93),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: _openTerms,
                              child: Text(
                                'Terms of Usage',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: (screenWidth * 0.032).clamp(11.0, 13.0),
                                  color: const Color(0xFF1F1F21),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              'and',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: (screenWidth * 0.032).clamp(11.0, 13.0),
                                color: const Color(0xFF8E8E93),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: _openPrivacy,
                              child: Text(
                                'Privacy Policy',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: (screenWidth * 0.032).clamp(11.0, 13.0),
                                  color: const Color(0xFF1F1F21),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

