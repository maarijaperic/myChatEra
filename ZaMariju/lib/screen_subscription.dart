import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt_wrapped2/services/revenuecat_service.dart';
import 'package:gpt_wrapped2/services/analysis_tracker.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';
import 'package:url_launcher/url_launcher.dart';

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
  static const _accent = Color(0xFFEC8AAE);
  static const _accentGradient = LinearGradient(
    colors: [Color(0xFFEC8AAE), Color(0xFFF3A9C4)],
  );
  static const _shareBullet = 'Analyze your friends\' chats too';

  int _selectedIndex = 1; // Default to the 3-analysis pack (best value)
  bool _isLoading = false;
  String? _errorMessage; // Store error message to display

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
                  decoration: const BoxDecoration(gradient: WrappedColors.background),
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
                      const GlowOrb(emoji: '💎', color: WrappedColors.pink, size: 120),
                      Text(
                        'PREMIUM',
                        style: GoogleFonts.inter(
                          color: WrappedColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      HighlightText(
                        'Choose your *plan*',
                        accent: WrappedColors.pinkDeep,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: WrappedColors.ink,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
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
                            Expanded(
                              child: _buildSubscriptionBox(
                                index: 0,
                                title: 'One Analysis',
                                price: '\$4.99',
                                period: 'once',
                                badge: null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildSubscriptionBox(
                                index: 1,
                                title: '3 Analyses',
                                price: '\$9.99',
                                period: 'pack',
                                badge: 'BEST VALUE',
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Error message display
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Error Details:',
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTermsAndPrivacyLinks(),
              ),
              
              const SizedBox(height: 16),
              
              // Continue/Purchase button (stays pink while loading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: WrappedPillButton(
                  label: 'Continue',
                  color: _accent,
                  loading: _isLoading,
                  onTap: _handlePurchase,
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
      case 0: // Single analysis
        return [
          'All premium insights',
          '1 full analysis',
          'One-time payment',
        ];
      case 1: // 3-analysis pack (best value)
        return [
          'All premium insights',
          '3 full analyses',
          _shareBullet,
          'Only \$3.33 each',
        ];
      default:
        return [];
    }
  }

  Widget _buildTermsAndPrivacyLinks() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        Text(
          'By continuing, you agree to our ',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF8E8E93),
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: _openTermsOfUse,
          child: Text(
            'Terms of Use',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: _accent,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          ' and ',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(0xFF8E8E93),
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: _openPrivacyPolicy,
          child: Text(
            'Privacy Policy',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: _accent,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openTermsOfUse() async {
    final url = Uri.parse('https://github.com/maarijaperic/myChatEra-legal/blob/main/TERMS_OF_SERVICE.md');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Terms of Use'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Terms of Use'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final url = Uri.parse('https://github.com/maarijaperic/myChatEra-legal/blob/main/PRIVACY_POLICY.md');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Privacy Policy'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Privacy Policy'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handlePurchase() async {
    print('🔴 PREMIUM_DEBUG: _handlePurchase CALLED - Starting purchase flow');
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error
    });

    try {
      // Production mode: Use RevenueCat
      final productId = RevenueCatService.getProductId(_selectedIndex);
      print('🔴 PREMIUM_DEBUG: Purchasing product: $productId');
      print('🔴 PREMIUM_DEBUG: Selected index: $_selectedIndex');
      
      print('🔴 PREMIUM_DEBUG: About to call RevenueCatService.purchaseProduct()');

      final success = await RevenueCatService.purchaseProduct(productId);
      print('🔴 PREMIUM_DEBUG: RevenueCatService.purchaseProduct() returned: $success');

      if (success) {
        print('🔴 PREMIUM_DEBUG: Purchase successful');
        
        final purchasedAnalyses = RevenueCatService.analysesForProduct(productId);
        if (purchasedAnalyses > 0) {
          try {
            final userId = await RevenueCatService.getUserId();
            if (userId.isNotEmpty) {
              await AnalysisTracker.incrementOneTimePurchase(userId, count: purchasedAnalyses);
              print('🔴 PREMIUM_DEBUG: One-time purchase count incremented');
            }
          } catch (e) {
            print('⚠️ PREMIUM_DEBUG: Error incrementing one-time purchase count: $e');
            // Don't fail the purchase if this fails
          }
        }
        
        if (mounted) {
          Navigator.pop(context);
          widget.onSubscribe();
        }
      } else {
        print('🔴 PREMIUM_DEBUG: Purchase failed or cancelled');
        print('🔴 PREMIUM_DEBUG: Check RevenueCat logs above for details');
        
        // Don't show error message to user - purchase might have been cancelled
        // which is a normal user action, not an error
        // Apple review will handle actual purchase failures through their sandbox
        
        // Only show a simple message if there's a persistent error
        // For now, we'll just reset the loading state silently
        // The user can try again if needed
      }
    } catch (e, stackTrace) {
      print('🔴 PREMIUM_DEBUG: Purchase error: $e');
      print('🔴 PREMIUM_DEBUG: Stack trace: $stackTrace');
      
      // Only show user-friendly error messages, not technical details
      String userMessage = 'Unable to complete purchase. Please try again.';
      
      // Check if it's a specific error type we can handle
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        userMessage = 'Network error. Please check your connection and try again.';
      } else if (e.toString().contains('cancelled') || e.toString().contains('canceled')) {
        // Don't show error for user cancellation
        print('🔴 PREMIUM_DEBUG: User cancelled purchase - not showing error');
        return; // Exit early, don't show error
      }
      
      if (mounted) {
        // Only show error message (not debug details)
        setState(() {
          _errorMessage = userMessage;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _accent : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? _accent.withOpacity(0.18)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: isSelected ? 18 : 10,
                  offset: Offset(0, isSelected ? 8 : 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1C1C1E),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            price,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1C1C1E),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              period,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8E8E93),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...bullets.map((bullet) => _buildBullet(bullet)),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        gradient: _accentGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
          if (badge != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: GoogleFonts.inter(
                  color: const Color(0xFFC75A85),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBullet(String bullet) {
    final highlighted = bullet == _shareBullet;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 4),
            child: highlighted
                ? const Icon(Icons.people_alt_rounded, size: 13, color: _accent)
                : Text(
                    '•',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1C1C1E).withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              bullet,
              style: GoogleFonts.inter(
                color: highlighted ? const Color(0xFFC75A85) : const Color(0xFF8E8E93),
                fontSize: 12,
                fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
                height: 1.25,
                letterSpacing: -0.1,
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

