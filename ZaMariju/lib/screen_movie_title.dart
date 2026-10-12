import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class MovieTitleScreen extends StatelessWidget {
  final String movieTitle;
  final String explanation;
  final int releaseYear;
  final String? question;
  final String? subtitle;

  const MovieTitleScreen({
    super.key,
    required this.movieTitle,
    required this.explanation,
    required this.releaseYear,
    this.question,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'Your life movie',
      headline: 'Your life is a *movie*',
      subtitle: subtitle,
      accent: WrappedColors.blue,
      shareText: 'My life movie according to AI: "$movieTitle" 🎬 #mychateraAI',
      children: [
        const GlowOrb(emoji: '🍿', color: WrappedColors.blue, size: 140),
        FeatureCard(
          emoji: '🎬',
          kicker: 'Starring you',
          title: movieTitle,
          meta: releaseYear > 0 ? '$releaseYear' : null,
          color: WrappedColors.blue,
        ),
        InsightText(explanation, title: 'Why this movie'),
      ],
    );
  }
}
