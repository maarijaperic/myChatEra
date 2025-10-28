import 'dart:math';
import 'package:flutter/material.dart';

class LoveCountWrappedScreen extends StatefulWidget {
  final String title;
  final String leftName;
  final String rightName;
  final int leftValue;
  final int rightValue;

  const LoveCountWrappedScreen({
    super.key,
    required this.title,
    required this.leftName,
    required this.rightName,
    required this.leftValue,
    required this.rightValue,
  });

  @override
  State<LoveCountWrappedScreen> createState() => _LoveCountWrappedScreenState();
}

class _LoveCountWrappedScreenState extends State<LoveCountWrappedScreen>
    with TickerProviderStateMixin {
  late final AnimationController _barsCtrl;
  late final AnimationController _staggerCtrl;
  late final AnimationController _headerCtrl;
  late final AnimationController _footerCtrl;
  late final AnimationController _dashCtrl;

  @override
  void initState() {
    super.initState();

    // Master for bar growth + number count.
    _barsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Stagger for second bar.
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Header + footer entrance.
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _footerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Top dash sweep.
    _dashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _playSequence();
  }

  Future<void> _playSequence() async {
    await _headerCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _barsCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    _staggerCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _footerCtrl.forward();
  }

  @override
  void dispose() {
    _barsCtrl.dispose();
    _staggerCtrl.dispose();
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    _dashCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = max(widget.leftValue, widget.rightValue).toDouble();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background.
          const _WrappedGradient(),
          // Content.
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight;
                final w = constraints.maxWidth;
                final barMaxHeight = h * 0.38;
                final double barWidth = (w * 0.18).clamp(56.0, 88.0);

                return Column(
                  children: [
                    _TopDashes(controller: _dashCtrl),
                    const SizedBox(height: 8),
                    // Header
                    _SlideFadeIn(
                      controller: _headerCtrl,
                      beginOffset: const Offset(0, -0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (w * 0.07).clamp(24.0, 34.0),
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // Bars
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Left bar
                              Expanded(
                                child: _AnimatedBar(
                                  primaryColor: const Color(0xFFFF4E45),
                                  shadowColor: const Color(0x33FF4E45),
                                  value: widget.leftValue.toDouble(),
                                  maxValue: maxValue,
                                  maxHeight: barMaxHeight,
                                  barWidth: barWidth,
                                  controller: _barsCtrl,
                                  curve: Curves.easeOutBack,
                                  // Counts up with the main controller.
                                  numberAnimation: _barsCtrl.drive(
                                    CurveTween(
                                      curve: const Interval(
                                        0.0,
                                        1.0,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                                  label: widget.leftName,
                                ),
                              ),
                              const SizedBox(width: 28),
                              // Right bar (staggered)
                              Expanded(
                                child: _AnimatedBar(
                                  primaryColor: const Color(0xFF3B3BFF),
                                  shadowColor: const Color(0x333B3BFF),
                                  value: widget.rightValue.toDouble(),
                                  maxValue: maxValue,
                                  maxHeight:
                                      barMaxHeight *
                                      0.92, // tiny variance feels organic
                                  barWidth: barWidth,
                                  controller: _staggerCtrl,
                                  curve: Curves.easeOutBack,
                                  numberAnimation: _staggerCtrl.drive(
                                    CurveTween(
                                      curve: const Interval(
                                        0.0,
                                        1.0,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                                  label: widget.rightName,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Footer
                    _SlideFadeIn(
                      controller: _footerCtrl,
                      beginOffset: const Offset(0, 0.08),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: Text(
                          'Love makes sense when expressed: '
                          'what do you think has given more of the "I love you"?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: (w * 0.04).clamp(13.0, 18.0),
                            height: 1.25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Visual Building Blocks ----------

class _WrappedGradient extends StatelessWidget {
  const _WrappedGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -1.2),
          end: Alignment(0, 1.1),
          colors: [
            Color(0xFFFF7CA8), // hot pink
            Color(0xFFFF6E7F), // coral-ish
            Color(0xFFFFB56B), // warm peach
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// Removed star pattern overlay per design update.

class _TopDashes extends StatelessWidget {
  final AnimationController controller;
  const _TopDashes({required this.controller});

  @override
  Widget build(BuildContext context) {
    const count = 12;
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final activeIndex = (controller.value * count).floor() % count;
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(count, (i) {
              final isActive = i == activeIndex;
              return Container(
                width: 28,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white.withValues(alpha: 0.95)
                      : Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _SlideFadeIn extends StatelessWidget {
  final AnimationController controller;
  final Offset beginOffset;
  final Widget child;

  const _SlideFadeIn({
    required this.controller,
    required this.beginOffset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final slide = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    final fade = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Opacity(
        opacity: fade.value,
        child: FractionalTranslation(translation: slide.value, child: child),
      ),
    );
  }
}

class _AnimatedBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final double maxHeight;
  final double barWidth;
  final AnimationController controller;
  final Curve curve;
  final Animation<double> numberAnimation;
  final String label;
  final Color primaryColor;
  final Color shadowColor;

  const _AnimatedBar({
    required this.value,
    required this.maxValue,
    required this.maxHeight,
    required this.barWidth,
    required this.controller,
    required this.curve,
    required this.numberAnimation,
    required this.label,
    required this.primaryColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: controller, curve: curve);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // The bar + number.
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final t = curved.value; // 0..1
            final targetH = maxValue == 0
                ? 0.0
                : (value / maxValue) * maxHeight;
            final h = targetH * t;

            final n = (value * numberAnimation.value).round();

            return SizedBox(
              height: maxHeight,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Shadow "base" to give depth.
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: (barWidth * 0.35).clamp(12.0, 22.0),
                      height: h * 0.06 + 2,
                      decoration: BoxDecoration(
                        color: shadowColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Actual bar.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: barWidth,
                      height: h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primaryColor.withValues(alpha: 0.92),
                            primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(barWidth / 2),
                          topRight: Radius.circular(barWidth / 2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.35),
                            offset: const Offset(0, 10),
                            blurRadius: 30,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _formatSpanish(n),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (barWidth * 0.6).clamp(24.0, 42.0),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Label
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: (barWidth * 0.28).clamp(14.0, 20.0),
          ),
        ),
      ],
    );
  }
}

/// Spanish-style thousands separator with dots (e.g., 1.564)
String _formatSpanish(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    buf.write(s[i]);
    count++;
    if (i != 0 && count % 3 == 0) buf.write('.');
  }
  return buf.toString().split('').reversed.join();
}
