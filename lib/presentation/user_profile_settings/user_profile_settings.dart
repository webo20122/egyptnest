import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({Key? key}) : super(key: key);

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Ahmed Hassan',
    'email': 'ahmed.hassan@email.com',
    'phone': '+20 123 456 7890',
    'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    'joinDate': 'January 2024',
    'isHost': true,
    'isVerified': true,
    'completedBookings': 12,
    'reviews': 48,
    'rating': 4.8,
    'properties': 3,
  };

  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'EGP';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _handleEditProfile,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            
            // Profile Header
            ProfileHeaderWidget(userData: _userData),
            
            SizedBox(height: 4.h),
            
            // Profile Section
            ProfileSectionWidget(
              userData: _userData,
              onEditProfile: _handleEditProfile,
              onViewBookings: _handleViewBookings,
              onViewReviews: _handleViewReviews,
              onViewFavorites: _handleViewFavorites,
            ),
            
            SizedBox(height: 4.h),
            
            // Settings Section
            SettingsSectionWidget(
              notificationsEnabled: _notificationsEnabled,
              emailNotifications: _emailNotifications,
              smsNotifications: _smsNotifications,
              darkMode: _darkMode,
              selectedLanguage: _selectedLanguage,
              selectedCurrency: _selectedCurrency,
              onNotificationsChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              onEmailNotificationsChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
              onSmsNotificationsChanged: (value) {
                setState(() {
                  _smsNotifications = value;
                });
              },
              onDarkModeChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
              onLanguageChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
              onCurrencyChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
              },
              onHelpPressed: _handleHelp,
              onPrivacyPressed: _handlePrivacy,
              onTermsPressed: _handleTerms,
              onLogoutPressed: _handleLogout,
              onDeleteAccountPressed: _handleDeleteAccount,
            ),
            
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _handleEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileBottomSheet(),
    );
  }

  void _handleViewBookings() {
    Navigator.pushNamed(context, '/booking-management');
  }

  void _handleViewReviews() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reviews feature coming soon!')),
    );
  }

  void _handleViewFavorites() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorites feature coming soon!')),
    );
  }

  void _handleHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Contact us at support@egyptnest.com or call +20 123 456 7890'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handlePrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Policy - Feature coming soon!')),
    );
  }

  void _handleTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of Service - Feature coming soon!')),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileBottomSheet() {
    final nameController = TextEditingController(text: _userData['name']);
    final emailController = TextEditingController(text: _userData['email']);
    final phoneController = TextEditingController(text: _userData['phone']);
    
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          Text(
            'Edit Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Profile Picture
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 8.w,
                  backgroundImage: NetworkImage(_userData['profileImage']),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Form Fields
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          
          SizedBox(height: 3.h),
          
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          
          SizedBox(height: 3.h),
          
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          
          const Spacer(),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}