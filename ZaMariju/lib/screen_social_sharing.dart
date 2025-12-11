import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/screen_preview_analysis.dart';
import 'package:gpt_wrapped2/services/analysis_tracker.dart';
import 'package:gpt_wrapped2/services/revenuecat_service.dart';
import 'package:gpt_wrapped2/services/data_storage.dart';
import 'package:gpt_wrapped2/services/data_processor.dart';
import 'package:gpt_wrapped2/screen_premium_analyzing.dart';
import 'package:gpt_wrapped2/screen_login.dart';
import 'package:gpt_wrapped2/card_navigator.dart';

class SocialSharingScreen extends StatefulWidget {
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const SocialSharingScreen({
    super.key,
    this.stats,
    this.premiumInsights,
  });

  @override
  State<SocialSharingScreen> createState() => _SocialSharingScreenState();
}

class _SocialSharingScreenState extends State<SocialSharingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();

    try {
      print('🔵 SocialSharingScreen: initState called');
      print('🔵 SocialSharingScreen: stats is null = ${widget.stats == null}');
      print('🔵 SocialSharingScreen: premiumInsights is null = ${widget.premiumInsights == null}');

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _particlesController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _startAnimations();
    } catch (e, stackTrace) {
      print('❌ SocialSharingScreen: Error in initState: $e');
      print('❌ SocialSharingScreen: Stack trace: $stackTrace');
    }
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
    try {
      print('🔵 SocialSharingScreen: build called');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Soft pastel gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF5FB),
                  Color(0xFFF4F1FF),
                  Color(0xFFEFF6FF),
                  Color(0xFFEAF9FF),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
          
          // Subtle animated particles (TEMPORARILY DISABLED due to painting errors)
          // AnimatedBuilder(
          //   animation: _particlesController,
          //   builder: (context, child) {
          //     try {
          //       return CustomPaint(
          //         painter: _SubtleParticlesPainter(_particlesController.value),
          //         child: Container(),
          //       );
          //     } catch (e) {
          //       print('❌ SocialSharingScreen: Error building particles: $e');
          //       return Container();
          //     }
          //   },
          // ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.06).clamp(20.0, 24.0),
                  vertical: (screenHeight * 0.025).clamp(16.0, 20.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    
                    // Header + hero card
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.0,
                      child: Column(
                        children: [
                          Text(
                            'Share with People',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1F1F21),
                              fontSize: (screenWidth * 0.08).clamp(28.0, 36.0),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Turn your GPT Wrapped into a moment worth sharing.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF636366),
                              fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.045),
                          _ShareHeroCard(
                            screenWidth: screenWidth,
                                    stats: widget.stats,
                                    premiumInsights: widget.premiumInsights,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Info text about share button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.2,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.04).clamp(16.0, 20.0)),
                        margin: EdgeInsets.symmetric(horizontal: (screenWidth * 0.04).clamp(16.0, 22.0)),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFF006E).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '💡 Tip: Each premium screen has a share button at the bottom where you can share or screenshot the screen!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1F1F21),
                            fontSize: (screenWidth * 0.035).clamp(13.0, 15.0),
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Go to First Premium Screen Button
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.25,
                      child: const _GoToFirstPremiumButton(),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Get Another Analysis Button (for premium users)
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.3,
                      child: _GetAnotherAnalysisButton(
                        stats: widget.stats,
                        premiumInsights: widget.premiumInsights,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Message
                    _AnimatedFade(
                      controller: _fadeController,
                      delay: 0.4,
                      child: Container(
                        padding: EdgeInsets.all((screenWidth * 0.05).clamp(20.0, 24.0)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFFFFF), Color(0xFFF6F7FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'You can always share!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1F1F21),
                                fontSize: (screenWidth * 0.05).clamp(18.0, 22.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Use the share button on any screen to share your favorite insights directly to Instagram Story. Your journey with AI is worth sharing! 🌟',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF555555),
                                fontSize: (screenWidth * 0.038).clamp(14.0, 16.0),
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
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
    } catch (e, stackTrace) {
      print('❌ SocialSharingScreen: Error in build: $e');
      print('❌ SocialSharingScreen: Stack trace: $stackTrace');
      // Return a safe fallback widget
      return Scaffold(
        body: Center(
          child: Text('Error loading screen: $e'),
        ),
      );
    }
  }
}

// Simple View Preview Button that directly navigates
class _ViewPreviewButton extends StatelessWidget {
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const _ViewPreviewButton({
    required this.stats,
    required this.premiumInsights,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          print('🔵 _ViewPreviewButton: Button tapped - Navigating to PreviewAnalysisScreen');
          
          if (!context.mounted) {
            print('❌ _ViewPreviewButton: Context not mounted');
            return;
          }
          
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                print('🔵 _ViewPreviewButton: Building PreviewAnalysisScreen');
                return PreviewAnalysisScreen(
                  stats: stats,
                  premiumInsights: premiumInsights,
                );
              },
            ),
          );
          
          print('🔵 _ViewPreviewButton: Navigation completed');
        } catch (e, stackTrace) {
          print('❌ _ViewPreviewButton: Error: $e');
          print('❌ _ViewPreviewButton: Stack trace: $stackTrace');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error opening preview: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.play_fill, size: 16, color: Color(0xFF007AFF)),
            const SizedBox(width: 6),
            Text(
              'View preview',
              style: GoogleFonts.inter(
                color: const Color(0xFF007AFF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareHeroCard extends StatelessWidget {
  final double screenWidth;
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const _ShareHeroCard({
    required this.screenWidth,
    this.stats,
    this.premiumInsights,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = screenWidth > 600;
    final cardPadding = (screenWidth * 0.06).clamp(22.0, isLargeScreen ? 36.0 : 28.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular((screenWidth * 0.08).clamp(26.0, 36.0)),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.75),
                Colors.white.withOpacity(0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8E8E93).withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Preview',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF007AFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _ViewPreviewButton(
                    stats: stats,
                    premiumInsights: premiumInsights,
                  ),
                ],
              ),
              SizedBox(height: (screenWidth * 0.04).clamp(16.0, 24.0)),
              Text(
                'Share the highlights that made your GPT Wrapped unforgettable.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1F1F21),
                  fontSize: (screenWidth * 0.048).clamp(18.0, isLargeScreen ? 24.0 : 22.0),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                height: (screenWidth * 0.35).clamp(160.0, isLargeScreen ? 220.0 : 190.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D2D2D), Color(0xFF434343)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 18,
                      top: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.sparkles, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Wrapped',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all((screenWidth * 0.05).clamp(16.0, 20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '2025 Recap',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'AI knows you like never before.',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

/// Widget for "Get Another Analysis" button
class _GetAnotherAnalysisButton extends StatefulWidget {
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const _GetAnotherAnalysisButton({
    this.stats,
    this.premiumInsights,
  });

  @override
  State<_GetAnotherAnalysisButton> createState() => _GetAnotherAnalysisButtonState();
}

class _GetAnotherAnalysisButtonState extends State<_GetAnotherAnalysisButton> {
  bool _isLoading = false;
  bool _canGenerate = false;
  int _remaining = 0;
  String? _subscriptionType;

  @override
  void initState() {
    super.initState();
    // Don't call async method directly in initState - use WidgetsBinding
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkAvailability();
    });
  }

  Future<void> _checkAvailability() async {
    try {
      if (!mounted) return;
      final isPremium = await RevenueCatService.isPremium();
      if (!mounted) return;
      if (!isPremium) {
        if (mounted) {
        setState(() {
          _canGenerate = false;
        });
        }
        return;
      }

      if (!mounted) return;
      final subscriptionType = await RevenueCatService.getSubscriptionType();
      if (!mounted) return;
      if (subscriptionType == null) {
        if (mounted) {
        setState(() {
          _canGenerate = false;
        });
        }
        return;
      }

      if (!mounted) return;
      final canGenerate = await AnalysisTracker.canGenerateAnalysis();
      if (!mounted) return;
      final remaining = await AnalysisTracker.getRemainingAnalyses();

      if (mounted) {
      setState(() {
        _canGenerate = canGenerate;
        _remaining = remaining;
        _subscriptionType = subscriptionType;
      });
      }
    } catch (e, stackTrace) {
      print('❌ _GetAnotherAnalysisButton: Error checking analysis availability: $e');
      print('❌ _GetAnotherAnalysisButton: Stack trace: $stackTrace');
      if (mounted) {
      setState(() {
        _canGenerate = false;
      });
      }
    }
  }

  Future<void> _handleGetAnotherAnalysis() async {
    if (_isLoading || !_canGenerate) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if we have saved conversations
      final conversations = await DataStorage.loadConversations();

      if (conversations.isEmpty || conversations.any((c) => c.messages.isEmpty)) {
        // No saved conversations or empty - go to login
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => LoginScreen(
                onLoginSuccess: (conversations) async {
                  // After login, parse conversations and navigate to premium analyzing
                  if (conversations != null && conversations.isNotEmpty) {
                    // Parse conversations from List<dynamic> to List<ConversationData>
                    final parsedConversations = DataProcessor.parseConversations(conversations);
                    final conversationsWithMessages = parsedConversations.where((conv) => conv.messages.isNotEmpty).toList();
                    
                    if (conversationsWithMessages.isNotEmpty) {
                      Navigator.of(ctx).push(
                        MaterialPageRoute(
                          builder: (context) => PremiumAnalyzingScreen(
                            conversations: conversationsWithMessages,
                            onAnalysisComplete: (insights, convs) {
                              // Navigate back to social sharing or premium screens
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            onError: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text('No conversations with messages found. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          );
        }
      } else {
        // We have saved conversations - go directly to analysis
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PremiumAnalyzingScreen(
                conversations: conversations,
                onAnalysisComplete: (insights, convs) {
                  // Navigate back to social sharing
                  Navigator.of(ctx).pop();
                  // Refresh the button state
                  _checkAvailability();
                },
                onError: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error handling get another analysis: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_canGenerate) {
      // Don't show button if user doesn't have premium or has no remaining analyses
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (screenWidth * 0.06).clamp(20.0, 24.0)),
      child: Column(
        children: [
          GestureDetector(
            onTap: _isLoading ? null : _handleGetAnotherAnalysis,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: _isLoading
                    ? null
                    : const LinearGradient(
                        colors: [
                          Color(0xFFFF6B9D),
                          Color(0xFFFF8E9E),
                        ],
                      ),
                color: _isLoading ? Colors.grey : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Get Another Analysis',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (_remaining > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$_remaining left',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ),
          if (_remaining == 0 && _subscriptionType != 'one_time')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'You\'ve used all analyses this month. Wait until next month or upgrade.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF8E8E93),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget for "Go to First Premium Screen" button
class _GoToFirstPremiumButton extends StatelessWidget {
  const _GoToFirstPremiumButton();

  Future<void> _goToFirstPremiumScreen(BuildContext context) async {
    print('🔵 GoToFirstPremium: Button clicked - Navigating to first premium screen (MBTI)');
    
    try {
      // Method 1: Use CardNavigator.of() static method
      print('🔵 GoToFirstPremium: Method 1 - Using CardNavigator.of()...');
      final cardNavigatorState = CardNavigator.of(context);
      
      if (cardNavigatorState != null) {
        print('🔵 GoToFirstPremium: ✅ Found CardNavigatorState using CardNavigator.of()!');
        print('🔵 GoToFirstPremium: Current index: ${cardNavigatorState.currentIndex}');
        print('🔵 GoToFirstPremium: Total screens: ${cardNavigatorState.widget.screens.length}');
        
        // Check which navigator we're in by checking the first screen type
        final firstScreen = cardNavigatorState.widget.screens.isNotEmpty 
            ? cardNavigatorState.widget.screens[0].runtimeType.toString()
            : 'Unknown';
        print('🔵 GoToFirstPremium: First screen type: $firstScreen');
        
        // If first screen is MBTIPersonalityScreen, we're in PremiumWrappedNavigator (index 0)
        // If first screen is DailyDoseScreen, we're in FreeWrappedNavigator (index 8)
        int mbtiScreenIndex;
        if (firstScreen == 'MBTIPersonalityScreen') {
          mbtiScreenIndex = 0; // Premium navigator - MBTI is at index 0
          print('🔵 GoToFirstPremium: Detected PremiumWrappedNavigator - MBTI at index 0');
        } else {
          mbtiScreenIndex = 8; // Free navigator - MBTI is at index 8
          print('🔵 GoToFirstPremium: Detected FreeWrappedNavigator - MBTI at index 8');
        }
        
        print('🔵 GoToFirstPremium: Navigating to MBTI screen at index $mbtiScreenIndex...');
        await cardNavigatorState.goToIndex(mbtiScreenIndex);
        
        print('🔵 GoToFirstPremium: Navigation to MBTI screen completed successfully');
        return;
      }
      
      print('🔵 GoToFirstPremium: ❌ CardNavigatorState not found with CardNavigator.of()');
      
      // Method 2: Try findAncestorStateOfType directly
      print('🔵 GoToFirstPremium: Method 2 - Using findAncestorStateOfType...');
      final state2 = context.findAncestorStateOfType<CardNavigatorState>();
      if (state2 != null) {
        print('🔵 GoToFirstPremium: ✅ Found CardNavigatorState with findAncestorStateOfType!');
        print('🔵 GoToFirstPremium: Current index: ${state2.currentIndex}');
        
        // Check which navigator we're in
        final firstScreen = state2.widget.screens.isNotEmpty 
            ? state2.widget.screens[0].runtimeType.toString()
            : 'Unknown';
        print('🔵 GoToFirstPremium: First screen type: $firstScreen');
        
        int mbtiScreenIndex;
        if (firstScreen == 'MBTIPersonalityScreen') {
          mbtiScreenIndex = 0;
        } else {
          mbtiScreenIndex = 8;
        }
        
        print('🔵 GoToFirstPremium: Navigating to MBTI screen at index $mbtiScreenIndex...');
        await state2.goToIndex(mbtiScreenIndex);
        return;
      }
      
      print('🔵 GoToFirstPremium: ❌ CardNavigatorState not found with findAncestorStateOfType');
      
      // Method 3: Show error message
      print('🔵 GoToFirstPremium: ❌ All methods failed');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to navigate. Please swipe left to go back to the first screen.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('🔵 GoToFirstPremium: ❌ Exception: $e');
      print('🔵 GoToFirstPremium: Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.04).clamp(16.0, 22.0);

    return GestureDetector(
      onTap: () => _goToFirstPremiumScreen(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFB4D8), // Svetlija roze nijansa
              Color(0xFFFFD1E8), // Još svetlija roze nijansa
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB4D8).withOpacity(0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Back to First Premium Screen',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}