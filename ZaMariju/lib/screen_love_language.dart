import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class LoveLanguageScreen extends StatelessWidget {
  final String question;
  final String loveLanguage;
  final String languageEmoji;
  final String explanation;
  final String subtitle;
  final Map<String, int> loveLanguagePercentages; // e.g., {'Words': 35, 'Acts': 25, 'Gifts': 20, 'Time': 20}

  const LoveLanguageScreen({
    super.key,
    required this.question,
    required this.loveLanguage,
    required this.languageEmoji,
    required this.explanation,
    required this.subtitle,
    required this.loveLanguagePercentages,
  });

  static const _barColors = [
    WrappedColors.pink,
    WrappedColors.purple,
    WrappedColors.blue,
    WrappedColors.green,
    WrappedColors.peach,
  ];

  @override
  Widget build(BuildContext context) {
    final entries = loveLanguagePercentages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return WrappedPage(
      eyebrow: 'Love language',
      headline: 'You speak *$loveLanguage*',
      subtitle: subtitle,
      accent: WrappedColors.pinkDeep,
      shareText: 'My love language according to AI: $loveLanguage $languageEmoji #mychateraAI',
      children: [
        GlowOrb(emoji: languageEmoji, color: WrappedColors.pink, size: 140),
        if (entries.isNotEmpty)
          SectionCard(
            title: 'Your love mix',
            child: RankedBars(
              items: [
                for (var i = 0; i < entries.length; i++)
                  BarItem(entries[i].key, entries[i].value, _barColors[i % _barColors.length]),
              ],
            ),
          ),
        InsightText(explanation),
      ],
    );
  }
}
