import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class MBTIPersonalityScreen extends StatelessWidget {
  final String question;
  final String mbtiType;
  final String mbtiEmoji;
  final String personalityName;
  final String explanation;
  final String subtitle;

  const MBTIPersonalityScreen({
    super.key,
    required this.question,
    required this.mbtiType,
    required this.mbtiEmoji,
    required this.personalityName,
    required this.explanation,
    required this.subtitle,
  });

  static const _meanings = {
    'E': 'Extroverted',
    'I': 'Introverted',
    'N': 'Intuitive',
    'S': 'Sensing',
    'F': 'Feeling',
    'T': 'Thinking',
    'P': 'Perceiving',
    'J': 'Judging',
  };

  static const _letterColors = [
    WrappedColors.pink,
    WrappedColors.purple,
    WrappedColors.blue,
    WrappedColors.peach,
  ];

  @override
  Widget build(BuildContext context) {
    final letters = mbtiType.toUpperCase().split('').where(_meanings.containsKey).toList();

    return WrappedPage(
      eyebrow: 'MBTI personality',
      headline: 'You\'re an *$mbtiType*',
      subtitle: personalityName,
      accent: WrappedColors.pinkDeep,
      shareText: 'My MBTI personality type: $mbtiType - $personalityName! $mbtiEmoji #mychateraAI',
      children: [
        GlowOrb(emoji: mbtiEmoji, color: WrappedColors.pink),
        if (letters.length == 4)
          Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: LetterTile(
                    letter: letters[i],
                    meaning: _meanings[letters[i]]!,
                    color: _letterColors[i],
                  ),
                ),
              ],
            ],
          ),
        InsightText(explanation),
      ],
    );
  }
}
