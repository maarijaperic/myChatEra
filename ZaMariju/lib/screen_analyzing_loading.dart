import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:gpt_wrapped2/services/data_processor.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';

class AnalyzingLoadingScreen extends StatefulWidget {
  final Function(ChatStats, PremiumInsights?, List<ConversationData>?) onAnalysisComplete;
  final List<dynamic>? conversations;
  final bool isPremiumAnalysis;
  final String? title;
  final List<String>? customLoadingSteps;
  final Function(String)? onProgressUpdate;

  const AnalyzingLoadingScreen({
    super.key,
    required this.onAnalysisComplete,
    this.conversations,
    this.isPremiumAnalysis = false,
    this.title,
    this.customLoadingSteps,
    this.onProgressUpdate,
  });

  @override
  State<AnalyzingLoadingScreen> createState() => _AnalyzingLoadingScreenState();
}

class _AnalyzingLoadingScreenState extends State<AnalyzingLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _fadeController;
  double _progress = 0.0;
  String _statusText = 'Connecting to AI...';

  List<String> get _loadingSteps {
    if (widget.customLoadingSteps != null) {
      return widget.customLoadingSteps!;
    }
    if (widget.isPremiumAnalysis) {
      return [
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
    }
    return [
      'Connecting to AI...',
      'Fetching your conversations...',
      'Analyzing your messages...',
      'Calculating statistics...',
      'Discovering premium insights...',
      'Preparing your Wrapped...',
    ];
  }

  String get _screenTitle {
    if (widget.title != null) {
      return widget.title!;
    }
    if (widget.isPremiumAnalysis) {
      return 'Analyzing Premium Insights';
    }
    return 'Analyzing Your Chats';
  }

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

    _startLoading();
  }

  Future<void> _startLoading() async {
    _fadeController.forward();

    ChatStats analyzedStats = ChatStats.empty();
    List<ConversationData> parsedConversations = [];

    // Step 1: Connecting
    setState(() {
      _statusText = _loadingSteps[0];
    });
    await _animateProgress(0.0, 0.15);
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 2: Fetching (already done, but show status)
    if (widget.conversations != null && widget.conversations!.isNotEmpty) {
      setState(() {
        _statusText = 'Processing conversations...';
      });
    } else {
      setState(() {
        _statusText = _loadingSteps[1];
      });
    }
    await _animateProgress(0.15, 0.35);
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 3: Analyzing messages
    setState(() {
      _statusText = _loadingSteps[2];
    });
    await _animateProgress(0.35, 0.55);
    
    // Actually process the conversations
    if (widget.conversations != null && widget.conversations!.isNotEmpty) {
      try {
        parsedConversations = DataProcessor.parseConversations(widget.conversations!);
        analyzedStats = DataProcessor.analyzeConversations(parsedConversations);
      } catch (e) {
        print('Error analyzing conversations: $e');
        // Use empty stats if analysis fails
        analyzedStats = ChatStats.empty();
      }
    } else {
      // No conversations, use empty stats
      analyzedStats = ChatStats.empty();
    }
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 4: Calculating statistics
    setState(() {
      _statusText = _loadingSteps[3];
    });
    await _animateProgress(0.55, 0.75);
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 5: Skipping premium insights (will be analyzed when user subscribes)
    setState(() {
      _statusText = 'Preparing your Wrapped...';
    });
    await _animateProgress(0.75, 0.90);
    
    // Premium insights will be analyzed when user clicks on subscription plan
    // Set to null initially - will be generated when user subscribes
    await Future.delayed(const Duration(milliseconds: 300));

    // Step 6: Preparing wrapped
    setState(() {
      _statusText = _loadingSteps[5];
    });
    await _animateProgress(0.90, 1.0);
    await Future.delayed(const Duration(milliseconds: 300));

    // Complete with analyzed stats (or empty if no data)
    // Pass parsed conversations so premium analysis can be done later
    // Premium insights will be null - will be generated when user subscribes
    if (mounted) {
      widget.onAnalysisComplete(
        analyzedStats,
        null, // Premium insights will be analyzed when user subscribes
        parsedConversations.isNotEmpty ? parsedConversations : null,
      );
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
                      _screenTitle,
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

