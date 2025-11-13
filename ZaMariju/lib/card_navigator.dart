import 'package:flutter/material.dart';

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
  State<CardNavigator> createState() => _CardNavigatorState();
}

class _CardNavigatorState extends State<CardNavigator>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _transitionController;

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
    if (_currentIndex < widget.screens.length - 1) {
      // Check if we're at the premium gate
      if (widget.premiumStartIndex != null &&
          _currentIndex == widget.premiumStartIndex! - 1) {
        // Don't advance, user needs to click "Go Premium" button
        return;
      }
      
      await _transitionController.forward();
      setState(() {
        _currentIndex++;
      });
      _transitionController.reset();
    } else {
      // We're at the last screen
      if (widget.onComplete != null) {
        widget.onComplete!();
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
          // Disable tap zones on screens with buttons
          if (_shouldEnableTapZones())
            Positioned.fill(
              child: Row(
                children: [
                  // Left tap zone (33% of screen width) - Go Previous
                  Expanded(
                    flex: 33,
                    child: GestureDetector(
                      onTap: _goToPrevious,
                      behavior: HitTestBehavior.translucent,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Right tap zone (67% of screen width) - Go Next
                  Expanded(
                    flex: 67,
                    child: GestureDetector(
                      onTap: _goToNext,
                      behavior: HitTestBehavior.translucent,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
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
    // Disable tap zones on screens with buttons to allow button clicks
    if (widget.premiumStartIndex != null) {
      // Disable on the screen before premium (has "Go Premium" button)
      if (_currentIndex == widget.premiumStartIndex! - 1) {
        return false;
      }
    }
    // Disable on last screen (has "Back to Main" button)
    if (_currentIndex == widget.screens.length - 1) {
      return false;
    }
    // Disable tap zones on SubscriptionScreen (check by widget type)
    final currentScreen = widget.screens[_currentIndex];
    if (currentScreen.runtimeType.toString() == 'SubscriptionScreen') {
      return false;
    }
    return true;
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

