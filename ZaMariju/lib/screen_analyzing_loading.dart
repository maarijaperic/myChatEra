import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';
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
        print('🔵 ANALYZING_DEBUG: Starting to parse ${widget.conversations!.length} conversations...');
        parsedConversations = DataProcessor.parseConversations(widget.conversations!);
        print('🔵 ANALYZING_DEBUG: Parsed ${parsedConversations.length} conversations');
        
        // Debug: Log conversation details
        int totalMessages = 0;
        for (int i = 0; i < parsedConversations.length; i++) {
          final conv = parsedConversations[i];
          totalMessages += conv.messages.length;
          if (i < 5) { // Log first 5 conversations
            print('🔵 ANALYZING_DEBUG: Conversation $i: id=${conv.id}, title=${conv.title}, messages=${conv.messages.length}');
          }
        }
        print('🔵 ANALYZING_DEBUG: Total messages parsed: $totalMessages');
        
        // Verify that conversations have messages
        final conversationsWithMessages = parsedConversations.where((conv) => conv.messages.isNotEmpty).toList();
        print('🔵 ANALYZING_DEBUG: Conversations with messages: ${conversationsWithMessages.length} out of ${parsedConversations.length}');
        
        if (conversationsWithMessages.isEmpty) {
          print('🔵 ANALYZING_DEBUG: WARNING - No conversations with messages after parsing!');
        }
        
        analyzedStats = DataProcessor.analyzeConversations(parsedConversations);
        print('🔵 ANALYZING_DEBUG: Analysis complete - stats calculated');
        print('🔵 ANALYZING_DEBUG: mainTopic = ${analyzedStats.mainTopic}');
        print('🔵 ANALYZING_DEBUG: mostUsedWordCount = ${analyzedStats.mostUsedWordCount}');
        print('🔵 ANALYZING_DEBUG: totalMessages = ${analyzedStats.totalMessages}');
        print('🔵 ANALYZING_DEBUG: totalConversations = ${analyzedStats.totalConversations}');
      } catch (e, stackTrace) {
        print('🔵 ANALYZING_DEBUG: Error analyzing conversations: $e');
        print('🔵 ANALYZING_DEBUG: Stack trace: $stackTrace');
        // Use empty stats if analysis fails
        analyzedStats = ChatStats.empty();
      }
    } else {
      // No conversations, use empty stats
      print('🔵 ANALYZING_DEBUG: No conversations provided');
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
      print('🔵 ANALYZING_DEBUG: Calling onAnalysisComplete');
      print('🔵 ANALYZING_DEBUG: Stats: ${analyzedStats.totalConversations} conversations, ${analyzedStats.totalMessages} messages');
      print('🔵 ANALYZING_DEBUG: Parsed conversations: ${parsedConversations.length}');
      
      // Verify conversations have messages before passing
      final conversationsWithMessages = parsedConversations.where((conv) => conv.messages.isNotEmpty).toList();
      print('🔵 ANALYZING_DEBUG: Conversations with messages to pass: ${conversationsWithMessages.length}');
      
      print('🔵 ANALYZING_DEBUG: About to call onAnalysisComplete');
      print('🔵 ANALYZING_DEBUG: analyzedStats.mainTopic = ${analyzedStats.mainTopic}');
      print('🔵 ANALYZING_DEBUG: analyzedStats.mostUsedWordCount = ${analyzedStats.mostUsedWordCount}');
      
      widget.onAnalysisComplete(
        analyzedStats,
        null, // Premium insights will be analyzed when user subscribes
        conversationsWithMessages.isNotEmpty ? conversationsWithMessages : null,
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
    return FadeTransition(
      opacity: _fadeController,
      child: AnalyzingView(
        title: _screenTitle,
        status: _statusText,
        progress: _progress,
      ),
    );
  }
}
