import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';

class RedGreenFlagsScreen extends StatelessWidget {
  final String question;
  final String greenFlagTitle;
  final String redFlagTitle;
  final List<String> greenFlags;
  final List<String> redFlags;
  final String subtitle;

  const RedGreenFlagsScreen({
    super.key,
    required this.question,
    required this.greenFlagTitle,
    required this.redFlagTitle,
    required this.greenFlags,
    required this.redFlags,
    required this.subtitle,
  });

  Widget _flagList(List<String> flags, IconData icon, Color color) {
    return Column(
      children: [
        for (var i = 0; i < flags.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          InsightRow(icon: icon, color: color, text: flags[i]),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final green = greenFlags.take(4).toList();
    final red = redFlags.take(4).toList();

    return WrappedPage(
      eyebrow: 'Flags',
      headline: 'Your *green* & ~red~ flags',
      subtitle: subtitle,
      accent: WrappedColors.green,
      secondaryAccent: WrappedColors.red,
      shareText: 'My green & red flags according to AI 🟢🔴 #mychateraAI',
      children: [
        if (green.isNotEmpty)
          SectionCard(
            title: 'Green flags',
            trailing: '🟢',
            child: _flagList(green, CupertinoIcons.checkmark_alt, WrappedColors.green),
          ),
        if (red.isNotEmpty)
          SectionCard(
            title: 'Red flags',
            trailing: '🚩',
            child: _flagList(red, CupertinoIcons.flag_fill, WrappedColors.red),
          ),
      ],
    );
  }
}
