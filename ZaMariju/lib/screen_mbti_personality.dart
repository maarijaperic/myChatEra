import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class MBTIPersonalityScreen extends StatelessWidget {
  final String question;
  final String mbtiType;
  final String mbtiEmoji;
  final String personalityName;
  final String explanation;
  final String subtitle;

  /// Lean strength per letter of the type, e.g. {'E': 68, 'N': 74}.
  final Map<String, int> dimensions;

  const MBTIPersonalityScreen({
    super.key,
    required this.question,
    required this.mbtiType,
    required this.mbtiEmoji,
    required this.personalityName,
    required this.explanation,
    required this.subtitle,
    this.dimensions = const {},
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

  static const _opposites = {
    'E': 'I', 'I': 'E', 'N': 'S', 'S': 'N',
    'F': 'T', 'T': 'F', 'P': 'J', 'J': 'P',
  };

  static const _letterColors = [
    WrappedColors.pink,
    WrappedColors.purple,
    WrappedColors.blue,
    WrappedColors.peach,
  ];

  int _strength(String letter, int index) {
    final value = dimensions[letter] ?? dimensions[letter.toLowerCase()];
    if (value != null && value >= 50) return value;
    return seededValue(mbtiType, index, 56, 82);
  }

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
        GlowOrb(emoji: mbtiEmoji, color: WrappedColors.pink, size: 140),
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
                    delay: Duration(milliseconds: 110 * i),
                  ),
                ),
              ],
            ],
          ),
        if (letters.length == 4)
          SectionCard(
            title: 'Your personality spectrum',
            child: Column(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  _DimensionRow(
                    label: _meanings[letters[i]]!,
                    opposite: _meanings[_opposites[letters[i]]!]!,
                    value: _strength(letters[i], i),
                    color: _letterColors[i],
                    delay: 150 * i,
                  ),
                ],
              ],
            ),
          ),
        InsightText(explanation),
      ],
    );
  }
}

class _DimensionRow extends StatelessWidget {
  final String label;
  final String opposite;
  final int value;
  final Color color;
  final int delay;

  const _DimensionRow({
    required this.label,
    required this.opposite,
    required this.value,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final strong = Color.lerp(color, WrappedColors.ink, 0.25)!;
    return Column(
      children: [
        Row(
          children: [
            CountUpText(
              '$value%',
              delay: Duration(milliseconds: delay),
              style: GoogleFonts.inter(color: strong, fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: WrappedColors.ink,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '$opposite ${100 - value}%',
              style: GoogleFonts.inter(
                color: WrappedColors.muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        WrappedReveal(
          delay: Duration(milliseconds: delay),
          builder: (context, t) => Container(
            height: 10,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value / 100 * Curves.easeOutCubic.transform(t),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.lerp(color, Colors.white, 0.35)!, color],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
