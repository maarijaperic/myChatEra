import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class GuessZodiacScreen extends StatelessWidget {
  final String question;
  final String zodiacSign;
  final String zodiacEmoji;
  final String zodiacName;
  final String explanation;
  final String subtitle;

  /// Element percentages, e.g. {'Water': 45, 'Fire': 22, 'Air': 18, 'Earth': 15}.
  final Map<String, int> elements;

  const GuessZodiacScreen({
    super.key,
    required this.question,
    required this.zodiacSign,
    required this.zodiacEmoji,
    required this.zodiacName,
    required this.explanation,
    required this.subtitle,
    this.elements = const {},
  });

  static const _signElements = {
    'aries': 'Fire', 'leo': 'Fire', 'sagittarius': 'Fire',
    'taurus': 'Earth', 'virgo': 'Earth', 'capricorn': 'Earth',
    'gemini': 'Air', 'libra': 'Air', 'aquarius': 'Air',
    'cancer': 'Water', 'scorpio': 'Water', 'pisces': 'Water',
  };

  static const _elementStyle = {
    'Fire': ('🔥', WrappedColors.peach),
    'Water': ('🌊', WrappedColors.blue),
    'Earth': ('🌿', WrappedColors.green),
    'Air': ('🌬️', WrappedColors.purple),
  };

  Map<String, int> get _elementMix {
    final normalized = <String, int>{};
    elements.forEach((key, value) {
      final match = _elementStyle.keys.where(
        (e) => e.toLowerCase() == key.toLowerCase().trim(),
      );
      if (match.isNotEmpty) normalized[match.first] = value;
    });
    if (normalized.length == 4 && normalized.values.any((v) => v > 0)) {
      return normalized;
    }

    final main = _signElements[zodiacName.toLowerCase().trim()] ?? 'Air';
    final others = _elementStyle.keys.where((e) => e != main).toList();
    final a = seededValue(zodiacName, 1, 16, 24);
    final b = seededValue(zodiacName, 2, 12, 20);
    return {main: 100 - a - b - 12, others[0]: a, others[1]: b, others[2]: 12};
  }

  @override
  Widget build(BuildContext context) {
    final symbol = zodiacSign.replaceAll(RegExp(r'[A-Za-z\s]'), '');
    final mix = _elementMix.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = mix.first;
    final topStyle = _elementStyle[top.key]!;
    final segments = [
      for (final e in mix)
        ChartSegment(e.key, e.value, _elementStyle[e.key]!.$2, emoji: _elementStyle[e.key]!.$1),
    ];

    return WrappedPage(
      eyebrow: 'Zodiac sign',
      headline: 'You\'re giving *$zodiacName*',
      subtitle: subtitle,
      accent: WrappedColors.purple,
      shareText: 'AI says my zodiac sign is $zodiacName $zodiacEmoji #mychateraAI',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlowOrb(emoji: zodiacEmoji, color: WrappedColors.purple, size: 140),
            if (symbol.isNotEmpty)
              PopIn(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(
                        symbol,
                        style: GoogleFonts.inter(
                          color: WrappedColors.purple,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${top.key} sign',
                        style: GoogleFonts.inter(
                          color: WrappedColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SectionCard(
          title: 'Your elements',
          trailing: 'Mostly ${top.key}',
          trailingColor: Color.lerp(topStyle.$2, WrappedColors.ink, 0.15)!,
          child: Row(
            children: [
              DonutChart(
                segments: segments,
                size: 128,
                stroke: 16,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(topStyle.$1, style: const TextStyle(fontSize: 22)),
                    CountUpText(
                      '${top.value}%',
                      style: GoogleFonts.inter(
                        color: WrappedColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: ChartLegend(segments: segments)),
            ],
          ),
        ),
        InsightText(explanation, accent: WrappedColors.purple),
      ],
    );
  }
}
