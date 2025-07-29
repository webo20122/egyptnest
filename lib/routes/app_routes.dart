import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/property_search_and_filters/property_search_and_filters.dart';
import '../presentation/booking_management/booking_management.dart';
import '../presentation/property_detail_view/property_detail_view.dart';
import '../presentation/vehicle_marketplace/vehicle_marketplace.dart';
import '../presentation/vehicle_detail_view/vehicle_detail_view.dart';
import '../presentation/messages_and_chat/messages_and_chat.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/host_dashboard/host_dashboard.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String registrationScreen = '/registration-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String propertySearchAndFilters = '/property-search-and-filters';
  static const String bookingManagement = '/booking-management';
  static const String propertyDetailView = '/property-detail-view';
  static const String vehicleMarketplace = '/vehicle-marketplace';
  static const String vehicleDetailView = '/vehicle-detail-view';
  static const String messagesAndChat = '/messages-and-chat';
  static const String userProfileSettings = '/user-profile-settings';
  static const String hostDashboard = '/host-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    registrationScreen: (context) => const RegistrationScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    propertySearchAndFilters: (context) => const PropertySearchAndFilters(),
    bookingManagement: (context) => const BookingManagement(),
    propertyDetailView: (context) => PropertyDetailView(),
    vehicleMarketplace: (context) => const VehicleMarketplace(),
    vehicleDetailView: (context) => const VehicleDetailView(),
    messagesAndChat: (context) => const MessagesAndChat(),
    userProfileSettings: (context) => const UserProfileSettings(),
    hostDashboard: (context) => const HostDashboard(),
  };
}
