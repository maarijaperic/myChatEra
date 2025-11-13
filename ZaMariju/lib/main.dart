import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/screen_login.dart';
import 'package:gpt_wrapped2/screen_intro.dart';
import 'package:gpt_wrapped2/card_navigator.dart';
import 'package:gpt_wrapped2/screen_analyzing_loading.dart';
import 'package:gpt_wrapped2/screen_chat_era.dart';
import 'package:gpt_wrapped2/screen_daily_dose.dart';
import 'package:gpt_wrapped2/screen_most_used_word.dart';
import 'package:gpt_wrapped2/screen_chat_days_tracker.dart';
import 'package:gpt_wrapped2/screen_gpt_oclock.dart';
import 'package:gpt_wrapped2/screen_type_ab_preview.dart';
import 'package:gpt_wrapped2/screen_chat_streak.dart';
import 'package:gpt_wrapped2/screen_curiosity_index.dart';
import 'package:gpt_wrapped2/screen_type_ab_personality.dart';
import 'package:gpt_wrapped2/screen_red_green_flags.dart';
import 'package:gpt_wrapped2/screen_guess_zodiac.dart';
import 'package:gpt_wrapped2/screen_introvert_extrovert.dart';
import 'package:gpt_wrapped2/screen_advice_most_asked.dart';
import 'package:gpt_wrapped2/screen_movie_title.dart';
import 'package:gpt_wrapped2/screen_love_language.dart';
import 'package:gpt_wrapped2/screen_past_life_persona.dart';
import 'package:gpt_wrapped2/screen_mbti_personality.dart';
import 'package:gpt_wrapped2/screen_wrapped.dart';
import 'package:gpt_wrapped2/screen_comparison.dart';
import 'package:gpt_wrapped2/screen_subscription.dart';
import 'package:gpt_wrapped2/screen_social_sharing.dart';
// Temporarily disabled data storage - requires Developer Mode on Windows
// import 'package:gpt_wrapped2/services/data_storage.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Proxy URL configuration
  // For local development: Set your local IP address
  // For production: Set your deployed server URL (e.g., Railway, Render)
  // 
  // To find your local IP: ipconfig (Windows) or ifconfig (Mac/Linux)
  // Example: AIAnalyzer.setProxyUrl('http://192.168.1.100:3000');
  // 
  // For Android emulator: 'http://10.0.2.2:3000'
  // For iOS Simulator: 'http://localhost:3000'
  // For production: 'https://your-app.railway.app' or similar
  //
  // IMPORTANT: Replace with your actual proxy server URL!
  // You can also use environment variables or build configurations
  const String proxyUrl = String.fromEnvironment(
    'PROXY_URL',
    defaultValue: 'http://localhost:3000', // Default for development
  );
  AIAnalyzer.setProxyUrl(proxyUrl);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Wrapped',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF006E),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const GPTWrappedHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GPTWrappedHome extends StatefulWidget {
  const GPTWrappedHome({super.key});

  @override
  State<GPTWrappedHome> createState() => _GPTWrappedHomeState();
}

class _GPTWrappedHomeState extends State<GPTWrappedHome> {
  // Temporarily disabled data loading - using demo data only
  // ChatStats? _stats;
  // bool _isLoading = true;

  PremiumInsights? _premiumInsights;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadStats();
  // }

  // Future<void> _loadStats() async {
  //   final stats = await DataStorage.loadStats();
  //   setState(() {
  //     _stats = stats;
  //     _isLoading = false;
  //   });
  // }

  void _startPremiumWrapped([PremiumInsights? insights]) {
    // Use provided insights or fall back to state
    final premiumInsights = insights ?? _premiumInsights;
    
    if (kDebugMode) {
      print('Premium debug — _startPremiumWrapped called');
      print('Premium debug — premiumInsights is null: ${premiumInsights == null}');
      if (premiumInsights != null) {
        print('Premium debug — using insights: ${premiumInsights.personalityType}');
      }
    }
    
    if (premiumInsights == null) {
      if (kDebugMode) {
        print('Premium debug — no cached insights. Unable to start premium flow.');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Premium insights not ready yet. Please try again in a moment.'),
        ),
      );
      return;
    }

