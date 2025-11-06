import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/widgets/share_button.dart';

class RedGreenFlagsScreen extends StatefulWidget {
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

  @override
  State<RedGreenFlagsScreen> createState() => _RedGreenFlagsScreenState();
}

class _RedGreenFlagsScreenState extends State<RedGreenFlagsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;
    
    // Responsive padding
    final horizontalPadding = (screenWidth * 0.06).clamp(16.0, 32.0);
    final verticalPadding = (screenHeight * 0.025).clamp(16.0, 24.0);
    
    // Responsive spacing
    final topSpacing = (screenHeight * 0.08).clamp(20.0, 60.0);
    final sectionSpacing = (screenHeight * 0.03).clamp(12.0, 24.0);
    final cardSpacing = (screenHeight * 0.025).clamp(12.0, 20.0);
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Light pastel gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFD4E5), // Light pink
                  Color(0xFFFFCBD1), // Soft rose
                  Color(0xFFFFC4BE), // Peach-pink
                  Color(0xFFFFD9C4), // Light apricot
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeController,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: topSpacing),
                
                // Question
                Text(
                  widget.question,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: (screenWidth * 0.055).clamp(16.0, isLargeScreen ? 28.0 : 26.0),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: sectionSpacing),
                
                // Green Flags Card
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: _buildFlagCard(
                    title: widget.greenFlagTitle,
                    flags: widget.greenFlags,
                    isGreen: true,
                    screenWidth: screenWidth,
                  ),
                ),
                
                SizedBox(height: cardSpacing),
                
                // Red Flags Card
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: _buildFlagCard(
                    title: widget.redFlagTitle,
                    flags: widget.redFlags,
                    isGreen: false,
                    screenWidth: screenWidth,
                  ),
                ),
                
                SizedBox(height: cardSpacing),
                
                // Subtitle
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: (screenWidth * 0.035).clamp(12.0, isLargeScreen ? 20.0 : 18.0),
                    color: Colors.white.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                SizedBox(height: (screenHeight * 0.015).clamp(8.0, 16.0)),
                
                // Share Button
                Center(
                  child: ShareToStoryButton(
                    shareText: 'Check out my ChatGPT Red and Green Flags! 🟢🔴 #ChatGPTWrapped',
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagCard({
    required String title,
    required List<String> flags,
    required bool isGreen,
    required double screenWidth,
  }) {
    final isLargeScreen = screenWidth > 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all((screenWidth * 0.035).clamp(12.0, 18.0)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5).withOpacity(0.95),
        borderRadius: BorderRadius.circular((screenWidth * 0.05).clamp(18.0, 24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: (screenWidth * 0.02).clamp(6.0, 10.0),
              vertical: (screenWidth * 0.02).clamp(6.0, 10.0),
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: (screenWidth * 0.038).clamp(13.0, isLargeScreen ? 22.0 : 20.0),
                fontWeight: FontWeight.w700,
                color: isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          SizedBox(height: (screenWidth * 0.015).clamp(4.0, 8.0)),
          
          // Flags List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: (screenWidth * 0.015).clamp(4.0, 8.0)),
            child: Column(
              children: flags.map((flag) {
                final iconSize = (screenWidth * 0.04).clamp(14.0, 20.0);
                return Padding(
                  padding: EdgeInsets.only(bottom: (screenWidth * 0.01).clamp(4.0, 6.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: iconSize,
                        height: iconSize,
                        margin: EdgeInsets.only(
                          right: (screenWidth * 0.015).clamp(4.0, 8.0),
                          top: (screenWidth * 0.005).clamp(1.0, 3.0),
                        ),
                        decoration: BoxDecoration(
                          color: isGreen 
                              ? const Color(0xFF10B981).withOpacity(0.2)
                              : const Color(0xFFEF4444).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: iconSize * 0.6,
                          color: isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          flag,
                          style: GoogleFonts.inter(
                            fontSize: (screenWidth * 0.033).clamp(11.0, isLargeScreen ? 18.0 : 16.0),
                            color: const Color(0xFF2D2D2D),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          SizedBox(height: (screenWidth * 0.02).clamp(6.0, 10.0)),
        ],
      ),
    );
  }
}