import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionScreen extends StatefulWidget {
  final VoidCallback onSubscribe;

  const SubscriptionScreen({
    super.key,
    required this.onSubscribe,
  });

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 1; // Default to yearly (middle option)

  @override
  Widget build(BuildContext context) {
    print('🔴 PREMIUM_DEBUG: SubscriptionScreen build called');
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          print('🔴 PREMIUM_DEBUG: SubscriptionScreen - Back button pressed, closing screen');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background layer - ignores pointer events to block CardNavigator tap zones
            // But allows widgets above in Stack to receive pointer events
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFAFAFA), // Off white
                        Color(0xFFF5F5F5), // Light gray
                        Color(0xFFF0F0F0), // Soft gray
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Content layer - positioned above AbsorbPointer
            SafeArea(
              child: Column(
                children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF2D2D2D), size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Centered content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Choose Your Plan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1C1C1E),
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        'Unlock all premium insights',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8E93),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
              
                      // Subscription options in a row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Monthly option
                            Expanded(
                              child: _buildSubscriptionBox(
                                index: 0,
                                title: 'Monthly',
                                price: '\$4.99',
                                period: '/mo',
                                badge: null,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Yearly option (highlighted)
                            Expanded(
                              child: _buildSubscriptionBox(
                                index: 1,
                                title: 'Yearly',
                                price: '\$19.99',
                                period: '/yr',
                                badge: 'SAVE 67%',
                              ),
                            ),
                            const SizedBox(width: 6),
                            // One-time option
                            Expanded(
                              child: _buildSubscriptionBox(
                                index: 2,
                                title: 'One Time',
                                price: '\$9.99',
                                period: 'once',
                                badge: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    print('🔴 PREMIUM_DEBUG: SubscriptionScreen - Continue button tapped');
                    // Close this screen and trigger premium navigation
                    Navigator.pop(context);
                    print('🔴 PREMIUM_DEBUG: SubscriptionScreen - Calling widget.onSubscribe()');
                    widget.onSubscribe();
                  },
                  behavior: HitTestBehavior.opaque, // Ensure this captures taps
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B9D),
                          Color(0xFFFF8E9E),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getBulletPoints(int index) {
    switch (index) {
      case 0: // Monthly
        return [
          'All premium insights',
          'Billed monthly',
          'Cancel anytime',
        ];
      case 1: // Yearly
        return [
          'All premium insights',
          'Best value - save 67%',
          'Billed once per year',
        ];
      case 2: // One-time
        return [
          'All premium insights',
          'Single payment only',
          'Instant lifetime access',
        ];
      default:
        return [];
    }
  }

  Widget _buildSubscriptionBox({
    required int index,
    required String title,
    required String price,
    required String period,
    String? badge,
  }) {
    final isSelected = _selectedIndex == index;
    final bullets = _getBulletPoints(index);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B9D)
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1C1C1E),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (badge != null)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B9D),
                                  Color(0xFFFF8E9E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFF6B9D),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          period,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF8E8E93),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Bullet points
                  ...bullets.map((bullet) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1C1C1E).withOpacity(0.8),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            bullet,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8E8E93),
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              letterSpacing: -0.1,
                            ),
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            // Checkmark for selected
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF6B9D),
                        Color(0xFFFF8E9E),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

