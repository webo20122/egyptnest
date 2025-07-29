import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeaderWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Profile Picture and Verification Badge
          Stack(
            children: [
              CircleAvatar(
                radius: 12.w,
                backgroundImage: NetworkImage(userData['profileImage']),
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              ),
              if (userData['isVerified'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'verified',
                      color: AppTheme.lightTheme.colorScheme.surface,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Name and User Type
          Text(
            userData['name'],
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 1.h),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              userData['isHost'] ? 'Host Member' : 'Guest Member',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          SizedBox(height: 1.h),
          
          Text(
            'Member since ${userData['joinDate']}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: 'event_available',
                value: userData['completedBookings'].toString(),
                label: 'Bookings',
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                icon: 'star',
                value: userData['rating'].toString(),
                label: 'Rating',
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                icon: 'rate_review',
                value: userData['reviews'].toString(),
                label: 'Reviews',
              ),
              if (userData['isHost']) ...[
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
                _buildStatItem(
                  icon: 'home',
                  value: userData['properties'].toString(),
                  label: 'Properties',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}