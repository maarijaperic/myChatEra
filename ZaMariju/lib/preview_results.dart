// Design preview of the results screens with demo data (no import/purchase).
// Run with: flutter run -t lib/preview_results.dart
import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/card_navigator.dart';
import 'package:gpt_wrapped2/screen_advice_most_asked.dart';
import 'package:gpt_wrapped2/screen_comparison.dart';
import 'package:gpt_wrapped2/screen_free_summary.dart';
import 'package:gpt_wrapped2/screen_guess_zodiac.dart';
import 'package:gpt_wrapped2/screen_introvert_extrovert.dart';
import 'package:gpt_wrapped2/screen_love_language.dart';
import 'package:gpt_wrapped2/screen_mbti_personality.dart';
import 'package:gpt_wrapped2/screen_movie_title.dart';
import 'package:gpt_wrapped2/screen_past_life_persona.dart';
import 'package:gpt_wrapped2/screen_red_green_flags.dart';
import 'package:gpt_wrapped2/screen_roast_me.dart';
import 'package:gpt_wrapped2/screen_social_sharing.dart';
import 'package:gpt_wrapped2/screen_song_title.dart';
import 'package:gpt_wrapped2/screen_type_ab_personality.dart';
import 'package:gpt_wrapped2/screen_type_ab_preview.dart';
import 'package:gpt_wrapped2/screen_wrapped.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';

void main() {
  final insights = PremiumProcessor.createDemoInsights();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CardNavigator(
        screens: [
          const FreeSummaryScreen(
            totalMessages: 3412,
            totalConversations: 186,
            totalHours: 127,
            totalMinutes: 42,
            messagesPerDay: 47,
            longestStreak: 14,
            activeDays: 102,
            yearPercentage: 28,
            peakTime: 'night',
            peakHour: 23,
          ),
          TypeABPreviewScreen(onSubscribe: () {}),
          MBTIPersonalityScreen(
            question: '',
            mbtiType: insights.mbtiType,
            mbtiEmoji: insights.mbtiEmoji,
            personalityName: insights.personalityName,
            explanation: insights.mbtiExplanation,
            subtitle: '',
            dimensions: insights.mbtiDimensions,
          ),
          TypeABPersonalityScreen(
            question: '',
            personalityType: insights.personalityType,
            typeEmoji: '⚡',
            typeAPercentage: insights.typeAPercentage,
            typeBPercentage: insights.typeBPercentage,
            explanation: insights.typeExplanation,
            subtitle: 'You sprint through life with unstoppable energy ⚡',
          ),
          RedGreenFlagsScreen(
            question: '',
            greenFlagTitle: 'Green Flags',
            redFlagTitle: 'Red Flags',
            greenFlags: insights.greenFlags,
            redFlags: insights.redFlags,
            subtitle: 'Self-love also includes recognizing our areas for improvement',
          ),
          GuessZodiacScreen(
            question: '',
            zodiacSign: insights.zodiacSign,
            zodiacEmoji: insights.zodiacEmoji,
            zodiacName: insights.zodiacName,
            explanation: insights.zodiacExplanation,
            subtitle: 'The stars don\'t lie... and neither does AI! ⭐',
            elements: insights.zodiacElements,
          ),
          SongTitleScreen(
            songTitle: insights.songTitle,
            artist: insights.songArtist,
            releaseYear: insights.songYear,
            explanation: insights.songExplanation,
            subtitle: 'Your life has a soundtrack 🎵✨',
            vibe: insights.songVibe,
            durationSeconds: insights.songDurationSeconds,
          ),
          IntrovertExtrovertScreen(
            question: '',
            personalityType: insights.introExtroType,
            introvertPercentage: insights.introvertPercentage,
            extrovertPercentage: insights.extrovertPercentage,
            explanation: insights.introExtroExplanation,
            subtitle: 'The best of both worlds 🌗',
            traits: insights.introExtroTraits,
          ),
          AdviceMostAskedScreen(
            question: '',
            mostAskedAdvice: insights.mostAskedAdvice,
            adviceCategory: insights.adviceCategory,
            adviceEmoji: insights.adviceEmoji,
            explanation: insights.adviceExplanation,
            subtitle: 'Wisdom is knowing what to ask 💡',
            roast: insights.adviceRoast,
            topics: insights.adviceTopics,
          ),
          MovieTitleScreen(
            movieTitle: insights.movieTitle,
            releaseYear: insights.movieYear,
            explanation: insights.movieExplanation,
            subtitle: 'Plot twist: Your chats are cinema-worthy 🍿✨',
            rating: insights.movieRating,
            genres: insights.movieGenres,
            scores: insights.movieScores,
          ),
          RoastMeScreen(
            question: '',
            roastText: insights.roastText,
            subtitle: 'Can you handle the heat? 🔥😂',
            heat: insights.roastHeat,
            meters: insights.roastMeters,
          ),
          LoveLanguageScreen(
            question: '',
            loveLanguage: insights.loveLanguage,
            languageEmoji: insights.languageEmoji,
            explanation: insights.loveLanguageExplanation,
            subtitle: 'Love is spoken in many languages 💕',
            loveLanguagePercentages: insights.loveLanguagePercentages,
          ),
          PastLifePersonaScreen(
            question: '',
            personaTitle: insights.personaTitle,
            personaEmoji: insights.personaEmoji,
            era: insights.era,
            description: insights.personaDescription,
            subtitle: 'History echoes in who we are today ✨',
          ),
          const WrappedStatsScreen(
            question: '',
            statNumber: 2025,
            unit: 'YEAR',
            poeticMessage: '',
          ),
          const ComparisonStatsScreen(
            question: '',
            firstName: 'You',
            firstValue: 127,
            firstEmoji: '👤',
            secondName: 'AI',
            secondValue: 89,
            secondEmoji: '🤖',
            poeticMessage: '',
          ),
          SocialSharingScreen(premiumInsights: insights),
        ],
        startIndex: 2,
      ),
    ),
  );
}
