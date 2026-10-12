import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/card_navigator.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/screen_preview_analysis.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class SocialSharingScreen extends StatelessWidget {
  final ChatStats? stats;
  final PremiumInsights? premiumInsights;

  const SocialSharingScreen({
    super.key,
    this.stats,
    this.premiumInsights,
  });

  void _backToStart(BuildContext context) {
    final navigator = CardNavigator.of(context);
    if (navigator == null) return;
    final screens = navigator.widget.screens;
    final mbtiIndex = screens.indexWhere(
      (s) => s.runtimeType.toString() == 'MBTIPersonalityScreen',
    );
    navigator.goToIndex(mbtiIndex >= 0 ? mbtiIndex : 0);
  }

  void _openPreview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviewAnalysisScreen(
          stats: stats,
          premiumInsights: premiumInsights,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insights = premiumInsights;
    final highlights = <(String, String, Color)>[
      if (insights != null) ...[
        ('MBTI', insights.mbtiType, WrappedColors.pink),
        ('Zodiac', insights.zodiacName, WrappedColors.purple),
        ('Love language', insights.loveLanguage, WrappedColors.pinkDeep),
        ('Energy', _titleCase(insights.introExtroType), WrappedColors.blue),
        ('Style', _titleCase(insights.personalityType), WrappedColors.peach),
      ],
    ];

    return WrappedPage(
      eyebrow: 'That\'s a wrap',
      headline: 'Your *Chat Era*, wrapped',
      subtitle: 'Every screen has a share button, so post your favorites to your story.',
      accent: WrappedColors.pinkDeep,
      bottom: WrappedPillButton(
        label: 'Back to the first insight',
        icon: CupertinoIcons.arrow_counterclockwise,
        onTap: () => _backToStart(context),
      ),
      children: [
        const GlowOrb(emoji: '🎉', color: WrappedColors.pink, size: 140),
        if (highlights.isNotEmpty)
          SectionCard(
            title: 'Your highlights',
            child: Column(
              children: [
                for (var i = 0; i < highlights.length; i++) ...[
                  if (i > 0) const Divider(height: 18, color: Color(0xFFF0EEF4)),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: highlights[i].$3,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        highlights[i].$1,
                        style: GoogleFonts.inter(
                          color: WrappedColors.muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          highlights[i].$2,
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: WrappedColors.ink,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openPreview(context),
          child: SectionCard(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: WrappedColors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(CupertinoIcons.play_fill, color: WrappedColors.blue, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Watch your recap',
                        style: GoogleFonts.inter(
                          color: WrappedColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'All your insights in one preview',
                        style: GoogleFonts.inter(
                          color: WrappedColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.chevron_forward, color: Color(0xFFC7C7CC), size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _titleCase(String value) {
    final lower = value.toLowerCase();
    return lower
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}
