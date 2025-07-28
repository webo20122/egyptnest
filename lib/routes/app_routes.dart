import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/property_search_and_filters/property_search_and_filters.dart';
import '../presentation/booking_management/booking_management.dart';
import '../presentation/property_detail_view/property_detail_view.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String splashScreen = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String propertySearchAndFilters = '/property-search-and-filters';
  static const String bookingManagement = '/booking-management';
  static const String propertyDetailView = '/property-detail-view';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    splashScreen: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    propertySearchAndFilters: (context) => const PropertySearchAndFilters(),
    bookingManagement: (context) => const BookingManagement(),
    propertyDetailView: (context) => PropertyDetailView(),
    // TODO: Add your other routes here
  };
}