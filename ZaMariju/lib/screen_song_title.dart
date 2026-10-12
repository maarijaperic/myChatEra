import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class SongTitleScreen extends StatelessWidget {
  final String songTitle;
  final String artist;
  final String explanation;
  final int releaseYear;
  final String? question;
  final String? subtitle;

  const SongTitleScreen({
    super.key,
    required this.songTitle,
    required this.artist,
    required this.explanation,
    required this.releaseYear,
    this.question,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'Your life soundtrack',
      headline: 'Your life is a *song*',
      subtitle: subtitle,
      accent: WrappedColors.pinkDeep,
      shareText: 'My life song according to AI: "$songTitle" by $artist 🎵 #mychateraAI',
      children: [
        const GlowOrb(emoji: '🎧', color: WrappedColors.pink, size: 140),
        FeatureCard(
          emoji: '🎵',
          kicker: 'Now playing',
          title: songTitle,
          meta: releaseYear > 0 ? '$artist · $releaseYear' : artist,
          color: WrappedColors.pink,
        ),
        InsightText(explanation, title: 'Why this song'),
      ],
    );
  }
}
