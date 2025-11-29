import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const AuthScreen({
    super.key,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
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

  void _showTermsDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms of Service',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.xmark_circle_fill,
                        color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _termsOfService,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.xmark_circle_fill,
                        color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _privacyPolicy,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Really light pastel pink
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo and Title Section
                  Column(
                    children: [
                      // Logo placeholder (same as splash)
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF6B9D),
                                Color(0xFFFF8FAD),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text(
                              '💬',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'MyChatEra',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C1C1E),
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Discover your AI story',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          color: const Color(0xFF8E8E93),
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  // Buttons Section
                  Column(
                    children: [
                      // Sign Up Button (Primary)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: widget.onSignUp,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B9D),
                                  Color(0xFFFF8FAD),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B9D).withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Login Button (Secondary)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: widget.onLogin,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E5EA),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Log In',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFFF6B9D),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // Terms and Privacy Links
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'By continuing, you agree to our ',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF8E8E93),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showTermsDialog,
                          child: Text(
                            'Terms of Service',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFFFF6B9D),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                        Text(
                          ' and ',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF8E8E93),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showPrivacyDialog,
                          child: Text(
                            'Privacy Policy',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFFFF6B9D),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              letterSpacing: -0.1,
                            ),
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

// Placeholder Terms of Service
const String _termsOfService = '''
Terms of Service - MyChatEra

Last Updated: January 2025

1. Acceptance of Terms
By using MyChatEra ("the App"), you agree to these Terms of Service.

2. Description of Service
MyChatEra is an application that analyzes your AI conversation history to provide insights, statistics, and personalized analytics about your usage patterns.

WE ARE NOT AFFILIATED WITH, ENDORSED BY, OR SPONSORED BY OPENAI.

3. How It Works

The App provides you with a secure, in-app web browser interface that allows you to sign in to your AI account directly through OpenAI's official website (chatgpt.com). Here's how the process works:

1. You initiate the login process within the App, which opens a secure web browser view displaying AI's official login page.

2. You enter your AI credentials directly into OpenAI's official login interface. Your credentials are entered only on OpenAI's website and are never stored, accessed, or transmitted by our App.

3. Once you successfully authenticate with OpenAI, the App retrieves your conversation metadata (such as conversation titles, dates, and message counts) using standard API requests that you authorize through your authenticated session.

4. The App processes this conversation data locally on your device to generate statistics and insights about your AI usage patterns.

5. For premium features, the App uses OpenAI's API (through our secure proxy server) to generate AI-powered insights based on your conversation data. The proxy server acts as an intermediary and does not store your data.

6. All data, including your conversation information and generated insights, is stored exclusively on your device using secure local storage. We do not maintain any servers, databases, or cloud storage containing your conversation content.

IMPORTANT: We do NOT store:
• Your OpenAI password or credentials
• Your conversation content on our servers
• Any personal information on our servers
• Any chat data on our servers

4. Risks and Disclaimers
⚠️ USE AT YOUR OWN RISK

Using third-party tools may violate OpenAI's Terms of Service and could result in account suspension or termination.

We are NOT responsible for any action OpenAI takes against your account.

5. Privacy
All analysis happens in real-time and data is deleted immediately after.

6. User Responsibilities
You agree to:
• Accept all risks of using third-party tools
• Not hold us liable for account issues
• Use the App legally and ethically

7. Premium Features
• Free Tier: Basic analysis (10 screens)
• Premium Tier (\$2.99): Full analysis (20+ screens)

8. Limitation of Liability
We provide the App "AS IS" with no warranties.

9. Contact
Email: support@mychatera.com

By using MyChatEra, you agree to these Terms of Service.
''';

// Placeholder Privacy Policy
const String _privacyPolicy = '''
Privacy Policy - MyChatEra

Last Updated: November 2024

1. Information We Collect
We temporarily access your AI conversation history for analysis purposes only.

2. What We DO NOT Store
• Passwords or credentials
• Conversation content
• Personal information
• Chat history

3. Data Processing
• All analysis happens in real-time
• Data is processed on secure servers
• Data is deleted immediately after analysis
• We use industry-standard encryption (HTTPS)

4. Analytics
We collect anonymous usage statistics:
• Number of users
• Feature usage
• App performance
• Error logs (no personal data)

5. Your Rights
You have the right to:
• Access your data
• Delete your data
• Opt out of analytics

6. Data Security
We implement industry-standard security measures to protect your information during processing.

7. Third-Party Services
We are not affiliated with OpenAI. Your use of AI is subject to OpenAI's own privacy policy.

8. Children's Privacy
Our service is not intended for users under 13 years of age.

9. Changes to Privacy Policy
We may update this policy and will notify users of significant changes.

10. Contact Us
Questions? Email: privacy@mychatera.com

Your privacy is important to us.
''';

