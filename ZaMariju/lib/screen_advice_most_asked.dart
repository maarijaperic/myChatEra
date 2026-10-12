import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class AdviceMostAskedScreen extends StatelessWidget {
  final String question;
  final String mostAskedAdvice;
  final String adviceCategory;
  final String adviceEmoji;
  final String explanation;
  final String subtitle;

  const AdviceMostAskedScreen({
    super.key,
    required this.question,
    required this.mostAskedAdvice,
    required this.adviceCategory,
    required this.adviceEmoji,
    required this.explanation,
    required this.subtitle,
  });

  String get _category {
    final lower = adviceCategory.toLowerCase();
    if (lower.isEmpty) return adviceCategory;
    return lower[0].toUpperCase() + lower.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'Most asked advice',
      headline: 'You ask AI about *$_category*',
      subtitle: subtitle,
      accent: WrappedColors.green,
      shareText: 'The advice I ask AI for the most: $_category $adviceEmoji #mychateraAI',
      children: [
        GlowOrb(emoji: adviceEmoji, color: WrappedColors.green),
        FeatureCard(
          emoji: '💬',
          kicker: 'Your top question',
          title: mostAskedAdvice,
          color: WrappedColors.green,
        ),
        InsightText(explanation),
      ],
    );
  }
}
