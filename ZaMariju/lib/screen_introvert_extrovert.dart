import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class IntrovertExtrovertScreen extends StatelessWidget {
  final String question;
  final String personalityType;
  final int introvertPercentage;
  final int extrovertPercentage;
  final String explanation;
  final String subtitle;

  const IntrovertExtrovertScreen({
    super.key,
    required this.question,
    required this.personalityType,
    required this.introvertPercentage,
    required this.extrovertPercentage,
    required this.explanation,
    required this.subtitle,
  });

  String get _label {
    final lower = personalityType.toLowerCase();
    if (lower.isEmpty) return personalityType;
    return lower[0].toUpperCase() + lower.substring(1);
  }

  String get _emoji {
    final upper = personalityType.toUpperCase();
    if (upper.contains('INTRO')) return '🌙';
    if (upper.contains('EXTRO')) return '☀️';
    return '🌗';
  }

  String get _article => RegExp(r'^[AEIOU]').hasMatch(_label.toUpperCase()) ? 'an' : 'a';

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'Social energy',
      headline: 'You\'re $_article *$_label*',
      subtitle: subtitle,
      accent: WrappedColors.purple,
      shareText: 'I\'m $_article $_label according to AI! $_emoji #mychateraAI',
      children: [
        GlowOrb(emoji: _emoji, color: WrappedColors.purple),
        SectionCard(
          title: 'Your energy balance',
          child: SplitMeter(
            leftLabel: 'Introvert',
            leftValue: introvertPercentage,
            leftColor: WrappedColors.purple,
            rightLabel: 'Extrovert',
            rightValue: extrovertPercentage,
            rightColor: WrappedColors.pink,
          ),
        ),
        InsightText(explanation),
      ],
    );
  }
}
