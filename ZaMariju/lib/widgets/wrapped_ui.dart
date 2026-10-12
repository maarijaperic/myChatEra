import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/utils/share_helper.dart';

/// Shared building blocks for the results screens (free snapshot + premium).
class WrappedColors {
  static const ink = Color(0xFF1C1C1E);
  static const muted = Color(0xFF8E8E93);
  static const pink = Color(0xFFFF8FB1);
  static const pinkDeep = Color(0xFFE5709A);
  static const blue = Color(0xFF6CC4F5);
  static const green = Color(0xFF5FD49B);
  static const purple = Color(0xFF8D9CFF);
  static const peach = Color(0xFFFFA97A);
  static const red = Color(0xFFF26B7A);

  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF5FB),
      Color(0xFFF4F1FF),
      Color(0xFFEFF6FF),
      Color(0xFFEAF9FF),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
}

/// Full results page: pastel background, eyebrow + big headline, staggered
/// content and an optional pinned bottom action (share pill by default).
class WrappedPage extends StatefulWidget {
  final String eyebrow;

  /// Words wrapped in `*asterisks*` are highlighted with [accent].
  final String headline;
  final String? subtitle;
  final Color accent;
  final Color? secondaryAccent;
  final List<Widget> children;

  /// When set (and [bottom] is null) a share pill is pinned at the bottom.
  final String? shareText;
  final Widget? bottom;

  const WrappedPage({
    super.key,
    required this.eyebrow,
    required this.headline,
    required this.accent,
    required this.children,
    this.subtitle,
    this.secondaryAccent,
    this.shareText,
    this.bottom,
  });

  @override
  State<WrappedPage> createState() => _WrappedPageState();
}

