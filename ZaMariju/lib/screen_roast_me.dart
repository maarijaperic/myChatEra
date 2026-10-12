import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class RoastMeScreen extends StatelessWidget {
  final String question;
  final String roastText;
  final String subtitle;

  const RoastMeScreen({
    super.key,
    required this.question,
    required this.roastText,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return WrappedPage(
      eyebrow: 'AI roast',
      headline: 'Time to get *roasted*',
      subtitle: subtitle,
      accent: WrappedColors.peach,
      shareText: 'AI just roasted me based on my chats 🔥😂 #mychateraAI',
      children: [
        const GlowOrb(emoji: '🔥', color: WrappedColors.peach, size: 140),
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
