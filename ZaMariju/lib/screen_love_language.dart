import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  static const _styles = {
    'words of affirmation': ('💬', WrappedColors.pink),
    'quality time': ('⏳', WrappedColors.purple),
    'acts of service': ('🤝', WrappedColors.blue),
    'physical touch': ('🫂', WrappedColors.peach),
    'receiving gifts': ('🎁', WrappedColors.green),
    'gifts': ('🎁', WrappedColors.green),
  };

  static const _fallbackColors = [
    WrappedColors.pink,
    WrappedColors.purple,
    WrappedColors.blue,
    WrappedColors.peach,
    WrappedColors.green,
  ];

  @override
  Widget build(BuildContext context) {
    final entries = loveLanguagePercentages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final segments = [
      for (var i = 0; i < entries.length; i++)
        ChartSegment(
          entries[i].key,
          entries[i].value,
          _styles[entries[i].key.toLowerCase()]?.$2 ?? _fallbackColors[i % _fallbackColors.length],
          emoji: _styles[entries[i].key.toLowerCase()]?.$1,
        ),
    ];

    return WrappedPage(
      eyebrow: 'Love language',
      headline: 'Your love language is *$loveLanguage*',
      subtitle: subtitle,
      accent: WrappedColors.pinkDeep,
      shareText: 'My love language according to AI: $loveLanguage $languageEmoji #mychateraAI',
      children: [
        if (segments.isNotEmpty)
          SectionCard(
            title: 'Your love mix',
            trailing: 'All 5 languages',
            child: Column(
              children: [
                DonutChart(
                  segments: segments,
                  size: 176,
                  stroke: 22,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(languageEmoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 2),
                      CountUpText(
                        '${entries.first.value}%',
                        style: GoogleFonts.inter(
                          color: WrappedColors.ink,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ChartLegend(segments: segments),
              ],
            ),
          )
        else
          GlowOrb(emoji: languageEmoji, color: WrappedColors.pink, size: 140),
        InsightText(explanation),
      ],
    );
  }
}
