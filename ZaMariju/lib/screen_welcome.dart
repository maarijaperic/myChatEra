import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/screen_login.dart';
import 'package:gpt_wrapped2/screen_fake_login.dart';
import 'package:gpt_wrapped2/services/app_version_service.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';
import 'package:url_launcher/url_launcher.dart';

// Set to true to force fake login for testing (bypasses backend check)
const bool FORCE_FAKE_LOGIN = false;

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
  bool _isNavigating = false; // Prevent multiple navigations

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
    // Prevent multiple navigations
    if (_isNavigating) {
      print('🔵 WelcomeScreen: Already navigating, ignoring tap');
      return;
    }
    
    print('🔵 WelcomeScreen: _handleGetStarted called');
    _isNavigating = true;
    
    // Show loading indicator while checking version
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    try {
      // Check if fake version is enabled via backend
      bool useFakeVersion = false;
      
      // If FORCE_FAKE_LOGIN is true, skip backend check and use fake login
      if (FORCE_FAKE_LOGIN) {
        print('🔵 WelcomeScreen: FORCE_FAKE_LOGIN is true - using FakeLoginScreen');
        useFakeVersion = true;
      } else {
        print('🔵 WelcomeScreen: Checking app version from backend...');
        try {
          useFakeVersion = await AppVersionService.isFakeVersionEnabled();
          print('🔵 WelcomeScreen: Backend returned useFakeVersion = $useFakeVersion');
          print('🔵 WelcomeScreen: useFakeVersion type = ${useFakeVersion.runtimeType}');
        } catch (e) {
          print('❌ WelcomeScreen: Backend check failed: $e');
          // If backend check fails, default to fake login (since that's what's currently enabled)
          print('🔵 WelcomeScreen: Defaulting to FakeLoginScreen due to backend error');
          useFakeVersion = true;
        }
      }
      
      print('🔵 WelcomeScreen: Final useFakeVersion value = $useFakeVersion');
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // ALWAYS use the same version based on useFakeVersion - no matter where user clicks
      // CRITICAL: Double-check useFakeVersion value before navigation
      print('🔵 WelcomeScreen: About to navigate - useFakeVersion = $useFakeVersion');
      
      if (mounted) {
        // Force use fake version if backend says so - no exceptions
        // useFakeVersion is already a bool from AppVersionService
        final shouldUseFake = useFakeVersion;
        print('🔵 WelcomeScreen: shouldUseFake = $shouldUseFake');
        
        if (shouldUseFake) {
          print('🔵 WelcomeScreen: ✅ CONFIRMED - Fake version enabled - Navigating to FakeLoginScreen');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                print('🔵 WelcomeScreen: Building FakeLoginScreen');
                return FakeLoginScreen(
                  onLoginSuccess: widget.onGetStarted,
                );
              },
            ),
          );
        } else {
          print('🔵 WelcomeScreen: ✅ CONFIRMED - Real version - Navigating to LoginScreen');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                print('🔵 WelcomeScreen: Building LoginScreen');
                return LoginScreen(
                  onLoginSuccess: widget.onGetStarted,
                  autoShowWebView: true, // Automatically show web view
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      print('❌ WelcomeScreen: Unexpected error: $e');
      // Close loading dialog if still open
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
        // On error, default to fake login (since that's what's currently enabled)
        print('🔵 WelcomeScreen: Error occurred, defaulting to FakeLoginScreen');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FakeLoginScreen(
              onLoginSuccess: widget.onGetStarted,
            ),
          ),
        );
      }
    } finally {
      // Reset navigation flag after a delay to allow navigation to complete
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _isNavigating = false;
        }
      });
    }
  }

  Future<void> _openTerms() async {
    final url = Uri.parse('https://github.com/maarijaperic/myChatEra-legal/blob/main/TERMS_OF_SERVICE.md');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Terms of Service'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPrivacy() async {
    final url = Uri.parse('https://github.com/maarijaperic/myChatEra-legal/blob/main/PRIVACY_POLICY.md');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Privacy Policy'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;
    final horizontalPadding = (screenWidth * 0.08).clamp(24.0, 40.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: WrappedColors.background),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        WrappedColors.pink.withOpacity(0.4),
                                        WrappedColors.purple.withOpacity(0.12),
                                        WrappedColors.purple.withOpacity(0.0),
                                      ],
                                      stops: const [0.0, 0.55, 1.0],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 128, height: 128, child: _buildLogo()),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          HighlightText(
                            'Your AI chats,\n*Wrapped.*',
                            accent: WrappedColors.pinkDeep,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: WrappedColors.ink,
                              fontSize: (screenWidth * 0.1).clamp(34.0, isLargeScreen ? 52.0 : 42.0),
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.2,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'See your personality analysis based on your chats with ChatGPT.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8E8E93),
                              fontSize: (screenWidth * 0.042).clamp(16.0, isLargeScreen ? 20.0 : 17.0),
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    WrappedPillButton(
                      label: 'Get Your Wrapped',
                      icon: Icons.auto_awesome_rounded,
                      onTap: _handleGetStarted,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Text(
                          'By continuing you agree to our',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFFAEAEB2),
                          ),
                        ),
                        GestureDetector(
                          onTap: _openTerms,
                          child: Text(
                            'Terms',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF636366),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          'and',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFFAEAEB2),
                          ),
                        ),
                        GestureDetector(
                          onTap: _openPrivacy,
                          child: Text(
                            'Privacy Policy',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF636366),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.07),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
