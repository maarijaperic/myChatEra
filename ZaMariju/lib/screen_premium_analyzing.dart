import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';
import 'dart:async';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/services/analysis_tracker.dart';
import 'package:gpt_wrapped2/services/revenuecat_service.dart';

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
      // First check if user is premium
      final isPremium = await RevenueCatService.isPremium();
      if (!isPremium) {
        // User is not premium - they need to purchase
        if (widget.onError != null) {
          widget.onError!(
            'Please purchase a subscription to access premium analysis.',
          );
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }
      
      // User is premium but reached limit
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
    return FadeTransition(
      opacity: _fadeController,
      child: AnalyzingView(
        title: 'Analyzing Premium Insights',
        status: _statusText,
        progress: _progress,
        emoji: '🔮',
      ),
    );
  }
}
