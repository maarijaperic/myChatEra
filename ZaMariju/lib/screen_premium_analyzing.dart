import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/services/analysis_tracker.dart';

class PremiumAnalyzingScreen extends StatefulWidget {
  final List<ConversationData> conversations;
  final Function(PremiumInsights, List<ConversationData>) onAnalysisComplete;
  final Function(String)? onError;

  const PremiumAnalyzingScreen({
    super.key,
    required this.conversations,
    required this.onAnalysisComplete,
    this.onError,
  });

  @override
  State<PremiumAnalyzingScreen> createState() => _PremiumAnalyzingScreenState();
}

class _PremiumAnalyzingScreenState extends State<PremiumAnalyzingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _fadeController;
  double _progress = 0.0;
  String _statusText = 'Analyzing Type A/B...';

  final List<String> _loadingSteps = [
    'Analyzing Type A/B...',
    'Identifying red and green flags...',
    'Determining love language...',
    'Analyzing introvert vs extrovert...',
    'Determining MBTI personality...',
    'Guessing zodiac sign...',
    'Finding most asked advice...',
    'Generating roast...',
    'Matching your movie title...',
    'Revealing past life persona...',
    'Preparing your Premium Wrapped...',
  ];

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    _fadeController.forward();

    // Check if user can generate analysis
    final canGenerate = await AnalysisTracker.canGenerateAnalysis();
    if (!canGenerate) {
      final remaining = await AnalysisTracker.getRemainingAnalyses();
      if (widget.onError != null) {
        widget.onError!(
          remaining == 0
              ? 'You have reached your analysis limit. Please wait until next month or upgrade your plan.'
              : 'Unable to generate analysis. Please try again.',
        );
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    // Debug: Log conversation details
    print('🔴 PREMIUM_DEBUG: Starting premium analysis');
    print('🔴 PREMIUM_DEBUG: Total conversations received: ${widget.conversations.length}');
    
    // Log details about each conversation
    for (int i = 0; i < widget.conversations.length; i++) {
      final conv = widget.conversations[i];
      print('🔴 PREMIUM_DEBUG: Conversation $i: id=${conv.id}, title=${conv.title}, messages=${conv.messages.length}');
      if (conv.messages.isEmpty) {
        print('🔴 PREMIUM_DEBUG: WARNING - Conversation $i has no messages!');
      } else {
        print('🔴 PREMIUM_DEBUG: Conversation $i first message: ${conv.messages.first.content.substring(0, conv.messages.first.content.length > 50 ? 50 : conv.messages.first.content.length)}...');
      }
    }

    final conversationsWithMessages =
        widget.conversations.where((conv) => conv.messages.isNotEmpty).toList();

    print('🔴 PREMIUM_DEBUG: Conversations with messages: ${conversationsWithMessages.length}');

    if (conversationsWithMessages.isEmpty) {
      print('🔴 PREMIUM_DEBUG: ERROR - No conversations with messages found!');
      print('🔴 PREMIUM_DEBUG: This might be a timing issue - conversations may not be fully parsed yet');
      
      if (widget.onError != null) {
        widget.onError!('No conversations with messages found. Please try again or restart the app.');
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    try {
      // Start with first step
      setState(() {
        _statusText = _loadingSteps[0];
        _currentStep = 0;
      });
      await _animateProgress(0.0, 0.1);

      // Analyze premium insights with progress updates
      final premiumInsights = await PremiumProcessor.analyzePremiumInsights(
        conversationsWithMessages,
        (progressMessage) {
          if (!mounted) return;
          
          // Update status text based on progress message
          setState(() {
            _statusText = progressMessage;
            
            // Update progress based on current step
            if (_currentStep < _loadingSteps.length - 1) {
              _currentStep++;
            }
            
            // Calculate progress: each step is approximately 1/10 of total
            _progress = (_currentStep / _loadingSteps.length).clamp(0.0, 0.95);
          });
        },
      );

      // Final step
      if (mounted) {
        setState(() {
          _statusText = _loadingSteps[_loadingSteps.length - 1];
          _progress = 1.0;
        });
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Increment analysis count in Firebase
      await AnalysisTracker.incrementAnalysisCount();

      // Complete
      if (mounted) {
        widget.onAnalysisComplete(premiumInsights, conversationsWithMessages);
      }
    } catch (e) {
      print('Error during premium analysis: $e');
      if (widget.onError != null) {
        widget.onError!('Error analyzing premium insights: ${e.toString()}');
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _animateProgress(double from, double to) async {
    final duration = 800;
    final steps = 20;
    final increment = (to - from) / steps;

    for (int i = 0; i < steps; i++) {
      if (!mounted) return;
      await Future.delayed(Duration(milliseconds: duration ~/ steps));
      setState(() {
        _progress = from + (increment * (i + 1));
      });
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Status text
                    Text(
                      'Analyzing Premium Insights',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Progress bar container
                    Container(
                      width: screenWidth * 0.7,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Animated progress fill
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            width: (screenWidth * 0.7) * _progress,
                            height: 6,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B9D),
                                  Color(0xFFFFB4A2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Current step text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _statusText,
                        key: ValueKey<String>(_statusText),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF8E8E93),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
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

