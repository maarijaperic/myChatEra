import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class MovieTitleScreen extends StatelessWidget {
  final String movieTitle;
  final String explanation;
  final int releaseYear;
  final String? question;
  final String? subtitle;

  /// IMDb-style rating of the user's life (0–10).
  final double rating;
  final List<String> genres;

  /// Drama / Plot twists / Comedy / Romance scores (0–100).
  final Map<String, int> scores;

  const MovieTitleScreen({
    super.key,
    required this.movieTitle,
    required this.explanation,
    required this.releaseYear,
    this.question,
    this.subtitle,
    this.rating = 0,
    this.genres = const [],
    this.scores = const {},
  });

  static const _gold = Color(0xFFF5B83D);

  static const _scoreStyle = {
    'Drama': ('🎭', WrappedColors.purple),
    'Plot twists': ('🌀', WrappedColors.blue),
    'Comedy': ('😂', WrappedColors.peach),
    'Romance': ('💘', WrappedColors.pink),
  };

  double get _rating =>
      rating >= 1 ? rating : seededValue(movieTitle, 3, 78, 93) / 10;

  List<String> get _genres =>
      genres.isNotEmpty ? genres.take(2).toList() : const ['Drama', 'Coming of age'];

  int _score(String key, int salt) {
    for (final entry in scores.entries) {
      if (entry.key.toLowerCase() == key.toLowerCase()) return entry.value;
    }
    return seededValue(movieTitle, salt, 35, 88);
  }

  @override
  Widget build(BuildContext context) {
    final ratingValue = _rating;

    return WrappedPage(
      eyebrow: 'Your life movie',
      headline: 'Your life is a *movie*',
      subtitle: subtitle,
      accent: WrappedColors.blue,
      shareText: 'My life movie according to AI: "$movieTitle" 🎬 #mychateraAI',
      children: [
        SectionCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Poster(title: movieTitle),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movieTitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: WrappedColors.ink,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      releaseYear > 0 ? '$releaseYear · Starring you' : 'Starring you',
                      style: GoogleFonts.inter(
                        color: WrappedColors.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final genre in _genres)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE3E0EA)),
                            ),
                            child: Text(
                              genre,
                              style: GoogleFonts.inter(
                                color: WrappedColors.ink.withOpacity(0.75),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const PopIn(
                          child: Icon(CupertinoIcons.star_fill, color: _gold, size: 26),
                        ),
                        const SizedBox(width: 6),
                        CountUpText(
                          ratingValue.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            color: WrappedColors.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          '/10',
                          style: GoogleFonts.inter(
                            color: WrappedColors.muted,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your life rating',
                      style: GoogleFonts.inter(
                        color: WrappedColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SectionCard(
          title: 'Ratings breakdown',
          trailing: 'Your story',
          trailingColor: WrappedColors.blue,
          child: MeterList(
            items: [
              for (final (i, key) in _scoreStyle.keys.indexed)
                MeterItem(
                  key,
                  _score(key, i + 4),
                  _scoreStyle[key]!.$2,
                  emoji: _scoreStyle[key]!.$1,
                ),
            ],
          ),
        ),
        _CriticReview(text: explanation, rating: ratingValue),
      ],
    );
  }
}

class _Poster extends StatelessWidget {
  final String title;

  const _Poster({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9FD8F7), Color(0xFFA9A6F5), Color(0xFFF4A3C4)],
        ),
        boxShadow: [
          BoxShadow(
            color: WrappedColors.blue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MY CHAT ERA\nPICTURES',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.85),
              fontSize: 7.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              height: 1.2,
            ),
          ),
          const Spacer(),
          const Center(child: Text('🎬', style: TextStyle(fontSize: 34))),
          const Spacer(),
          Text(
            title.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CriticReview extends StatelessWidget {
  final String text;
  final double rating;

  const _CriticReview({required this.text, required this.rating});

  @override
  Widget build(BuildContext context) {
    final stars = rating / 2;
    return SectionCard(
      title: 'AI critic review',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 0; i < 5; i++)
                PopIn(
                  delay: Duration(milliseconds: 100 * i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Icon(
                      stars >= i + 0.75
                          ? CupertinoIcons.star_fill
                          : stars >= i + 0.25
                              ? CupertinoIcons.star_lefthalf_fill
                              : CupertinoIcons.star,
                      color: MovieTitleScreen._gold,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '“$text”',
            style: GoogleFonts.inter(
              color: WrappedColors.ink.withOpacity(0.78),
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
