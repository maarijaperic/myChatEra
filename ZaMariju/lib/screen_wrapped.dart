import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class WrappedStatsScreen extends StatelessWidget {
  final String question;
  final int statNumber;
  final String unit;
  final String poeticMessage;
  final List<Map<String, dynamic>>? monthlyTopics; // Personalizovane mesečne teme

  const WrappedStatsScreen({
    super.key,
    required this.question,
    required this.statNumber,
    required this.unit,
    required this.poeticMessage,
    this.monthlyTopics,
  });

  static const _fallbackMonths = [
    {'month': 'JANUARY', 'obsession': 'Your Ex', 'sentence': 'Processing feelings and finding closure.', 'emoji': '💔'},
    {'month': 'FEBRUARY', 'obsession': 'Baking', 'sentence': 'Discovering the joy of creating delicious treats.', 'emoji': '🧁'},
    {'month': 'MARCH', 'obsession': 'Self-Care', 'sentence': 'Prioritizing your well-being and inner peace.', 'emoji': '🧘'},
    {'month': 'APRIL', 'obsession': 'Career Goals', 'sentence': 'Focusing on growth and professional development.', 'emoji': '💼'},
    {'month': 'MAY', 'obsession': 'Travel Plans', 'sentence': 'Dreaming of new adventures and destinations.', 'emoji': '✈️'},
    {'month': 'JUNE', 'obsession': 'Fitness', 'sentence': 'Building strength and healthy habits.', 'emoji': '💪'},
  ];

  @override
  Widget build(BuildContext context) {
    final months = (monthlyTopics != null && monthlyTopics!.length >= 6)
        ? monthlyTopics!.take(6).toList()
        : _fallbackMonths;

    return WrappedPage(
      eyebrow: 'Monthly obsessions · Part 1',
      headline: 'Your *$statNumber* in review',
      subtitle: 'What you couldn\'t stop asking AI about',
      accent: WrappedColors.pinkDeep,
      shareText: 'My $statNumber monthly obsessions according to AI 🎉 #mychateraAI',
      children: [
        MonthGrid(months: months),
      ],
    );
  }
}
