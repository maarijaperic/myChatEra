import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class CardNavigator extends StatefulWidget {
  final List<Widget> screens;
  final int startIndex;
  final int? premiumStartIndex;
  final VoidCallback? onPremiumTap;
  final VoidCallback? onComplete;

  const CardNavigator({
    super.key,
    required this.screens,
    this.startIndex = 0,
    this.premiumStartIndex,
    this.onPremiumTap,
    this.onComplete,
  });

  @override
  State<CardNavigator> createState() => CardNavigatorState();
  
  // Static method to get navigator from context
  static CardNavigatorState? of(BuildContext context) {
    return context.findAncestorStateOfType<CardNavigatorState>();
  }
}

// Export the state class so it can be accessed from other files
class CardNavigatorState extends State<CardNavigator>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _transitionController;
  
  // Getter to access current index (for debugging)
  int get currentIndex => _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _goToNext() async {
    try {
    if (_currentIndex < widget.screens.length - 1) {
      // Check if we're at the premium gate
      if (widget.premiumStartIndex != null &&
          _currentIndex == widget.premiumStartIndex! - 1) {
        // Don't advance, user needs to click "Go Premium" button
        return;
      }
        
        final nextIndex = _currentIndex + 1;
        print('🔵 CardNavigator: Navigating from index $_currentIndex to $nextIndex');
        print('🔵 CardNavigator: Total screens: ${widget.screens.length}');
        print('🔵 CardNavigator: Next screen type: ${widget.screens[nextIndex].runtimeType}');
        
        // Check if next screen exists and is valid
        if (nextIndex >= widget.screens.length) {
          print('❌ CardNavigator: Next index $nextIndex is out of bounds!');
          return;
        }
      
      await _transitionController.forward();
        if (mounted) {
      setState(() {
            _currentIndex = nextIndex;
      });
          print('🔵 CardNavigator: Successfully navigated to index $_currentIndex');
        }
      _transitionController.reset();
    } else {
      // We're at the last screen
        print('🔵 CardNavigator: At last screen (index $_currentIndex), calling onComplete');
      if (widget.onComplete != null) {
        widget.onComplete!();
        }
      }
    } catch (e, stackTrace) {
      print('❌ CardNavigator: Error in _goToNext: $e');
      print('❌ CardNavigator: Stack trace: $stackTrace');
      // Don't crash the app, just log the error
      // Try to recover by staying on current screen
      if (mounted) {
        _transitionController.reset();
      }
    }
  }

  void _goToPrevious() async {
    if (_currentIndex > 0) {
      await _transitionController.forward();
      setState(() {
        _currentIndex--;
      });
      _transitionController.reset();
    }
  }

  void goToNext() => _goToNext();

  void goToPrevious() => _goToPrevious();

  /// Navigate to a specific screen index
  Future<void> goToIndex(int index) async {
    print('🔵 CardNavigator: goToIndex called with index=$index, currentIndex=$_currentIndex, totalScreens=${widget.screens.length}');
    if (index >= 0 && index < widget.screens.length && index != _currentIndex) {
      print('🔵 CardNavigator: Navigating to index $index');
      await _transitionController.forward();
      if (mounted) {
        setState(() {
          _currentIndex = index;
          print('🔵 CardNavigator: Updated _currentIndex to $index');
        });
      }
      _transitionController.reset();
    } else {
      print('🔵 CardNavigator: Invalid index or same as current. index=$index, currentIndex=$_currentIndex, screens.length=${widget.screens.length}');
    }
  }
  
  /// Navigate to the first screen (index 0)
  Future<void> goToFirstScreen() async {
    print('🔵 CardNavigator: goToFirstScreen called, currentIndex=$_currentIndex');
    if (_currentIndex == 0) {
      print('🔵 CardNavigator: Already on first screen');
      return;
    }
    
    // Directly set index to 0
    print('🔵 CardNavigator: Directly navigating to index 0');
    await goToIndex(0);
    print('🔵 CardNavigator: Reached first screen (index 0)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Current screen
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: widget.screens[_currentIndex],
            ),
          ),

          // Tap zones for navigation (left and right)
          // Limited to center area of screen to avoid interfering with buttons.
          // Childless translucent detectors let drags fall through to the
          // screen's scroll view, so the zones only claim taps.
          if (_shouldEnableTapZones())
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2, // Start at 20% from top
              bottom: MediaQuery.of(context).size.height * 0.2, // End at 20% from bottom
              left: 0,
              right: 0,
              child: Row(
                children: [
                  // Left tap zone (33% of screen width) - Go Previous
                  Expanded(
                    flex: 33,
                    child: GestureDetector(
                      onTap: _goToPrevious,
                      behavior: HitTestBehavior.translucent,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  // Right tap zone (67% of screen width) - Go Next
                  // Disabled on SocialSharingScreen to allow button clicks
                  Expanded(
                    flex: 67,
                    child: _shouldEnableRightTapZone()
                        ? GestureDetector(
                      onTap: _goToNext,
                      behavior: HitTestBehavior.translucent,
                      child: const SizedBox.expand(),
                          )
                        : Container(), // Empty container - no tap zone
                  ),
                ],
              ),
            ),
          // Special case: Left tap zone only for SocialSharingScreen (to go back)
          if (_shouldEnableLeftTapZoneOnly())
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              bottom: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              width: MediaQuery.of(context).size.width * 0.33, // Only left 33%
              child: GestureDetector(
                onTap: _goToPrevious,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),

          // Instagram-style progress bars at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SafeArea(
                child: _InstagramProgressBars(
                  currentIndex: _currentIndex,
                  totalScreens: _getTotalScreensInCurrentSection(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldEnableTapZones() {
    // Disable tap zones only on specific screens that should not have navigation
    final currentScreen = widget.screens[_currentIndex];
    final screenType = currentScreen.runtimeType.toString();

    // List of screens that should NOT have tap zones for navigation
    // Tap zones are limited to center area (20% from top and bottom) so they won't
    // interfere with share buttons at the bottom of screens
    const screensWithoutNavigation = [
      'TypeABPreviewScreen', // Unlock Premium screen - no swipe navigation, only button click
      'SubscriptionScreen', // Subscription screen - no navigation
    ];

    if (screensWithoutNavigation.contains(screenType)) {
      return false;
    }

    // Disable on premium gate screen (before premium section)
    if (widget.premiumStartIndex != null &&
        _currentIndex == widget.premiumStartIndex! - 1) {
      return false;
    }
    
    // Allow navigation on last screen (SocialSharingScreen) - can go back
    // Enable tap zones for all screens
    return true;
  }

  bool _shouldEnableRightTapZone() {
    // Disable right tap zone on SocialSharingScreen to allow button clicks
    final currentScreen = widget.screens[_currentIndex];
    final screenType = currentScreen.runtimeType.toString();
    
    if (screenType == 'SocialSharingScreen') {
      return false; // Disable right tap zone to allow "View preview" button clicks
    }
    
    return true;
  }

  bool _shouldEnableLeftTapZoneOnly() {
    // Enable only left tap zone (to go back) on screens where the right side holds buttons
    final currentScreen = widget.screens[_currentIndex];
    final screenType = currentScreen.runtimeType.toString();
    
    return screenType == 'SocialSharingScreen' ||
        (screenType == 'TypeABPreviewScreen' && _currentIndex > 0);
  }

  int _getTotalScreensInCurrentSection() {
    if (widget.premiumStartIndex != null && _currentIndex < widget.premiumStartIndex!) {
      return widget.premiumStartIndex!;
    }
    return widget.screens.length;
  }
}

class _InstagramProgressBars extends StatelessWidget {
  final int currentIndex;
  final int totalScreens;

  const _InstagramProgressBars({
    required this.currentIndex,
    required this.totalScreens,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        children: List.generate(
          totalScreens,
          (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                height: 3.0,
                decoration: BoxDecoration(
                  color: index <= currentIndex
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: index == currentIndex
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

