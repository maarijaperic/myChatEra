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
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                
                // Question
                Text(
                  widget.question,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: (screenWidth * 0.065).clamp(24.0, 28.0),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.04),
                
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
                
                SizedBox(height: screenHeight * 0.03),
                
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
                
                SizedBox(height: screenHeight * 0.03),
                
                // Subtitle
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: (screenWidth * 0.035).clamp(13.0, 16.0),
                    color: Colors.white.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.02),
                
                // Share Button
                ShareToStoryButton(
                  shareText: 'Check out my ChatGPT Red and Green Flags! 🟢🔴 #ChatGPTWrapped',
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: (screenWidth * 0.048).clamp(18.0, 22.0),
                fontWeight: FontWeight.w700,
                color: isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Flags List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: flags.map((flag) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 10, top: 2),
                        decoration: BoxDecoration(
                          color: isGreen 
                              ? const Color(0xFF10B981).withOpacity(0.2)
                              : const Color(0xFFEF4444).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: isGreen ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          flag,
                          style: GoogleFonts.inter(
                            fontSize: (screenWidth * 0.035).clamp(13.0, 15.0),
                            color: const Color(0xFF2D2D2D),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}