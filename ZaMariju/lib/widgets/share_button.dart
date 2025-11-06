import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareToStoryButton extends StatelessWidget {
  final String shareText;
  final Color? primaryColor;
  final Color? secondaryColor;
  
  const ShareToStoryButton({
    super.key,
    required this.shareText,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive sizing based on screen size
    final buttonHeight = (screenHeight * 0.07).clamp(48.0, 56.0);
    final iconContainerSize = (screenWidth * 0.11).clamp(32.0, 40.0);
    final iconSize = iconContainerSize * 0.5; // Icon is 50% of container
    final fontSize = (screenWidth * 0.038).clamp(14.0, 18.0);
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 20.0);
    final iconTextSpacing = (screenWidth * 0.04).clamp(12.0, 16.0);
    
    return GestureDetector(
      onTap: () {
        // Copy to clipboard and show snackbar
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
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.9, // Max 90% of screen width
          minWidth: (screenWidth * 0.6).clamp(200.0, 300.0), // Responsive min width
        ),
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(buttonHeight / 2), // Fully rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor ?? const Color(0xFFFF6B9D),
                    secondaryColor ?? const Color(0xFFFF8E9E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(iconContainerSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: (primaryColor ?? const Color(0xFFFF6B9D)).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.ios_share_rounded,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            SizedBox(width: iconTextSpacing),
            Flexible(
              child: Text(
                'Share to Story',
                style: GoogleFonts.inter(
                  color: const Color(0xFF333333),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

