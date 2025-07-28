import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/brand_tagline_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _containerAnimation;

  String _loadingText = 'Initializing marketplace...';
  bool _isInitialized = false;
  bool _hasError = false;
  int _retryCount = 0;

  // Mock user data for navigation logic
  final Map<String, dynamic> _mockUserData = {
    "isAuthenticated": false,
    "isFirstTime": true,
    "hasCompletedOnboarding": false,
    "userId": null,
    "userPreferences": {"language": "en", "currency": "EGP", "theme": "light"}
  };

  // Mock marketplace data
  final List<Map<String, dynamic>> _mockCategories = [
    {
      "id": 1,
      "name": "Properties",
      "type": "rental",
      "count": 1250,
      "featured": true
    },
    {
      "id": 2,
      "name": "Real Estate",
      "type": "sale",
      "count": 890,
      "featured": true
    },
    {
      "id": 3,
      "name": "Vehicles",
      "type": "rental",
      "count": 340,
      "featured": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setSystemUIOverlay();
    _initializeApp();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _containerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));

    _mainAnimationController.forward();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.lightTheme.colorScheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate authentication check
      await _checkAuthenticationStatus();

      // Load user preferences
      await _loadUserPreferences();

      // Fetch marketplace categories
      await _fetchMarketplaceCategories();

      // Prepare cached property data
      await _prepareCachedData();

      setState(() {
        _isInitialized = true;
        _loadingText = 'Ready to explore!';
      });

      // Navigate after successful initialization
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _loadingText = 'Connection issue. Tap to retry.';
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    setState(() {
      _loadingText = 'Checking authentication...';
    });

    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate authentication check logic
    // In real app, this would check stored tokens, session validity, etc.
    _mockUserData["isAuthenticated"] = false; // Simulate non-authenticated user
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _loadingText = 'Loading preferences...';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate loading user preferences from local storage
    // In real app, this would use SharedPreferences or secure storage
  }

  Future<void> _fetchMarketplaceCategories() async {
    setState(() {
      _loadingText = 'Fetching marketplace data...';
    });

    await Future.delayed(const Duration(milliseconds: 700));

    // Simulate API call to fetch categories
    // In real app, this would make HTTP requests to backend
  }

  Future<void> _prepareCachedData() async {
    setState(() {
      _loadingText = 'Preparing cached data...';
    });

    await Future.delayed(const Duration(milliseconds: 400));

    // Simulate preparing cached property data for offline viewing
    // In real app, this would cache recent searches, favorites, etc.
  }

  void _navigateToNextScreen() {
    // Navigation logic based on user state
    if (_mockUserData["isAuthenticated"] == true) {
      // Authenticated user goes to home dashboard
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else if (_mockUserData["isFirstTime"] == true ||
        _mockUserData["hasCompletedOnboarding"] == false) {
      // New user goes to onboarding
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      // Returning non-authenticated user goes to login
      // For now, redirect to home dashboard as login screen not specified
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    }
  }

  void _handleRetry() {
    if (_hasError && _retryCount < 3) {
      setState(() {
        _hasError = false;
        _retryCount++;
        _loadingText = 'Retrying connection...';
      });
      _initializeApp();
    } else if (_retryCount >= 3) {
      // After 3 retries, show force update or offline mode
      setState(() {
        _loadingText = 'Please check your connection';
      });
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    // Reset system UI overlay
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            const BackgroundGradientWidget(),

            // Main content
            AnimatedBuilder(
              animation: _containerAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _containerAnimation.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Spacer to push content up slightly
                        SizedBox(height: 10.h),

                        // Animated logo
                        const AnimatedLogoWidget(),

                        SizedBox(height: 4.h),

                        // Brand tagline
                        const BrandTaglineWidget(),

                        // Flexible spacer
                        const Spacer(),

                        // Loading indicator or error state
                        _hasError ? _buildErrorState() : _buildLoadingState(),

                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return LoadingIndicatorWidget(
      loadingText: _loadingText,
    );
  }

  Widget _buildErrorState() {
    return GestureDetector(
      onTap: _handleRetry,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              _loadingText,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
            if (_retryCount < 3) ...[
              SizedBox(height: 0.5.h),
              Text(
                'Tap to retry',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.7),
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