    if (kDebugMode) {
      print(
        'Premium debug — navigating with insights: '
        '${premiumInsights.personalityType}, '
        '${premiumInsights.introExtroType}, '
        '${premiumInsights.mostAskedAdvice}, '
        'LoveLanguage=${premiumInsights.loveLanguage}',
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _PremiumWrappedNavigator(
          insights: premiumInsights,
        ),
      ),
    );
  }

  Future<void> _onLoginSuccess(List<dynamic>? conversations) async {
    // After login, analyze conversations and show loading screen
    final navigatorContext = Navigator.of(context);
    
    // Show analyzing screen while processing
    navigatorContext.pushReplacement(
      MaterialPageRoute(
        builder: (context) => AnalyzingLoadingScreen(
          onAnalysisComplete: (stats, premiumInsights) {
            print('🔴 PREMIUM_DEBUG: onAnalysisComplete - premiumInsights is null: ${premiumInsights == null}');
            if (premiumInsights != null) {
              print('🔴 PREMIUM_DEBUG: onAnalysisComplete - personalityType: ${premiumInsights.personalityType}');
            }
            
            if (mounted) {
              setState(() {
                _premiumInsights = premiumInsights;
              });
              print('🔴 PREMIUM_DEBUG: onAnalysisComplete - _premiumInsights set in state');
            }
            
            // After analysis, show intro screen with real stats
            // IMPORTANT: Pass premiumInsights directly from callback, not from state
            navigatorContext.pushReplacement(
              MaterialPageRoute(
                builder: (newContext) => IntroScreen(
                  onStart: () {
                    print('🔴 PREMIUM_DEBUG: IntroScreen onStart - premiumInsights is null: ${premiumInsights == null}');
                    // Navigate to wrapped screens with analyzed stats
                    navigatorContext.push(
                      MaterialPageRoute(
                        builder: (context) {
                          print('🔴 PREMIUM_DEBUG: Creating _FreeWrappedNavigator with premiumInsights: ${premiumInsights != null}');
                          return _FreeWrappedNavigator(
                            onPremiumTap: _startPremiumWrapped,
                            stats: stats, // Use real analyzed stats
                            premiumInsights: premiumInsights, // Pass directly from callback, not from state!
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
          conversations: conversations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const MaterialApp(
    //     home: Scaffold(
    //       body: Center(child: CircularProgressIndicator()),
    //     ),
    //   );
    // }
    return LoginScreen(onLoginSuccess: _onLoginSuccess);
  }
}

class _FreeWrappedNavigator extends StatelessWidget {
  final VoidCallback onPremiumTap;
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const _FreeWrappedNavigator({
    required this.onPremiumTap,
    this.stats,
    this.premiumInsights,
  });

  void _handlePremiumTap(BuildContext context) {
    print('🔴 PREMIUM_DEBUG: _handlePremiumTap CALLED');
    print('🔴 PREMIUM_DEBUG: _handlePremiumTap - premiumInsights is null: ${premiumInsights == null}');
    
    if (premiumInsights == null) {
      print('🔴 PREMIUM_DEBUG: _handlePremiumTap - premiumInsights is NULL, showing error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Premium insights not ready yet. Please try again in a moment.'),
        ),
      );
      return;
    }
    
    // PREMIUM_DEBUG: Check if insights are being passed correctly
    print('🔴 PREMIUM_DEBUG: _handlePremiumTap - personalityType: ${premiumInsights!.personalityType}');
    print('🔴 PREMIUM_DEBUG: _handlePremiumTap - mbtiType: ${premiumInsights!.mbtiType}');
    print('🔴 PREMIUM_DEBUG: _handlePremiumTap - zodiacName: ${premiumInsights!.zodiacName}');
    print('🔴 PREMIUM_DEBUG: _handlePremiumTap - Navigating to _PremiumWrappedNavigator');
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('🔴 PREMIUM_DEBUG: Building _PremiumWrappedNavigator widget');
          print('🔴 PREMIUM_DEBUG: Passing insights with personalityType: ${premiumInsights!.personalityType}');
          return _PremiumWrappedNavigator(
            insights: premiumInsights!,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PREMIUM_DEBUG: Check if premiumInsights is available
    print('🔴 PREMIUM_DEBUG: _FreeWrappedNavigator build - premiumInsights is null: ${premiumInsights == null}');
    if (premiumInsights != null) {
      print('🔴 PREMIUM_DEBUG: _FreeWrappedNavigator - premiumInsights.personalityType: ${premiumInsights!.personalityType}');
      print('🔴 PREMIUM_DEBUG: _FreeWrappedNavigator - premiumInsights.mbtiType: ${premiumInsights!.mbtiType}');
    }
    
    // Use real stats if available, otherwise use demo data
    final hours = stats?.totalHours ?? 127;
    final minutes = stats?.totalMinutes ?? 42;
    final messagesPerDay = stats?.messagesPerDay ?? 47;
    final streakDays = stats?.longestStreak ?? 14;
    final actualPeakTime = stats?.peakTime ?? 'night';
    final actualPeakHour = stats?.peakHour ?? 23;
    
    // Get time emoji and description based on actual peak time from stats
    String timeEmoji;
    String timeDescription;
    switch (actualPeakTime) {
      case 'morning':
        timeEmoji = '🌅';
        timeDescription = 'in the morning';
        break;
      case 'afternoon':
        timeEmoji = '☀️';
        timeDescription = 'in the afternoon';
        break;
      case 'evening':
        timeEmoji = '🌆';
        timeDescription = 'in the evening';
        break;
      default:
        timeEmoji = '🌙';
        timeDescription = 'at night';
    }

    return CardNavigator(
      screens: [
        // Index 0 - Daily Dose
        DailyDoseScreen(
          messagesPerDay: messagesPerDay,
        ),
        // Index 1 - Your Chat Era
        ChatEraScreen(
          totalHours: hours,
          totalMinutes: minutes,
        ),
        // Index 2 - Your Signature Word (Most Used Word)
        MostUsedWordScreen(
          mostUsedWord: stats?.mainTopic ?? 'literally',
          wordCount: stats?.mostUsedWordCount ?? 247,
        ),
        // Index 3 - Chat Days Tracker
        ChatDaysTrackerScreen(
          totalDays: stats?.totalDays ?? 102,
          yearPercentage: stats?.yearPercentage ?? 28,
        ),
        // Index 4 - Your Longest Chat Streak
        ChatStreakScreen(
          streakDays: streakDays,
        ),
        // Index 5 - Speed of Response (Average Response Time)
        CuriosityIndexScreen(
          averageResponseTime: stats?.averageResponseTime ?? 3.2,
          speedLabel: stats?.speedLabel ?? 'thoughtful',
        ),
        // Index 6 - GPT O'Clock (Your Peak Time)
        GptOClockScreen(
          peakTime: actualPeakTime,
          peakHour: actualPeakHour,
          timeDescription: timeDescription,
          timeEmoji: timeEmoji,
        ),
        // Index 7 - Unlock Premium
        TypeABPreviewScreen(
          onSubscribe: () {
            print('🔴 PREMIUM_DEBUG: TypeABPreviewScreen onSubscribe clicked');
            print('🔴 PREMIUM_DEBUG: premiumInsights is null: ${premiumInsights == null}');
            _handlePremiumTap(context);
          },
        ),
        // Index 8 - Choose Your Plan
        SubscriptionScreen(
          onSubscribe: () {
            print('🔴 PREMIUM_DEBUG: SubscriptionScreen onSubscribe clicked');
            print('🔴 PREMIUM_DEBUG: premiumInsights is null: ${premiumInsights == null}');
            _handlePremiumTap(context);
          },
        ),
        // Index 9 - MBTI Personality
        const MBTIPersonalityScreen(
          question: 'What is your MBTI personality type according to ChatGPT?',
          mbtiType: 'ENFP',
          mbtiEmoji: '🎭',
          personalityName: 'The Enthusiast',
          explanation: 'According to the analysis of your conversations, ChatGPT detected that you are an ENFP (Extroverted, Intuitive, Feeling, Perceiving). You are an enthusiastic, creative and sociable person who is motivated by possibilities. You have a great ability to connect with others and always seek new experiences and challenges. Your positive energy and your ability to inspire others are your greatest strengths.',
          subtitle: 'Your personality is unique, like a work of art 🎨',
        ),
        // Index 10 - Type A vs Type B Personality
        const TypeABPersonalityScreen(
          question: 'Are you Type A or Type B according to ChatGPT?',
          personalityType: 'TYPE A',
          typeEmoji: '⚡',
          typeAPercentage: 70,
          typeBPercentage: 30,
          explanation: 'Based on your conversations, GPT detected strong Type A traits. You\'re ambitious, organized, and impatient—probably asking follow-up questions before the first answer even finishes. You multitask like a pro, demand efficiency, and low-key stress about everything. But hey, at least you get stuff done. 💪',
          subtitle: 'Knowing yourself is the first step to growth 🌟',
        ),
        // Index 11 - Red Green Flags
        const RedGreenFlagsScreen(
          question: 'What are your red and green flags according to ChatGPT?',
          greenFlagTitle: 'Green Flags 🟢',
          redFlagTitle: 'Red Flags 🔴',
          greenFlags: [
            'You always apologize when you make a mistake',
            'You are very creative with your prompts',
            'You ask very intelligent questions',
            'You have a good sense of humor',
            'You are patient with long answers',
          ],
          redFlags: [
            'Sometimes you don\'t read the full answers',
            'You ask for the same thing several times in a row',
            'You don\'t specify what you want clearly',
            'You get frustrated when you don\'t understand something',
            'Sometimes you are very impatient',
          ],
          subtitle: 'Self-love also includes recognizing our areas for improvement 💚❤️',
        ),
        // Index 12 - Guess Zodiac
        const GuessZodiacScreen(
          question: 'What is your zodiac sign according to ChatGPT?',
          zodiacSign: 'Scorpio ♏',
          zodiacEmoji: '🦂',
          zodiacName: 'Scorpio',
          explanation: 'Based on your chats, you\'re giving major Scorpio energy 🦂✨ Intense conversations? Check. Deep questions at 3 AM? Check. Reading between every single line? That\'s so you. GPT says you\'re the friend who turns small talk into therapy sessions. Mysterious vibes only. 💅',
          subtitle: 'The stars don\'t lie... and neither does ChatGPT! ⭐',
        ),
        // Index 13 - Introvert Extrovert
        const IntrovertExtrovertScreen(
          question: 'Are you an introvert or extrovert according to ChatGPT?',
          personalityType: 'AMBIVERT',
          introvertPercentage: 55,
          extrovertPercentage: 45,
          explanation: 'According to your conversations, ChatGPT detected that you have a balanced personality. You are an ambivert: you enjoy both moments of solitary reflection and social interactions. You have the ability to adapt to different situations, being introspective when you need to process information and sociable when you want to share ideas.',
          subtitle: 'The perfect balance between introspection and sociability 🧠💬',
        ),
        // Index 14 - Advice Most Asked
        const AdviceMostAskedScreen(
          question: 'What advice have you asked ChatGPT for the most?',
          mostAskedAdvice: 'How to improve my personal relationships',
          adviceCategory: 'RELATIONSHIPS',
          adviceEmoji: '💕',
          explanation: 'According to the analysis of your conversations, you have sought advice about personal relationships more than any other topic. This shows that you value human connections and always seek to improve the way you relate to others. Your curiosity to better understand social dynamics is admirable.',
          subtitle: 'Wisdom is knowing what to ask 💡',
        ),
        // Index 15 - Love Language
        const LoveLanguageScreen(
          question: 'What\'s your love language according to ChatGPT?',
          loveLanguage: 'Words of Affirmation',
          languageEmoji: '💬',
          explanation: 'Based on your chats, GPT noticed you light up when validated. You seek reassurance, ask follow-up questions to make sure you\'re understood, and appreciate detailed explanations. You love when GPT acknowledges your ideas and reflects them back. Basically, you\'re the type who needs to hear "You\'re doing great!" even from an AI. And honestly? You are. 💕',
          subtitle: 'Love is spoken in many languages 💕',
          loveLanguagePercentages: {
            'Words of Affirmation': 35,
            'Quality Time': 25,
            'Acts of Service': 20,
            'Physical Touch': 15,
            'Receiving Gifts': 5,
          },
        ),
        // Index 16 - Past Life Persona (Last premium screen)
        const PastLifePersonaScreen(
          question: 'Who were you in a past life according to ChatGPT?',
          personaTitle: 'Renaissance Philosopher-Artist',
          personaEmoji: '🎨',
          era: '15TH CENTURY FLORENCE',
          description: 'You were a Renaissance thinker who questioned everything and created beauty from chaos. Your conversations reveal a mind that blends logic with creativity, always seeking deeper meaning. Like Da Vinci, you jump between disciplines—art, science, philosophy—never satisfied with surface-level answers. You probably had a dramatic scarf and too many unfinished projects.',
          subtitle: 'History echoes in who we are today ✨',
        ),
        // Index 18 - Your 2025 in Wrapped
        const WrappedStatsScreen(
          question: 'Your 2025 in Wrapped',
          statNumber: 2025,
          unit: 'YEAR',
          poeticMessage: 'Get ready for another year of growth, discovery, and countless conversations with an AI that will know you even better! Here\'s to asking even more interesting questions! 🎉',
        ),
        // Index 19 - Your GPT Wrapped
        const ComparisonStatsScreen(
          question: 'Your GPT Wrapped',
          firstName: 'You',
          firstValue: 127,
          firstEmoji: '👤',
          secondName: 'ChatGPT',
          secondValue: 89,
          secondEmoji: '🤖',
          poeticMessage: 'You\'ve created a beautiful partnership with AI this year. While others see ChatGPT as a tool, you\'ve made it your conversation partner, creative collaborator, and digital confidant. Here\'s to many more meaningful exchanges! 🌟',
        ),
        // Index 20 - Share with People
        const SocialSharingScreen(),
      ],
      startIndex: 0,
      premiumStartIndex: 21, // Prevent tapping past index 20
    );
  }
}

class _PremiumWrappedNavigator extends StatelessWidget {
  final PremiumInsights insights;

  const _PremiumWrappedNavigator({
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    // PREMIUM_DEBUG: Show what data is being used in screens
    print('🔴 PREMIUM_DEBUG: ========== _PremiumWrappedNavigator build ==========');
    print('🔴 PREMIUM_DEBUG: personalityType: ${insights.personalityType}');
    print('🔴 PREMIUM_DEBUG: typeAPercentage: ${insights.typeAPercentage}');
    print('🔴 PREMIUM_DEBUG: typeBPercentage: ${insights.typeBPercentage}');
    print('🔴 PREMIUM_DEBUG: mbtiType: ${insights.mbtiType}');
    print('🔴 PREMIUM_DEBUG: zodiacName: ${insights.zodiacName}');
    print('🔴 PREMIUM_DEBUG: zodiacSign: ${insights.zodiacSign}');
    print('🔴 PREMIUM_DEBUG: loveLanguage: ${insights.loveLanguage}');
    print('🔴 PREMIUM_DEBUG: introExtroType: ${insights.introExtroType}');
    print('🔴 PREMIUM_DEBUG: mostAskedAdvice: ${insights.mostAskedAdvice}');
    print('🔴 PREMIUM_DEBUG: movieTitle: ${insights.movieTitle}');
    print('🔴 PREMIUM_DEBUG: greenFlags count: ${insights.greenFlags.length}');
    print('🔴 PREMIUM_DEBUG: redFlags count: ${insights.redFlags.length}');
    print('🔴 PREMIUM_DEBUG: ================================================');

    return CardNavigator(
      screens: [
        // Index 0 - MBTI Personality (first premium screen)
        MBTIPersonalityScreen(
          question: 'What is your MBTI personality type according to ChatGPT?',
          mbtiType: insights.mbtiType,
          mbtiEmoji: insights.mbtiEmoji,
          personalityName: insights.personalityName,
          explanation: insights.mbtiExplanation,
          subtitle: 'Your personality is unique, like a work of art 🎨',
        ),
        // Index 1 - Type A/B Personality
        TypeABPersonalityScreen(
          question: 'Are you Type A or Type B according to ChatGPT?',
          personalityType: insights.personalityType,
          typeEmoji: _typeEmoji(insights.personalityType),
          typeAPercentage: insights.typeAPercentage,
          typeBPercentage: insights.typeBPercentage,
          explanation: insights.typeExplanation,
          subtitle: _personalitySubtitle(insights.personalityType),
        ),
        RedGreenFlagsScreen(
          question: 'What are your red and green flags according to ChatGPT?',
          greenFlagTitle: 'Green Flags 🟢',
          redFlagTitle: 'Red Flags 🔴',
          greenFlags: insights.greenFlags,
          redFlags: insights.redFlags,
          subtitle: 'Self-love also includes recognizing our areas for improvement 💚❤️',
        ),
        GuessZodiacScreen(
          question: 'What is your zodiac sign according to ChatGPT?',
          zodiacSign: insights.zodiacSign,
          zodiacEmoji: insights.zodiacEmoji,
          zodiacName: insights.zodiacName,
          explanation: insights.zodiacExplanation,
          subtitle: 'The stars don\'t lie... and neither does ChatGPT! ⭐',
        ),
        IntrovertExtrovertScreen(
          question: 'Are you an introvert or extrovert according to ChatGPT?',
          personalityType: insights.introExtroType,
          introvertPercentage: insights.introvertPercentage,
          extrovertPercentage: insights.extrovertPercentage,
          explanation: insights.introExtroExplanation,
          subtitle: _introExtroSubtitle(insights.introExtroType),
        ),
        AdviceMostAskedScreen(
          question: 'What advice have you asked ChatGPT for the most?',
          mostAskedAdvice: insights.mostAskedAdvice,
          adviceCategory: insights.adviceCategory,
          adviceEmoji: insights.adviceEmoji,
          explanation: insights.adviceExplanation,
          subtitle: 'Wisdom is knowing what to ask 💡',
        ),
        MovieTitleScreen(
          question: 'What movie title represents your life according to ChatGPT?',
          movieTitle: insights.movieTitle,
          releaseYear: insights.movieYear,
          explanation: insights.movieExplanation,
          subtitle: 'Plot twist: Your chats are cinema-worthy 🍿✨',
        ),
        LoveLanguageScreen(
          question: 'What\'s your love language according to ChatGPT?',
          loveLanguage: insights.loveLanguage,
          languageEmoji: insights.languageEmoji,
          explanation: insights.loveLanguageExplanation,
          subtitle: 'Love is spoken in many languages 💕',
          loveLanguagePercentages: _loveLanguageDistribution(insights.loveLanguage),
        ),
        PastLifePersonaScreen(
          question: 'Who were you in a past life according to ChatGPT?',
          personaTitle: insights.personaTitle,
          personaEmoji: insights.personaEmoji,
          era: insights.era,
          description: insights.personaDescription,
          subtitle: 'History echoes in who we are today ✨',
        ),
        // Index 9 - Your 2025 in Wrapped
        const WrappedStatsScreen(
          question: 'Your 2025 in Wrapped',
          statNumber: 2025,
          unit: 'YEAR',
          poeticMessage: 'Get ready for another year of growth, discovery, and countless conversations with an AI that will know you even better! Here\'s to asking even more interesting questions! 🎉',
        ),
        // Index 10 - Your GPT Wrapped
        const ComparisonStatsScreen(
          question: 'Your GPT Wrapped',
          firstName: 'You',
          firstValue: 127,
          firstEmoji: '👤',
          secondName: 'ChatGPT',
          secondValue: 89,
          secondEmoji: '🤖',
          poeticMessage: 'You\'ve created a beautiful partnership with AI this year. While others see ChatGPT as a tool, you\'ve made it your conversation partner, creative collaborator, and digital confidant. Here\'s to many more meaningful exchanges! 🌟',
        ),
        // Index 11 - Share with People
        const SocialSharingScreen(),
      ],
      startIndex: 0,
    );
  }

  String _typeEmoji(String type) {
    switch (type.toUpperCase()) {
      case 'TYPE A':
        return '⚡';
      case 'TYPE B':
        return '🌊';
      default:
        return '🌟';
    }
  }

  String _personalitySubtitle(String type) {
    switch (type.toUpperCase()) {
      case 'TYPE A':
        return 'You sprint through life with unstoppable energy ⚡';
      case 'TYPE B':
        return 'You flow through life with chill confidence 🌈';
      default:
        return 'Knowing yourself is the first step to growth 🌟';
    }
  }

  String _introExtroSubtitle(String type) {
    switch (type.toUpperCase()) {
      case 'INTROVERT':
        return 'Your quiet power lights up deep conversations 🌙';
      case 'EXTROVERT':
        return 'Your social battery charges the room 🔋';
      default:
        return 'The perfect balance between introspection and sociability 🧠💬';
    }
  }

  Map<String, int> _loveLanguageDistribution(String primary) {
    final defaultOrder = [
      'Words of Affirmation',
      'Quality Time',
      'Acts of Service',
      'Physical Touch',
      'Receiving Gifts',
    ];

    final normalizedPrimary = primary.trim().toLowerCase();
    final primaryKey = defaultOrder.firstWhere(
      (lang) => lang.toLowerCase() == normalizedPrimary,
      orElse: () => defaultOrder.first,
    );

    final distribution = <String, int>{};
    for (final lang in defaultOrder) {
      distribution[lang] = lang == primaryKey ? 40 : 15;
    }

    final total = distribution.values.reduce((a, b) => a + b);
    if (total != 100) {
      final diff = 100 - total;
      distribution[primaryKey] = (distribution[primaryKey]! + diff).clamp(0, 100);
    }

    return distribution;
  }

}

