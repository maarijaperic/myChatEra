import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/card_navigator.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

/// Single free results screen: a compact snapshot of the user's basic stats.
class FreeSummaryScreen extends StatelessWidget {
  final int totalMessages;
  final int totalConversations;
  final int totalHours;
  final int totalMinutes;
  final int messagesPerDay;
  final int longestStreak;
  final int activeDays;
  final int yearPercentage;
  final String peakTime;
  final int peakHour;

  /// Conversations started per hour of day (24 entries); all zeros if unknown.
  final List<int> hourlyActivity;

  const FreeSummaryScreen({
    super.key,
    required this.totalMessages,
    required this.totalConversations,
    required this.totalHours,
    required this.totalMinutes,
    required this.messagesPerDay,
    required this.longestStreak,
    required this.activeDays,
    required this.yearPercentage,
    required this.peakTime,
    required this.peakHour,
    this.hourlyActivity = const [],
  });

  String get _peakTitle {
    switch (peakTime) {
      case 'morning':
        return 'Early bird';
      case 'afternoon':
        return 'Daytime thinker';
      case 'evening':
        return 'Evening explorer';
      default:
        return 'Night owl';
    }
  }

  String get _peakHourLabel {
    final hour = peakHour % 24;
    final suffix = hour < 12 ? 'AM' : 'PM';
    final display = hour % 12 == 0 ? 12 : hour % 12;
    return '$display $suffix';
  }

  String get _hoursLabel => totalHours > 0 ? '${totalHours}h' : '${totalMinutes}m';

  /// Uses real hourly counts when available, otherwise a curve around the peak hour.
  double _barFraction(int hour) {
    final peak = peakHour % 24;
    final maxCount = hourlyActivity.length == 24 ? hourlyActivity.reduce(max) : 0;
    if (maxCount > 0) return hourlyActivity[hour] / maxCount;
    final diff = min((hour - peak).abs(), 24 - (hour - peak).abs());
    return exp(-(diff * diff) / 18);
  }

  @override
  Widget build(BuildContext context) {
    final peak = peakHour % 24;

    return WrappedPage(
      eyebrow: 'Your chat era',
      headline: 'You sent *${_formatNumber(totalMessages)}* messages to AI',
      accent: WrappedColors.pinkDeep,
      bottom: _ContinueButton(
        onTap: () => CardNavigator.of(context)?.goToNext(),
      ),
      children: [
        StatBubbles(
          stats: [
            BubbleStat('Chats', _formatNumber(totalConversations), WrappedColors.pink),
            BubbleStat('Hours', _hoursLabel, WrappedColors.blue),
            BubbleStat('Streak', '${longestStreak}d', WrappedColors.purple),
          ],
        ),
        SectionCard(
          title: _peakTitle,
          trailing: 'Peak $_peakHourLabel',
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var h = 0; h < 24; h++) ...[
                      if (h > 0) const SizedBox(width: 3),
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: 0.12 + 0.88 * _barFraction(h),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: h == peak
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [WrappedColors.pinkDeep, WrappedColors.pink],
                                    )
                                  : null,
                              color: h == peak ? null : const Color(0xFFF6DCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final label in const ['12 AM', '6 AM', '12 PM', '6 PM', '11 PM'])
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: WrappedColors.muted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        SectionCard(
          title: 'Your rhythm',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _RhythmStat(
                  value: '$messagesPerDay',
                  label: 'messages a day',
                  color: WrappedColors.pinkDeep,
                ),
              ),
              Container(width: 1, height: 64, color: const Color(0xFFF0EEF4)),
              Expanded(
                child: _RhythmStat(
                  value: '$activeDays',
                  label: 'active days',
                  color: WrappedColors.purple,
                  progress: yearPercentage / 100,
                  progressLabel: '$yearPercentage% of the year',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatNumber(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class _RhythmStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final double? progress;
  final String? progressLabel;

  const _RhythmStat({
    required this.value,
    required this.label,
    required this.color,
    this.progress,
    this.progressLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: WrappedColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 5,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              progressLabel ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: WrappedColors.muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: WrappedColors.ink,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'See your personality insights',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
