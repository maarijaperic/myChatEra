import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class TypeABPersonalityScreen extends StatelessWidget {
  final String question;
  final String personalityType;
  final String typeEmoji;
  final int typeAPercentage;
  final int typeBPercentage;
  final String explanation;
  final String subtitle;

  const TypeABPersonalityScreen({
    super.key,
    required this.question,
    required this.personalityType,
    required this.typeEmoji,
    required this.typeAPercentage,
    required this.typeBPercentage,
    required this.explanation,
    required this.subtitle,
  });

  String get _typeLabel {
    final upper = personalityType.toUpperCase();
    if (upper.contains('A') && !upper.contains('B')) return 'Type A';
    if (upper.contains('B') && !upper.contains('A')) return 'Type B';
    return personalityType;
  }

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'Personality style',
      headline: 'You\'re *$_typeLabel*',
      subtitle: subtitle,
      accent: WrappedColors.peach,
      shareText: 'I\'m $_typeLabel according to AI! $typeEmoji #mychateraAI',
      children: [
        GlowOrb(emoji: typeEmoji, color: WrappedColors.peach, size: 120),
        StatBubbles(
          stats: [
            BubbleStat('Type A', '$typeAPercentage%', WrappedColors.peach),
            BubbleStat('Type B', '$typeBPercentage%', WrappedColors.blue),
          ],
        ),
        InsightText(explanation),
      ],
    );
  }
}
