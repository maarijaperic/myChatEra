import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class SongTitleScreen extends StatelessWidget {
  final String songTitle;
  final String artist;
  final String explanation;
  final int releaseYear;
  final String? question;
  final String? subtitle;

  /// Energy / Mood / Danceability scores (0–100).
  final Map<String, int> vibe;
  final int durationSeconds;

  const SongTitleScreen({
    super.key,
    required this.songTitle,
    required this.artist,
    required this.explanation,
    required this.releaseYear,
    this.question,
    this.subtitle,
    this.vibe = const {},
    this.durationSeconds = 0,
  });

  static const _vibeStyle = {
    'Energy': ('⚡', WrappedColors.peach),
    'Mood': ('☀️', WrappedColors.pink),
    'Danceability': ('🪩', WrappedColors.purple),
  };

  int _vibeValue(String key, int salt) {
    for (final entry in vibe.entries) {
      if (entry.key.toLowerCase() == key.toLowerCase()) return entry.value;
    }
    return seededValue(songTitle, salt, 55, 90);
  }

  @override
  Widget build(BuildContext context) {
    final duration = durationSeconds >= 90 && durationSeconds <= 900
        ? durationSeconds
        : seededValue(songTitle, 9, 185, 275);

    return WrappedPage(
      eyebrow: 'Your life soundtrack',
      headline: 'Your life is a *song*',
      subtitle: subtitle,
      accent: WrappedColors.pinkDeep,
      shareText: 'My life song according to AI: "$songTitle" by $artist 🎵 #mychateraAI',
      children: [
        _NowPlayingCard(
          title: songTitle,
          artist: artist,
          year: releaseYear,
          durationSeconds: duration,
        ),
        SectionCard(
          title: 'Your vibe check',
          trailing: 'Audio DNA',
          child: MeterList(
            items: [
              for (final (i, key) in _vibeStyle.keys.indexed)
                MeterItem(
                  key,
                  _vibeValue(key, i + 1),
                  _vibeStyle[key]!.$2,
                  emoji: _vibeStyle[key]!.$1,
                ),
            ],
          ),
        ),
        _LyricsCard(text: explanation),
      ],
    );
  }
}

/// Music-player card: cover art, title, a live progress bar and controls.
class _NowPlayingCard extends StatefulWidget {
  final String title;
  final String artist;
  final int year;
  final int durationSeconds;

  const _NowPlayingCard({
    required this.title,
    required this.artist,
    required this.year,
    required this.durationSeconds,
  });

  @override
  State<_NowPlayingCard> createState() => _NowPlayingCardState();
}

class _NowPlayingCardState extends State<_NowPlayingCard>
    with SingleTickerProviderStateMixin {
  static const _intro = 0.22;
  late final AnimationController _progress = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () async {
      if (!mounted) return;
      await _progress.animateTo(
        _intro,
        duration: const Duration(milliseconds: 1300),
        curve: Curves.easeOutCubic,
      );
      if (!mounted) return;
      final remaining = (widget.durationSeconds * (1 - _intro)).round();
      _progress.animateTo(1, duration: Duration(seconds: remaining), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  String _time(double seconds) {
    final s = seconds.round();
    return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: WrappedColors.pink.withOpacity(0.18),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CoverArt(title: widget.title, artist: widget.artist),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: WrappedColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.year > 0 ? '${widget.artist} · ${widget.year}' : widget.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: WrappedColors.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopIn(
                delay: Duration(milliseconds: 900),
                child: Icon(CupertinoIcons.heart_fill, color: WrappedColors.pinkDeep, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              final value = _progress.value;
              final elapsed = widget.durationSeconds * value;
              return Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return SizedBox(
                        height: 14,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: WrappedColors.pink.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            Container(
                              width: width * value,
                              height: 5,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [WrappedColors.pink, WrappedColors.pinkDeep],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            Positioned(
                              left: (width - 14) * value,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: WrappedColors.pinkDeep, width: 3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_time(elapsed), style: _timeStyle),
                      Text('-${_time(widget.durationSeconds - elapsed)}', style: _timeStyle),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(CupertinoIcons.shuffle, color: WrappedColors.pinkDeep, size: 20),
              const Icon(CupertinoIcons.backward_fill, color: WrappedColors.ink, size: 26),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [WrappedColors.pink, WrappedColors.pinkDeep],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: WrappedColors.pinkDeep.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(CupertinoIcons.pause_fill, color: Colors.white, size: 26),
              ),
              const Icon(CupertinoIcons.forward_fill, color: WrappedColors.ink, size: 26),
              Icon(CupertinoIcons.repeat, color: WrappedColors.ink.withOpacity(0.4), size: 20),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle get _timeStyle => GoogleFonts.inter(
        color: WrappedColors.muted,
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}

/// Pastel gradient "album cover" with the title set in big type and an
/// animated equalizer.
class _CoverArt extends StatelessWidget {
  final String title;
  final String artist;

  const _CoverArt({required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.45,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFB3CB), Color(0xFFC8B8FF), Color(0xFF9FD8F7)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY CHAT ERA · SOUNDTRACK',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                const _Equalizer(),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Equalizer extends StatefulWidget {
  const _Equalizer();

  @override
  State<_Equalizer> createState() => _EqualizerState();
}

class _EqualizerState extends State<_Equalizer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const phases = [0.0, 0.6, 0.25, 0.85, 0.4, 0.1, 0.7];
    return SizedBox(
      height: 22,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final phase in phases) ...[
              Container(
                width: 4,
                height: 5 + 17 * (((_controller.value + phase) % 1.0 - 0.5).abs() * 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 3),
            ],
          ],
        ),
      ),
    );
  }
}

/// Explanation styled like a lyrics card: big bold text on a soft gradient.
class _LyricsCard extends StatelessWidget {
  final String text;

  const _LyricsCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7A1C0), Color(0xFFE5709A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHY IT\'S YOUR SONG',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 17,
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
