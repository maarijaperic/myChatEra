import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class GuessZodiacScreen extends StatelessWidget {
  final String question;
  final String zodiacSign;
  final String zodiacEmoji;
  final String zodiacName;
  final String explanation;
  final String subtitle;

  const GuessZodiacScreen({
    super.key,
    required this.question,
    required this.zodiacSign,
    required this.zodiacEmoji,
    required this.zodiacName,
    required this.explanation,
    required this.subtitle,
  });

  static const _elements = {
    'aries': 'Fire', 'leo': 'Fire', 'sagittarius': 'Fire',
    'taurus': 'Earth', 'virgo': 'Earth', 'capricorn': 'Earth',
    'gemini': 'Air', 'libra': 'Air', 'aquarius': 'Air',
    'cancer': 'Water', 'scorpio': 'Water', 'pisces': 'Water',
  };

  @override
  Widget build(BuildContext context) {
    final symbol = zodiacSign.replaceAll(RegExp(r'[A-Za-z\s]'), '');
    final element = _elements[zodiacName.toLowerCase().trim()];

    return WrappedPage(
      eyebrow: 'Zodiac sign',
      headline: 'You\'re giving *$zodiacName*',
      subtitle: subtitle,
      accent: WrappedColors.purple,
      shareText: 'AI says my zodiac sign is $zodiacName $zodiacEmoji #mychateraAI',
      children: [
        GlowOrb(emoji: zodiacEmoji, color: WrappedColors.purple),
        if (symbol.isNotEmpty || element != null)
          Row(
            children: [
              if (symbol.isNotEmpty)
                Expanded(
                  child: LetterTile(letter: symbol, meaning: 'Sign', color: WrappedColors.purple),
                ),
              if (symbol.isNotEmpty && element != null) const SizedBox(width: 8),
              if (element != null)
                Expanded(
                  child: LetterTile(
                    letter: const {'Fire': '🔥', 'Earth': '🌿', 'Air': '🌬️', 'Water': '🌊'}[element]!,
                    meaning: '$element sign',
                    color: WrappedColors.blue,
                  ),
                ),
            ],
          ),
        InsightText(explanation),
      ],
    );
  }
}
