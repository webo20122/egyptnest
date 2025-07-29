import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditProfile;
  final VoidCallback onViewBookings;
  final VoidCallback onViewReviews;
  final VoidCallback onViewFavorites;

  const ProfileSectionWidget({
    Key? key,
    required this.userData,
    required this.onEditProfile,
    required this.onViewBookings,
    required this.onViewReviews,
    required this.onViewFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        Card(
          child: Column(
            children: [
              _buildProfileTile(
                icon: 'person',
                title: 'Personal Information',
                subtitle: 'Name, email, phone number',
                onTap: onEditProfile,
              ),
              const Divider(height: 1),
              _buildProfileTile(
                icon: 'event_available',
                title: 'My Bookings',
                subtitle: '${userData['completedBookings']} completed bookings',
                onTap: onViewBookings,
              ),
              const Divider(height: 1),
              _buildProfileTile(
                icon: 'rate_review',
                title: 'Reviews & Ratings',
                subtitle: '${userData['reviews']} reviews received',
                onTap: onViewReviews,
              ),
              const Divider(height: 1),
              _buildProfileTile(
                icon: 'favorite',
                title: 'My Favorites',
                subtitle: 'Saved properties and vehicles',
                onTap: onViewFavorites,
              ),
              if (userData['isHost']) ...[
                const Divider(height: 1),
                _buildProfileTile(
                  icon: 'business',
                  title: 'Host Dashboard',
                  subtitle: 'Manage your ${userData['properties']} properties',
                  onTap: () {
                    Navigator.pushNamed(context, '/host-dashboard');
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.4),
        size: 16,
      ),
      onTap: onTap,
    );
  }
}