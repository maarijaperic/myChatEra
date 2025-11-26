import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareToStoryButton extends StatelessWidget {
  final String shareText;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> accentGradient;

  const ShareToStoryButton({
    super.key,
    required this.shareText,
    this.title = 'Share to Story',
    this.subtitle = 'Post directly to Instagram',
    this.icon = CupertinoIcons.share_up,
    this.accentGradient = const [
      Color(0xFFFF8FB1),
      Color(0xFFFFB5D8),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.04).clamp(16.0, 22.0);

    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: shareText));
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
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: accentGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accentGradient.last.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1F1F21),
                      fontSize: (screenWidth * 0.042).clamp(15.0, 18.0),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8E8E93),
                      fontSize: (screenWidth * 0.032).clamp(12.0, 14.0),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_forward,
              color: Color(0xFFAEAEB2),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