class _WrappedPageState extends State<WrappedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final GlobalKey _screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.055).clamp(18.0, 26.0);
    final items = <Widget>[
      _WrappedHeader(
        eyebrow: widget.eyebrow,
        headline: widget.headline,
        subtitle: widget.subtitle,
        accent: widget.accent,
        secondaryAccent: widget.secondaryAccent,
      ),
      ...widget.children,
    ];
    final step = items.length <= 1 ? 0.0 : 0.5 / (items.length - 1);

    final bottom = widget.bottom ??
        (widget.shareText != null
            ? WrappedShareButton(
                screenshotKey: _screenshotKey,
                accent: widget.accent,
              )
            : null);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: WrappedColors.background),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RepaintBoundary(
                  key: _screenshotKey,
                  child: Container(
                    decoration:
                        const BoxDecoration(gradient: WrappedColors.background),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        28,
                        horizontalPadding,
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < items.length; i++) ...[
                            if (i > 0) const SizedBox(height: 16),
                            WrappedFade(
                              controller: _controller,
                              delay: i * step,
                              child: items[i],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (bottom != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    4,
                    horizontalPadding,
                    12,
                  ),
                  child: WrappedFade(
                    controller: _controller,
                    delay: 0.55,
                    child: bottom,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WrappedHeader extends StatelessWidget {
  final String eyebrow;
  final String headline;
  final String? subtitle;
  final Color accent;
  final Color? secondaryAccent;

  const _WrappedHeader({
    required this.eyebrow,
    required this.headline,
    required this.subtitle,
    required this.accent,
    this.secondaryAccent,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
          eyebrow.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: WrappedColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        HighlightText(
          headline,
          accent: accent,
          secondaryAccent: secondaryAccent,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: WrappedColors.ink,
            fontSize: (screenWidth * 0.085).clamp(28.0, 38.0),
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: WrappedColors.muted,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

/// Text where `*marked*` parts are drawn in [accent] and `~marked~` parts in
/// [secondaryAccent].
class HighlightText extends StatelessWidget {
  final String text;
  final Color accent;
  final Color? secondaryAccent;
  final TextStyle style;
  final TextAlign textAlign;

  const HighlightText(
    this.text, {
    super.key,
    required this.accent,
    required this.style,
    this.secondaryAccent,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final buffer = StringBuffer();
    String? open;
    for (final char in text.split('')) {
      if ((char == '*' || char == '~') && (open == null || open == char)) {
        final color = open == '*'
            ? accent
            : open == '~'
                ? (secondaryAccent ?? accent)
                : null;
        spans.add(TextSpan(
          text: buffer.toString(),
          style: color != null ? TextStyle(color: color) : null,
        ));
        buffer.clear();
        open = open == null ? char : null;
      } else {
        buffer.write(char);
      }
    }
    spans.add(TextSpan(text: buffer.toString()));
    return Text.rich(
      TextSpan(style: style, children: spans),
      textAlign: textAlign,
    );
  }
}

/// Big emoji floating in a soft glowing orb (the "hero" of a result).
class GlowOrb extends StatelessWidget {
  final String emoji;
  final Color color;
  final double size;

  const GlowOrb({
    super.key,
    required this.emoji,
    required this.color,
    this.size = 170,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.45),
                    color.withOpacity(0.15),
                    color.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Container(
              width: size * 0.56,
              height: size * 0.56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, color.withOpacity(0.25)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: TextStyle(fontSize: size * 0.27)),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleStat {
  final String label;
  final String value;
  final Color color;

  const BubbleStat(this.label, this.value, this.color);
}

/// Row of soft colored circles with big numbers, slightly overlapping.
class StatBubbles extends StatelessWidget {
  final List<BubbleStat> stats;

  const StatBubbles({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = stats.length;
        final size = (constraints.maxWidth / (count - (count - 1) * 0.12))
            .clamp(0.0, count == 2 ? 150.0 : 118.0);
        final overlap = size * 0.12;
        final totalWidth = size * count - overlap * (count - 1);
        return Center(
          child: SizedBox(
            width: totalWidth,
            height: size + 12,
            child: Stack(
              children: [
                for (var i = 0; i < count; i++)
                  Positioned(
                    left: i * (size - overlap),
                    top: i.isOdd ? 12 : 0,
                    child: _Bubble(stat: stats[i], size: size),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final BubbleStat stat;
  final double size;

  const _Bubble({required this.stat, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.4),
          colors: [
            Colors.white.withOpacity(0.95),
            stat.color.withOpacity(0.28),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: stat.color.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: WrappedColors.ink.withOpacity(0.6),
              fontSize: (size * 0.1).clamp(10.0, 13.0),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [stat.color, stat.color.withOpacity(0.55)],
              ).createShader(rect),
              child: Text(
                stat.value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// White rounded card with an optional title row.
class SectionCard extends StatelessWidget {
  final String? title;
  final String? trailing;
  final Color trailingColor;
  final Widget child;
  final EdgeInsets padding;

  const SectionCard({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.trailingColor = WrappedColors.pinkDeep,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB0A6C8).withOpacity(0.14),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: GoogleFonts.inter(
                      color: WrappedColors.ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: GoogleFonts.inter(
                      color: trailingColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

/// Two-sided percentage bar (e.g. Type A vs Type B).
class SplitMeter extends StatelessWidget {
  final String leftLabel;
  final int leftValue;
  final Color leftColor;
  final String rightLabel;
  final int rightValue;
  final Color rightColor;

  const SplitMeter({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.leftColor,
    required this.rightLabel,
    required this.rightValue,
    required this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
    final total = (leftValue + rightValue) == 0 ? 1 : leftValue + rightValue;
    final leftFlex = (leftValue / total * 1000).round().clamp(1, 999);
    TextStyle valueStyle(Color c) => GoogleFonts.inter(
          color: c,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        );
    TextStyle labelStyle() => GoogleFonts.inter(
          color: WrappedColors.muted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$leftValue%', style: valueStyle(leftColor)),
                  Text(leftLabel, style: labelStyle()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$rightValue%', style: valueStyle(rightColor)),
                  Text(rightLabel, style: labelStyle()),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [
                Expanded(
                  flex: leftFlex,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [leftColor, leftColor.withOpacity(0.6)],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  flex: 1000 - leftFlex,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [rightColor.withOpacity(0.6), rightColor],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Row item with a tinted icon badge, used for flags, traits and facts.
class InsightRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const InsightRow({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 13, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: WrappedColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small letter tile, e.g. one MBTI letter with its meaning.
class LetterTile extends StatelessWidget {
  final String letter;
  final String meaning;
  final Color color;

  const LetterTile({
    super.key,
    required this.letter,
    required this.meaning,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            letter,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              meaning,
              style: GoogleFonts.inter(
                color: WrappedColors.ink.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Explanation paragraph from the AI, shown in a quiet card.
class InsightText extends StatelessWidget {
  final String text;
  final String title;

  const InsightText(this.text, {super.key, this.title = 'What AI noticed'});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: WrappedColors.ink.withOpacity(0.75),
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Big result card for a song / movie / persona: emoji tile, kicker, title, meta.
class FeatureCard extends StatelessWidget {
  final String emoji;
  final String kicker;
  final String title;
  final String? meta;
  final Color color;

  const FeatureCard({
    super.key,
    required this.emoji,
    required this.kicker,
    required this.title,
    required this.color,
    this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.white, 0.45)!],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                if (meta != null && meta!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    meta!,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarItem {
  final String label;
  final int value;
  final Color color;

  const BarItem(this.label, this.value, this.color);
}

/// Horizontal ranked bars (like a "Top 5" list); the label sits inside the bar.
class RankedBars extends StatelessWidget {
  final List<BarItem> items;
  final String suffix;

  const RankedBars({super.key, required this.items, this.suffix = '%'});

  @override
  Widget build(BuildContext context) {
    final maxValue = items.fold<int>(1, (m, e) => e.value > m ? e.value : m);
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final item = items[i];
              final width = constraints.maxWidth * 0.78;
              final fraction = 0.35 + 0.65 * (item.value / maxValue);
              return Row(
                children: [
                  Container(
                    width: width * fraction,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [item.color, Color.lerp(item.color, Colors.white, 0.4)!],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${item.value}$suffix',
                    style: GoogleFonts.inter(
                      color: WrappedColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

/// 2-column grid of monthly topics ({month, obsession, sentence, emoji}).
class MonthGrid extends StatelessWidget {
  final List<Map<String, dynamic>> months;

  const MonthGrid({super.key, required this.months});

  static const _tints = [
    WrappedColors.pink,
    WrappedColors.blue,
    WrappedColors.purple,
    WrappedColors.green,
    WrappedColors.peach,
    WrappedColors.pinkDeep,
  ];

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < months.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _MonthTile(data: months[i], color: _tints[i % _tints.length])),
              const SizedBox(width: 10),
              Expanded(
                child: i + 1 < months.length
                    ? _MonthTile(data: months[i + 1], color: _tints[(i + 1) % _tints.length])
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          rows[i],
        ],
      ],
    );
  }
}

class _MonthTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color color;

  const _MonthTile({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final month = (data['month'] ?? '').toString();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB0A6C8).withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                month.length > 3 ? month.substring(0, 3) : month,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text((data['emoji'] ?? '').toString(), style: const TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            (data['obsession'] ?? '').toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: WrappedColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (data['sentence'] ?? '').toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: WrappedColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill button that shares a screenshot of the page to Instagram Stories.
class WrappedShareButton extends StatelessWidget {
  final GlobalKey screenshotKey;
  final Color accent;

  const WrappedShareButton({
    super.key,
    required this.screenshotKey,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ShareHelper.shareToInstagramStory(context, screenshotKey),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, Color.lerp(accent, Colors.white, 0.35)!],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.paperplane_fill, color: Colors.white, size: 17),
            const SizedBox(width: 8),
            Text(
              'Share to Story',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen loading state used while chats / premium insights are analyzed.
class AnalyzingView extends StatelessWidget {
  final String title;
  final String status;
  final double progress;
  final String emoji;

  const AnalyzingView({
    super.key,
    required this.title,
    required this.status,
    required this.progress,
    this.emoji = '✨',
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress.clamp(0.0, 1.0) * 100).round();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: WrappedColors.background),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlowOrb(emoji: emoji, color: WrappedColors.pink, size: 180),
                const SizedBox(height: 12),
                Text(
                  'HANG TIGHT',
                  style: GoogleFonts.inter(
                    color: WrappedColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: WrappedColors.ink,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  '$percent%',
                  style: GoogleFonts.inter(
                    color: WrappedColors.pinkDeep,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: progress.clamp(0.0, 1.0)),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: WrappedColors.pink.withOpacity(0.18),
                      valueColor: const AlwaysStoppedAnimation<Color>(WrappedColors.pink),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    status,
                    key: ValueKey<String>(status),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: WrappedColors.muted,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded pill button; dark by default, or a soft gradient when [color] is set.
class WrappedPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? color;
  final bool loading;

  const WrappedPillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: accent == null ? WrappedColors.ink : null,
          gradient: accent == null
              ? null
              : LinearGradient(
                  colors: [accent, Color.lerp(accent, Colors.white, 0.35)!],
                ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: accent == null
              ? null
              : [
                  BoxShadow(
                    color: accent.withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: loading
            ? const Center(
                child: SizedBox(
                  height: 21,
                  width: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class WrappedFade extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const WrappedFade({
    super.key,
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay.clamp(0.0, 0.6),
        (delay + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - animation.value)),
          child: child,
        ),
      ),
    );
  }
}
