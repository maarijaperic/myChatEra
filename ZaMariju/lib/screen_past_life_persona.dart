import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class PastLifePersonaScreen extends StatelessWidget {
  final String question;
  final String personaTitle;
  final String personaEmoji;
  final String era;
  final String description;
  final String subtitle;

  const PastLifePersonaScreen({
    super.key,
    required this.question,
    required this.personaTitle,
    required this.personaEmoji,
    required this.era,
    required this.description,
    required this.subtitle,
  });

  String get _era {
    final lower = era.toLowerCase();
    return lower
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'Past life',
      headline: 'In a past life you were a *legend*',
      subtitle: subtitle,
      accent: WrappedColors.purple,
      shareText: 'In a past life I was a $personaTitle $personaEmoji according to AI #mychateraAI',
      children: [
        GlowOrb(emoji: personaEmoji, color: WrappedColors.purple, size: 140),
        FeatureCard(
          emoji: '⏳',
          kicker: _era,
          title: personaTitle,
          color: WrappedColors.purple,
        ),
        InsightText(description, title: 'Your story'),
      ],
    );
  }
}
