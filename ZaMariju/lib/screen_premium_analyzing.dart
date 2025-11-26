import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';

class PremiumAnalyzingScreen extends StatefulWidget {
  final List<ConversationData> conversations;
  final Function(PremiumInsights) onAnalysisComplete;
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

    final conversationsWithMessages =
        widget.conversations.where((conv) => conv.messages.isNotEmpty).toList();

    if (conversationsWithMessages.isEmpty) {
      if (widget.onError != null) {
        widget.onError!('No conversations with messages found.');
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

      // Complete
      if (mounted) {
        widget.onAnalysisComplete(premiumInsights);
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

