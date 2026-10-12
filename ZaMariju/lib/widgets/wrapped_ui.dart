import 'dart:async';
import 'dart:math' as math;

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

  /// Counts the numbers inside highlighted headline words up from zero.
  final bool countUpHeadline;

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
    this.countUpHeadline = false,
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
        countUp: widget.countUpHeadline,
      ),
      ...widget.children,
    ];
    final step = items.length <= 1 ? 0.0 : 0.5 / (items.length - 1);
    final durationMs = _controller.duration!.inMilliseconds;

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
                              child: _RevealScope(
                                delay: Duration(
                                  milliseconds: 450 + (i * step * durationMs).round(),
                                ),
                                child: items[i],
                              ),
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
  final bool countUp;

  const _WrappedHeader({
    required this.eyebrow,
    required this.headline,
    required this.subtitle,
    required this.accent,
    this.secondaryAccent,
    this.countUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget title(double progress) => HighlightText(
          headline,
          accent: accent,
          secondaryAccent: secondaryAccent,
          countProgress: countUp ? progress : null,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: WrappedColors.ink,
            fontSize: (screenWidth * 0.085).clamp(28.0, 38.0),
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        );
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
        if (countUp)
          WrappedReveal(
            delay: const Duration(milliseconds: -150),
            duration: const Duration(milliseconds: 1400),
            builder: (context, t) => title(Curves.easeOutCubic.transform(t)),
          )
        else
          title(1),
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

  /// When set, numbers inside highlighted parts are shown at this fraction (0–1).
  final double? countProgress;

  /// Characters that toggle highlighting; `~` is only meaningful with [secondaryAccent].
  final String markers;
  final FontWeight? highlightWeight;

  const HighlightText(
    this.text, {
    super.key,
    required this.accent,
    required this.style,
    this.secondaryAccent,
    this.textAlign = TextAlign.start,
    this.countProgress,
    this.markers = '*~',
    this.highlightWeight,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final buffer = StringBuffer();
    String? open;
    for (final char in text.split('')) {
      if (markers.contains(char) && (open == null || open == char)) {
        final color = open == '*'
            ? accent
            : open == '~'
                ? (secondaryAccent ?? accent)
                : null;
        final segment = buffer.toString();
        spans.add(TextSpan(
          text: color != null && countProgress != null
              ? countUpText(segment, countProgress!)
              : segment,
          style: color != null
              ? TextStyle(color: color, fontWeight: highlightWeight)
              : null,
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
                    child: PopIn(
                      delay: Duration(milliseconds: 140 * i),
                      child: _Bubble(stat: stats[i], size: size, delay: 140 * i),
                    ),
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
  final int delay;

  const _Bubble({required this.stat, required this.size, this.delay = 0});

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
              child: CountUpText(
                stat.value,
                delay: Duration(milliseconds: delay + 150),
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

class ChartSegment {
  final String label;
  final int value;
  final Color color;
  final String? emoji;

  const ChartSegment(this.label, this.value, this.color, {this.emoji});
}

/// Animated donut chart; segments sweep in clockwise from the top.
class DonutChart extends StatelessWidget {
  final List<ChartSegment> segments;
  final double size;
  final double stroke;
  final Widget? center;

  const DonutChart({
    super.key,
    required this.segments,
    this.size = 140,
    this.stroke = 18,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: WrappedReveal(
        duration: const Duration(milliseconds: 1400),
        builder: (context, t) => CustomPaint(
          painter: _DonutPainter(
            segments: segments,
            progress: Curves.easeInOutCubic.transform(t),
            stroke: stroke,
          ),
          child: center == null ? null : Center(child: center),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<ChartSegment> segments;
  final double progress;
  final double stroke;

  _DonutPainter({
    required this.segments,
    required this.progress,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final radius = rect.width / 2;
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = const Color(0xFFF2EFF7),
    );

    final total = segments.fold<int>(0, (sum, s) => sum + math.max(0, s.value));
    if (total == 0) return;
    final capAngle = (stroke / 2) / radius;
    final gap = segments.length > 1 ? capAngle * 2 + 0.05 : 0.0;
    final limit = math.pi * 2 * progress;
    var start = -math.pi / 2;
    var drawn = 0.0;
    for (final segment in segments) {
      final full = math.pi * 2 * math.max(0, segment.value) / total;
      final visible = (limit - drawn).clamp(0.0, full);
      if (visible <= 0) break;
      final sweep = math.max(0.001, visible - gap);
      canvas.drawArc(
        rect,
        start + gap / 2,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..color = segment.color,
      );
      start += full;
      drawn += full;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress || old.segments != segments;
}

/// Legend rows for a [DonutChart]: dot, optional emoji, label and counted value.
class ChartLegend extends StatelessWidget {
  final List<ChartSegment> segments;
  final String suffix;

  const ChartLegend({super.key, required this.segments, this.suffix = '%'});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < segments.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: segments[i].color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              if (segments[i].emoji != null) ...[
                Text(segments[i].emoji!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: Text(
                  segments[i].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: WrappedColors.ink,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              CountUpText(
                '${segments[i].value}$suffix',
                delay: Duration(milliseconds: 120 * i),
                style: GoogleFonts.inter(
                  color: Color.lerp(segments[i].color, WrappedColors.ink, 0.2),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class MeterItem {
  final String label;
  final int value;
  final Color color;
  final String? emoji;

  const MeterItem(this.label, this.value, this.color, {this.emoji});
}

/// Stack of labelled horizontal meters that fill up one after another.
class MeterList extends StatelessWidget {
  final List<MeterItem> items;
  final String suffix;
  final int maxValue;

  const MeterList({
    super.key,
    required this.items,
    this.suffix = '%',
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          _Meter(item: items[i], suffix: suffix, maxValue: maxValue, delay: 150 * i),
        ],
      ],
    );
  }
}

class _Meter extends StatelessWidget {
  final MeterItem item;
  final String suffix;
  final int maxValue;
  final int delay;

  const _Meter({
    required this.item,
    required this.suffix,
    required this.maxValue,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = (item.value / maxValue).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          children: [
            if (item.emoji != null) ...[
              Text(item.emoji!, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: WrappedColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            CountUpText(
              '${item.value}$suffix',
              delay: Duration(milliseconds: delay),
              style: GoogleFonts.inter(
                color: Color.lerp(item.color, WrappedColors.ink, 0.25),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        WrappedReveal(
          delay: Duration(milliseconds: delay),
          duration: const Duration(milliseconds: 1100),
          builder: (context, t) => Container(
            height: 10,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraction * Curves.easeOutCubic.transform(t),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.lerp(item.color, Colors.white, 0.35)!, item.color],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Circular progress ring with a counted value in the middle.
class RingGauge extends StatelessWidget {
  /// Filled fraction, 0–1.
  final double value;
  final String centerText;
  final String? caption;
  final Color color;
  final double size;
  final double stroke;

  const RingGauge({
    super.key,
    required this.value,
    required this.centerText,
    required this.color,
    this.caption,
    this.size = 120,
    this.stroke = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: WrappedReveal(
        duration: const Duration(milliseconds: 1300),
        builder: (context, t) => CustomPaint(
          painter: _RingPainter(
            value: value.clamp(0.0, 1.0) * Curves.easeOutCubic.transform(t),
            color: color,
            stroke: stroke,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountUpText(
                  centerText,
                  style: GoogleFonts.inter(
                    color: WrappedColors.ink,
                    fontSize: size * 0.24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    height: 1.0,
                  ),
                ),
                if (caption != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    caption!,
                    style: GoogleFonts.inter(
                      color: WrappedColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color color;
  final double stroke;

  _RingPainter({required this.value, required this.color, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color.withOpacity(0.14),
    );
    if (value <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [Color.lerp(color, Colors.white, 0.45)!, color],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value || old.color != color;
}

/// Gradient track with a knob that slides to [position] (0 = left, 1 = right).
class SpectrumBar extends StatelessWidget {
  final double position;
  final List<String> labels;
  final Color leftColor;
  final Color rightColor;

  const SpectrumBar({
    super.key,
    required this.position,
    required this.labels,
    required this.leftColor,
    required this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
    final target = position.clamp(0.0, 1.0);
    final active = (target * (labels.length - 1)).round();
    return Column(
      children: [
        WrappedReveal(
          duration: const Duration(milliseconds: 1400),
          builder: (context, t) {
            final current = 0.5 + (target - 0.5) * Curves.easeOutBack.transform(t);
            return LayoutBuilder(
              builder: (context, constraints) {
                const knob = 30.0;
                final left = (constraints.maxWidth - knob) * current.clamp(0.0, 1.0);
                return SizedBox(
                  height: knob,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [leftColor, rightColor]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Positioned(
                        left: left,
                        child: Container(
                          width: knob,
                          height: knob,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.lerp(leftColor, rightColor, current)!,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < labels.length; i++)
              Text(
                labels[i],
                style: GoogleFonts.inter(
                  color: i == active
                      ? Color.lerp(leftColor, rightColor, i / math.max(1, labels.length - 1))
                      : WrappedColors.muted,
                  fontSize: 12.5,
                  fontWeight: i == active ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Highlighted keyword pills that pop in one by one.
class TraitChips extends StatelessWidget {
  final List<String> traits;
  final List<Color> colors;

  const TraitChips({super.key, required this.traits, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < traits.length; i++)
          PopIn(
            delay: Duration(milliseconds: 120 * i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: colors[i % colors.length].withOpacity(0.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                traits[i],
                style: GoogleFonts.inter(
                  color: Color.lerp(colors[i % colors.length], WrappedColors.ink, 0.3),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
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
  final Duration delay;

  const LetterTile({
    super.key,
    required this.letter,
    required this.meaning,
    required this.color,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return PopIn(
      delay: delay,
      child: _buildTile(),
    );
  }

  Widget _buildTile() {
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

/// Explanation paragraph from the AI, shown in a quiet card. `*Phrases*` are
/// highlighted in [accent].
class InsightText extends StatelessWidget {
  final String text;
  final String title;
  final Color accent;

  const InsightText(
    this.text, {
    super.key,
    this.title = 'What AI noticed',
    this.accent = WrappedColors.pinkDeep,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      child: HighlightText(
        text,
        accent: accent,
        markers: '*',
        highlightWeight: FontWeight.w700,
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

/// Tells [WrappedReveal]s inside a page item when that item becomes visible.
class _RevealScope extends InheritedWidget {
  final Duration delay;

  const _RevealScope({required this.delay, required super.child});

  @override
  bool updateShouldNotify(_RevealScope oldWidget) => false;
}

/// One-shot 0→1 animation that starts once its page item has faded in (plus
/// [delay]); [builder] receives the linear progress.
class WrappedReveal extends StatefulWidget {
  final Duration delay;
  final Duration duration;
  final Widget Function(BuildContext context, double t) builder;

  const WrappedReveal({
    super.key,
    required this.builder,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 1100),
  });

  @override
  State<WrappedReveal> createState() => _WrappedRevealState();
}

class _WrappedRevealState extends State<WrappedReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timer != null) return;
    final scope = context.getInheritedWidgetOfExactType<_RevealScope>();
    final start = (scope?.delay ?? const Duration(milliseconds: 300)) + widget.delay;
    _timer = Timer(start.isNegative ? Duration.zero : start, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value),
    );
  }
}

/// Scales [child] in with a little overshoot, Wrapped-style.
class PopIn extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const PopIn({super.key, required this.child, this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    return WrappedReveal(
      delay: delay,
      duration: const Duration(milliseconds: 650),
      builder: (context, t) => Opacity(
        opacity: math.min(1.0, t * 2.5),
        child: Transform.scale(
          scale: 0.4 + 0.6 * Curves.easeOutBack.transform(t),
          child: child,
        ),
      ),
    );
  }
}

/// Text whose numbers count up from zero while the text pops in.
class CountUpText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Duration delay;

  const CountUpText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return WrappedReveal(
      delay: delay,
      duration: const Duration(milliseconds: 1200),
      builder: (context, t) => Opacity(
        opacity: math.min(1.0, t * 4),
        child: Transform.scale(
          scale: 0.6 + 0.4 * Curves.easeOutBack.transform(math.min(1.0, t * 1.8)),
          child: Text(
            countUpText(text, Curves.easeOutCubic.transform(t)),
            style: style,
            textAlign: textAlign,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

/// Replaces every number in [text] with its value scaled by [progress],
/// keeping decimals and thousands separators.
String countUpText(String text, double progress) {
  if (progress >= 1) return text;
  return text.replaceAllMapped(RegExp(r'\d[\d,]*(?:\.\d+)?'), (match) {
    final raw = match.group(0)!;
    final target = double.tryParse(raw.replaceAll(',', ''));
    if (target == null) return raw;
    final decimals = raw.contains('.') ? raw.split('.').last.length : 0;
    var value = (target * progress).toStringAsFixed(decimals);
    if (raw.contains(',')) {
      final parts = value.split('.');
      final digits = parts.first;
      final grouped = StringBuffer();
      for (var i = 0; i < digits.length; i++) {
        if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(',');
        grouped.write(digits[i]);
      }
      value = parts.length > 1 ? '$grouped.${parts[1]}' : grouped.toString();
    }
    return value;
  });
}

/// Stable pseudo-random number in [min, max] derived from [seed]; used for
/// chart fallbacks when the AI didn't return a value.
int seededValue(String seed, int salt, int min, int max) {
  var hash = 17 + salt * 7919;
  for (final unit in seed.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return min + hash % (max - min + 1);
}
