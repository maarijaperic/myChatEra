import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class AdviceMostAskedScreen extends StatelessWidget {
  final String question;
  final String mostAskedAdvice;
  final String adviceCategory;
  final String adviceEmoji;
  final String explanation;
  final String subtitle;

  /// Funny line about why the user keeps asking this.
  final String roast;

  /// Advice topic shares, e.g. {'Relationships': 42, 'Career': 26}.
  final Map<String, int> topics;

  const AdviceMostAskedScreen({
    super.key,
    required this.question,
    required this.mostAskedAdvice,
    required this.adviceCategory,
    required this.adviceEmoji,
    required this.explanation,
    required this.subtitle,
    this.roast = '',
    this.topics = const {},
  });

  static const _topicColors = [
    WrappedColors.green,
    WrappedColors.blue,
    WrappedColors.purple,
    WrappedColors.peach,
  ];

  String get _category {
    final lower = adviceCategory.toLowerCase();
    if (lower.isEmpty) return adviceCategory;
    return lower[0].toUpperCase() + lower.substring(1);
  }

  String get _roast => roast.isNotEmpty
      ? roast
      : 'You ask about ${_category.toLowerCase()} so often that ChatGPT should be charging you by the hour. 💀';

  List<MapEntry<String, int>> get _topics {
    if (topics.isNotEmpty) {
      return (topics.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
          .take(4)
          .toList();
    }
    final others = ['Career', 'Self-growth', 'Health', 'Relationships', 'Tech']
        .where((t) => t.toLowerCase() != _category.toLowerCase())
        .take(3)
        .toList();
    final a = seededValue(mostAskedAdvice, 1, 22, 28);
    final b = seededValue(mostAskedAdvice, 2, 14, 20);
    return [
      MapEntry(_category, 100 - a - b - 11),
      MapEntry(others[0], a),
      MapEntry(others[1], b),
      MapEntry(others[2], 11),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final topicList = _topics;

    return WrappedPage(
      eyebrow: 'Most asked advice',
      headline: 'You ask AI about *$_category*',
      subtitle: subtitle,
      accent: WrappedColors.green,
      shareText: 'The advice I ask AI for the most: $_category $adviceEmoji #mychateraAI',
      children: [
        FeatureCard(
          emoji: adviceEmoji,
          kicker: 'Your top question',
          title: mostAskedAdvice,
          color: WrappedColors.green,
        ),
        _RoastBubble(text: _roast),
        SectionCard(
          title: 'What you ask about',
          child: MeterList(
            items: [
              for (var i = 0; i < topicList.length; i++)
                MeterItem(topicList[i].key, topicList[i].value, _topicColors[i % _topicColors.length]),
            ],
          ),
        ),
        InsightText(explanation, accent: WrappedColors.green),
      ],
    );
  }
}

/// Playful roast in a soft green card; the text uses the page's pastel
/// background tone.
class _RoastBubble extends StatelessWidget {
  final String text;

  const _RoastBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6FD8A6), Color(0xFF4FC08D)],
        ),
        boxShadow: [
          BoxShadow(
            color: WrappedColors.green.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHY YOU REALLY ASK 💀',
            style: GoogleFonts.inter(
              color: const Color(0xFFEAF9FF).withOpacity(0.85),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFFFFF5FB),
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
