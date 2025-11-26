import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/utils/share_helper.dart';

/// Small Share to Story Button that shares screenshot to Instagram
class SmallShareToStoryButton extends StatelessWidget {
  final String shareText;
  final GlobalKey? screenshotKey;
  final List<Color> accentGradient;

  const SmallShareToStoryButton({
    super.key,
    required this.shareText,
    required this.screenshotKey,
    this.accentGradient = const [
      Color(0xFFFF8FB1),
      Color(0xFFFFB5D8),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // Try to share screenshot if key is provided
        if (screenshotKey != null) {
          await ShareHelper.shareToInstagramStory(context, screenshotKey!);
        } else {
          // Fallback: Copy text to clipboard
          Clipboard.setData(ClipboardData(text: shareText));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ Copied! Ready to share to your story'),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: (screenWidth * 0.05).clamp(16.0, 20.0),
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: accentGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accentGradient.last.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.share_up,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Share to Story',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1F1F21),
                      fontSize: (screenWidth * 0.035).clamp(13.0, 15.0),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Post to Instagram',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8E8E93),
                      fontSize: (screenWidth * 0.028).clamp(11.0, 12.0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_forward,
              color: Color(0xFFAEAEB2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

