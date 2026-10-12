import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class IntrovertExtrovertScreen extends StatelessWidget {
  final String question;
  final String personalityType;
  final int introvertPercentage;
  final int extrovertPercentage;
  final String explanation;
  final String subtitle;

  /// Short highlighted traits, e.g. ['Deep Talks', 'Recharges Solo'].
  final List<String> traits;

  const IntrovertExtrovertScreen({
    super.key,
    required this.question,
    required this.personalityType,
    required this.introvertPercentage,
    required this.extrovertPercentage,
    required this.explanation,
    required this.subtitle,
    this.traits = const [],
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

  List<String> get _traits {
    if (traits.isNotEmpty) return traits.take(4).toList();
    final upper = personalityType.toUpperCase();
    if (upper.contains('INTRO')) {
      return const ['Deep Thinker', 'Recharges Solo', 'Small Circle', 'Great Listener'];
    }
    if (upper.contains('EXTRO')) {
      return const ['Social Spark', 'Big Energy', 'Talks It Out', 'Room Lighter'];
    }
    return const ['Best Of Both', 'Adapts Fast', 'Deep Talks', 'Social When Ready'];
  }

  @override
  Widget build(BuildContext context) {
    final total = introvertPercentage + extrovertPercentage;
    final extroShare = total == 0 ? 0.5 : extrovertPercentage / total;

    return WrappedPage(
      eyebrow: 'Social energy',
      headline: 'You\'re $_article *$_label*',
      subtitle: subtitle,
      accent: WrappedColors.purple,
      shareText: 'I\'m $_article $_label according to AI! $_emoji #mychateraAI',
      children: [
        GlowOrb(emoji: _emoji, color: WrappedColors.purple, size: 130),
        SectionCard(
          title: 'Your social battery',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Share(
                      value: introvertPercentage,
                      label: 'Introvert',
                      color: WrappedColors.purple,
                      alignEnd: false,
                    ),
                  ),
                  Expanded(
                    child: _Share(
                      value: extrovertPercentage,
                      label: 'Extrovert',
                      color: WrappedColors.pinkDeep,
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SpectrumBar(
                position: extroShare,
                labels: const ['Introvert', 'Ambivert', 'Extrovert'],
                leftColor: WrappedColors.purple,
                rightColor: WrappedColors.pink,
              ),
            ],
          ),
        ),
        SectionCard(
          title: 'Your energy in 4 words',
          child: TraitChips(
            traits: _traits,
            colors: const [
              WrappedColors.purple,
              WrappedColors.pink,
              WrappedColors.blue,
              WrappedColors.peach,
            ],
          ),
        ),
        InsightText(explanation, accent: WrappedColors.purple),
      ],
    );
  }
}

class _Share extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final bool alignEnd;

  const _Share({
    required this.value,
    required this.label,
    required this.color,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CountUpText(
          '$value%',
          style: GoogleFonts.inter(
            color: color,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: WrappedColors.muted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
