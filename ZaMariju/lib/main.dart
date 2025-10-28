import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/screen_intro.dart';
import 'package:gpt_wrapped2/card_navigator.dart';
import 'package:gpt_wrapped2/screen_chat_era.dart';
import 'package:gpt_wrapped2/screen_daily_dose.dart';
import 'package:gpt_wrapped2/screen_first_message.dart';
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
import 'package:gpt_wrapped2/screen_roast.dart';
import 'package:gpt_wrapped2/screen_subscription.dart';
import 'package:gpt_wrapped2/screen_social_sharing.dart';
// Temporarily disabled data storage - requires Developer Mode on Windows
// import 'package:gpt_wrapped2/services/data_storage.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  void _startFreeWrapped() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FreeWrappedNavigator(
          onPremiumTap: _startPremiumWrapped,
          stats: null, // Using demo data for now
        ),
      ),
    );
  }

  void _startPremiumWrapped() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const _PremiumWrappedNavigator(),
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
    return IntroScreen(onStart: _startFreeWrapped);
  }
}

class _FreeWrappedNavigator extends StatelessWidget {
  final VoidCallback onPremiumTap;
  final ChatStats? stats;

  const _FreeWrappedNavigator({
    required this.onPremiumTap,
    this.stats,
  });

  @override
  Widget build(BuildContext context) {
    // Use real stats if available, otherwise use demo data
    final hours = stats?.totalHours ?? 127;
    final minutes = stats?.totalMinutes ?? 42;
    final messagesPerDay = stats?.messagesPerDay ?? 47;
    final streakDays = stats?.longestStreak ?? 14;
    final peakTime = stats?.peakTime ?? 'night';
    final peakHour = stats?.peakHour ?? 23;
    
    // Get time emoji based on peak time
    String timeEmoji;
    String timeDescription;
    switch (peakTime) {
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
        // Index 2 - Where It All Began (First Message)
        const FirstMessageScreen(
          firstMessage: 'How do I stop procrastinating?',
        ),
        // Index 3 - Your Signature Word (Most Used Word)
        const MostUsedWordScreen(
          mostUsedWord: 'literally',
          wordCount: 247,
        ),
        // Index 4 - Chat Days Tracker
        const ChatDaysTrackerScreen(
          totalDays: 102,
          yearPercentage: 28,
        ),
        // Index 5 - Your Longest Chat Streak
        ChatStreakScreen(
          streakDays: streakDays,
        ),
        // Index 6 - Speed of Response (Average Response Time)
        const CuriosityIndexScreen(
          averageResponseTime: 3.2,
          speedLabel: 'lightning-fast',
        ),
        // Index 7 - GPT O'Clock (Your Peak Time)
        GptOClockScreen(
          peakTime: peakTime,
          peakHour: peakHour,
          timeDescription: timeDescription,
          timeEmoji: timeEmoji,
        ),
        // Index 8 - Unlock Premium
        TypeABPreviewScreen(
          onSubscribe: onPremiumTap,
        ),
        // Index 9 - Choose Your Plan
        SubscriptionScreen(
          onSubscribe: onPremiumTap,
        ),
        // Index 10 - MBTI Personality
        const MBTIPersonalityScreen(
          question: 'What is your MBTI personality type according to ChatGPT?',
          mbtiType: 'ENFP',
          mbtiEmoji: '🎭',
          personalityName: 'The Enthusiast',
          explanation: 'According to the analysis of your conversations, ChatGPT detected that you are an ENFP (Extroverted, Intuitive, Feeling, Perceiving). You are an enthusiastic, creative and sociable person who is motivated by possibilities. You have a great ability to connect with others and always seek new experiences and challenges. Your positive energy and your ability to inspire others are your greatest strengths.',
          subtitle: 'Your personality is unique, like a work of art 🎨',
        ),
        // Index 11 - Type A vs Type B Personality
        const TypeABPersonalityScreen(
          question: 'Are you Type A or Type B according to ChatGPT?',
          personalityType: 'TYPE A',
          typeEmoji: '⚡',
          typeAPercentage: 70,
          typeBPercentage: 30,
          explanation: 'Based on your conversations, GPT detected strong Type A traits. You\'re ambitious, organized, and impatient—probably asking follow-up questions before the first answer even finishes. You multitask like a pro, demand efficiency, and low-key stress about everything. But hey, at least you get stuff done. 💪',
          subtitle: 'Knowing yourself is the first step to growth 🌟',
        ),
        // Index 12 - Red Green Flags
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
        // Index 13 - Guess Zodiac
        const GuessZodiacScreen(
          question: 'What is your zodiac sign according to ChatGPT?',
          zodiacSign: 'Scorpio ♏',
          zodiacEmoji: '🦂',
          zodiacName: 'Scorpio',
          explanation: 'Based on your chats, you\'re giving major Scorpio energy 🦂✨ Intense conversations? Check. Deep questions at 3 AM? Check. Reading between every single line? That\'s so you. GPT says you\'re the friend who turns small talk into therapy sessions. Mysterious vibes only. 💅',
          subtitle: 'The stars don\'t lie... and neither does ChatGPT! ⭐',
        ),
        // Index 14 - Introvert Extrovert
        const IntrovertExtrovertScreen(
          question: 'Are you an introvert or extrovert according to ChatGPT?',
          personalityType: 'AMBIVERT',
          introvertPercentage: 55,
          extrovertPercentage: 45,
          explanation: 'According to your conversations, ChatGPT detected that you have a balanced personality. You are an ambivert: you enjoy both moments of solitary reflection and social interactions. You have the ability to adapt to different situations, being introspective when you need to process information and sociable when you want to share ideas.',
          subtitle: 'The perfect balance between introspection and sociability 🧠💬',
        ),
        // Index 15 - Advice Most Asked
        const AdviceMostAskedScreen(
          question: 'What advice have you asked ChatGPT for the most?',
          mostAskedAdvice: 'How to improve my personal relationships',
          adviceCategory: 'RELATIONSHIPS',
          adviceEmoji: '💕',
          explanation: 'According to the analysis of your conversations, you have sought advice about personal relationships more than any other topic. This shows that you value human connections and always seek to improve the way you relate to others. Your curiosity to better understand social dynamics is admirable.',
          subtitle: 'Wisdom is knowing what to ask 💡',
        ),
        // Index 16 - Love Language
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
        // Index 17 - Past Life Persona (Last premium screen)
        const PastLifePersonaScreen(
          question: 'Who were you in a past life according to ChatGPT?',
          personaTitle: 'Renaissance Philosopher-Artist',
          personaEmoji: '🎨',
          era: '15TH CENTURY FLORENCE',
          description: 'You were a Renaissance thinker who questioned everything and created beauty from chaos. Your conversations reveal a mind that blends logic with creativity, always seeking deeper meaning. Like Da Vinci, you jump between disciplines—art, science, philosophy—never satisfied with surface-level answers. You probably had a dramatic scarf and too many unfinished projects.',
          subtitle: 'History echoes in who we are today ✨',
        ),
        // Index 19 - Your 2025 in Wrapped
        const WrappedStatsScreen(
          question: 'Your 2025 in Wrapped',
          statNumber: 2025,
          unit: 'YEAR',
          poeticMessage: 'Get ready for another year of growth, discovery, and countless conversations with an AI that will know you even better! Here\'s to asking even more interesting questions! 🎉',
        ),
        // Index 20 - Your GPT Wrapped
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
        // Index 21 - Share with People
        const SocialSharingScreen(),
      ],
      startIndex: 0,
      premiumStartIndex: 22, // Prevent tapping past index 21
    );
  }
}

