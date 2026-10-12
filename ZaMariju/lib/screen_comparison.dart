import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class ComparisonStatsScreen extends StatelessWidget {
  final String question;
  final String firstName;
  final int firstValue;
  final String firstEmoji;
  final String secondName;
  final int secondValue;
  final String secondEmoji;
  final String poeticMessage;
  final List<Map<String, dynamic>>? monthlyTopics; // Personalizovane mesečne teme

  const ComparisonStatsScreen({
    super.key,
    required this.question,
    required this.firstName,
    required this.firstValue,
    required this.firstEmoji,
    required this.secondName,
    required this.secondValue,
    required this.secondEmoji,
    required this.poeticMessage,
    this.monthlyTopics,
  });

  static const _fallbackMonths = [
    {'month': 'JULY', 'obsession': 'Summer Vibes', 'sentence': 'Embracing the warmth and energy of the season.', 'emoji': '☀️'},
    {'month': 'AUGUST', 'obsession': 'Learning', 'sentence': 'Expanding your knowledge and skills daily.', 'emoji': '📚'},
    {'month': 'SEPTEMBER', 'obsession': 'New Hobbies', 'sentence': 'Discovering passions and creative outlets.', 'emoji': '🎨'},
    {'month': 'OCTOBER', 'obsession': 'Productivity', 'sentence': 'Maximizing efficiency and achieving goals.', 'emoji': '⚡'},
    {'month': 'NOVEMBER', 'obsession': 'Gratitude', 'sentence': 'Appreciating life\'s blessings and moments.', 'emoji': '🙏'},
    {'month': 'DECEMBER', 'obsession': 'Reflection', 'sentence': 'Looking back and preparing for what\'s ahead.', 'emoji': '✨'},
  ];

  @override
  Widget build(BuildContext context) {
    final months = (monthlyTopics != null && monthlyTopics!.length >= 6)
        ? monthlyTopics!.take(6).toList()
        : _fallbackMonths;

    return WrappedPage(
      eyebrow: 'Monthly obsessions · Part 2',
      headline: 'The *second half* of your year',
      subtitle: 'From summer to December',
      accent: WrappedColors.blue,
      shareText: 'My monthly obsessions pt 2 according to AI ✨ #mychateraAI',
      children: [
        MonthGrid(months: months),
      ],
    );
  }
}
