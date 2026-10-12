import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class RoastMeScreen extends StatelessWidget {
  final String question;
  final String roastText;
  final String subtitle;

  /// How brutal the roast is (0–100).
  final int heat;

  /// Funny habit scores, e.g. {'3 AM Questions': 92}.
  final Map<String, int> meters;

  const RoastMeScreen({
    super.key,
    required this.question,
    required this.roastText,
    required this.subtitle,
    this.heat = 0,
    this.meters = const {},
  });

  static const _meterColors = [
    WrappedColors.red,
    WrappedColors.peach,
    WrappedColors.pink,
    WrappedColors.purple,
  ];

  int get _heat => heat > 0 ? heat : seededValue(roastText, 1, 72, 94);

  List<MapEntry<String, int>> get _meters {
    if (meters.isNotEmpty) return meters.entries.take(4).toList();
    return [
      MapEntry('3 AM Questions', seededValue(roastText, 2, 70, 95)),
      MapEntry('Overthinking', seededValue(roastText, 3, 60, 92)),
      MapEntry('Needs Validation', seededValue(roastText, 4, 50, 85)),
      MapEntry('Procrastination', seededValue(roastText, 5, 45, 80)),
    ];
  }

  String _heatLabel(int value) {
    if (value >= 90) return 'Nuclear ☢️';
    if (value >= 75) return 'Extra spicy 🌶️';
    if (value >= 55) return 'Spicy 🔥';
    return 'Mild 🙂';
  }

  @override
  Widget build(BuildContext context) {
    final heatValue = _heat;
    final meterList = _meters;

    return WrappedPage(
      eyebrow: 'AI roast',
      headline: 'Time to get *roasted*',
      subtitle: subtitle,
      accent: WrappedColors.peach,
      shareText: 'AI just roasted me based on my chats 🔥😂 #mychateraAI',
      children: [
        SectionCard(
          child: Row(
            children: [
              RingGauge(
                value: heatValue / 100,
                centerText: '$heatValue%',
                caption: 'heat level',
                color: WrappedColors.red,
                size: 118,
                stroke: 12,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROAST LEVEL',
                      style: GoogleFonts.inter(
                        color: WrappedColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PopIn(
                      delay: const Duration(milliseconds: 700),
                      child: Text(
                        _heatLabel(heatValue),
                        style: GoogleFonts.inter(
                          color: WrappedColors.ink,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI didn\'t hold back.',
                      style: GoogleFonts.inter(
                        color: WrappedColors.muted,
                        fontSize: 13,
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
          title: 'Your roast stats',
          trailing: 'Guilty as charged',
          trailingColor: WrappedColors.red,
          child: MeterList(
            items: [
              for (var i = 0; i < meterList.length; i++)
                MeterItem(meterList[i].key, meterList[i].value, _meterColors[i % _meterColors.length]),
            ],
          ),
        ),
        SectionCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '“',
                style: GoogleFonts.inter(
                  color: WrappedColors.peach,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  height: 0.8,
                ),
              ),
              Text(
                roastText,
                style: GoogleFonts.inter(
                  color: WrappedColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