class _PremiumWrappedNavigator extends StatelessWidget {
  const _PremiumWrappedNavigator();

  @override
  Widget build(BuildContext context) {
    return CardNavigator(
      screens: [
        // Index 0 - Type A vs Type B Personality
        const TypeABPersonalityScreen(
          question: 'Are you Type A or Type B according to ChatGPT?',
          personalityType: 'TYPE A',
          typeEmoji: '⚡',
          typeAPercentage: 70,
          typeBPercentage: 30,
          explanation: 'Based on your conversations, GPT detected strong Type A traits. You\'re ambitious, organized, and impatient—probably asking follow-up questions before the first answer even finishes. You multitask like a pro, demand efficiency, and low-key stress about everything. But hey, at least you get stuff done. 💪',
          subtitle: 'Knowing yourself is the first step to growth 🌟',
        ),
        // Index 1
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
        // Index 2
        const GuessZodiacScreen(
          question: 'What is your zodiac sign according to ChatGPT?',
          zodiacSign: 'Scorpio ♏',
          zodiacEmoji: '🦂',
          zodiacName: 'Scorpio',
          explanation: 'Based on your chats, you\'re giving major Scorpio energy 🦂✨ Intense conversations? Check. Deep questions at 3 AM? Check. Reading between every single line? That\'s so you. GPT says you\'re the friend who turns small talk into therapy sessions. Mysterious vibes only. 💅',
          subtitle: 'The stars don\'t lie... and neither does ChatGPT! ⭐',
        ),
        // Index 3
        const IntrovertExtrovertScreen(
          question: 'Are you an introvert or extrovert according to ChatGPT?',
          personalityType: 'AMBIVERT',
          introvertPercentage: 55,
          extrovertPercentage: 45,
          explanation: 'According to your conversations, ChatGPT detected that you have a balanced personality. You are an ambivert: you enjoy both moments of solitary reflection and social interactions. You have the ability to adapt to different situations, being introspective when you need to process information and sociable when you want to share ideas.',
          subtitle: 'The perfect balance between introspection and sociability 🧠💬',
        ),
        // Index 4
        const AdviceMostAskedScreen(
          question: 'What advice have you asked ChatGPT for the most?',
          mostAskedAdvice: 'How to improve my personal relationships',
          adviceCategory: 'RELATIONSHIPS',
          adviceEmoji: '💕',
          explanation: 'According to the analysis of your conversations, you have sought advice about personal relationships more than any other topic. This shows that you value human connections and always seek to improve the way you relate to others. Your curiosity to better understand social dynamics is admirable.',
          subtitle: 'Wisdom is knowing what to ask 💡',
        ),
        // Index 5 - Movie Title
        const MovieTitleScreen(
          movieTitle: 'The Pursuit of Happyness',
          releaseYear: 2006,
          explanation: 'Based on your conversations, GPT detected a relentless drive for self-improvement and asking deep questions about life. Like Chris Gardner in the movie, you are constantly searching for answers, optimizing your life, and never giving up on personal growth. Your chats are basically a journey of someone trying to figure it all out - one prompt at a time. Inspiring, honestly.',
        ),
        // Index 6 - Love Language
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
        // Index 7 - Past Life Persona
        const PastLifePersonaScreen(
          question: 'Who were you in a past life according to ChatGPT?',
          personaTitle: 'Renaissance Philosopher-Artist',
          personaEmoji: '🎨',
          era: '15TH CENTURY FLORENCE',
          description: 'You were a Renaissance thinker who questioned everything and created beauty from chaos. Your conversations reveal a mind that blends logic with creativity, always seeking deeper meaning. Like Da Vinci, you jump between disciplines—art, science, philosophy—never satisfied with surface-level answers. You probably had a dramatic scarf and too many unfinished projects.',
          subtitle: 'History echoes in who we are today ✨',
        ),
        // Index 8 - MBTI Personality (Last screen)
        const MBTIPersonalityScreen(
          question: 'What is your MBTI personality type according to ChatGPT?',
          mbtiType: 'ENFP',
          mbtiEmoji: '🎭',
          personalityName: 'The Enthusiast',
          explanation: 'According to the analysis of your conversations, ChatGPT detected that you are an ENFP (Extroverted, Intuitive, Feeling, Perceiving). You are an enthusiastic, creative and sociable person who is motivated by possibilities. You have a great ability to connect with others and always seek new experiences and challenges. Your positive energy and your ability to inspire others are your greatest strengths.',
          subtitle: 'Your personality is unique, like a work of art 🎨',
        ),
      ],
      startIndex: 0,
    );
  }
}
