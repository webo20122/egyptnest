import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/skip_button_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  Timer? _autoAdvanceTimer;
  bool _userInteracted = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Discover Your Perfect Home",
      "description":
          "Find verified properties across Egypt with detailed photos, reviews, and instant booking. From Cairo apartments to Red Sea resorts, your ideal accommodation awaits.",
      "imageUrl":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=80&w=1000&ixlib=rb-4.0.3",
    },
    {
      "title": "Buy & Sell Real Estate",
      "description":
          "Connect with verified property owners and buyers. Browse exclusive listings, schedule viewings, and complete transactions with Egyptian legal documentation support.",
      "imageUrl":
          "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=1000",
    },
    {
      "title": "Vehicle Marketplace",
      "description":
          "Rent or buy cars, motorcycles, and commercial vehicles. All listings include inspection reports, insurance options, and secure payment through Egyptian gateways.",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/04/01/12/11/car-1300629_1280.jpg",
    },
    {
      "title": "Trusted Egyptian Platform",
      "description":
          "Built for Egypt with Arabic language support, local payment methods, and government ID verification. Join thousands of verified users in our secure marketplace.",
      "imageUrl":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?fm=jpg&q=80&w=1000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _startAutoAdvanceTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    if (!_userInteracted && _currentPage < _onboardingData.length - 1) {
      _autoAdvanceTimer = Timer(const Duration(seconds: 8), () {
        if (mounted && !_userInteracted) {
          _nextPage();
        }
      });
    }
  }

  void _pauseAutoAdvance() {
    setState(() {
      _userInteracted = true;
    });
    _autoAdvanceTimer?.cancel();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      _startAutoAdvanceTimer();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pauseAutoAdvance();
      HapticFeedback.lightImpact();
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pauseAutoAdvance();
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _getStarted() {
    HapticFeedback.heavyImpact();
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _startAutoAdvanceTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data =
                          _onboardingData[index];
                      return OnboardingPageWidget(
                        title: data["title"] as String,
                        description: data["description"] as String,
                        imageUrl: data["imageUrl"] as String,
                        isLastPage: index == _onboardingData.length - 1,
                        onGetStarted: _getStarted,
                      );
                    },
                  ),
                ),

                // Page indicator
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),
                ),

                // Navigation controls
                if (_currentPage < _onboardingData.length - 1)
                  NavigationControlsWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                    onNext: () {
                      _pauseAutoAdvance();
                      _nextPage();
                    },
                    onPrevious: () {
                      _pauseAutoAdvance();
                      _previousPage();
                    },
                    isLastPage: _currentPage == _onboardingData.length - 1,
                  )
                else
                  SizedBox(height: 8.h),
              ],
            ),

            // Skip button
            if (_currentPage < _onboardingData.length - 1)
              SkipButtonWidget(
                onSkip: _skipToEnd,
              ),

            // Auto-advance progress indicator
            if (!_userInteracted && _currentPage < _onboardingData.length - 1)
              Positioned(
                top: 12.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'timer',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Auto-advance in 8s',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
