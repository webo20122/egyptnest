import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onAddProperty;
  final VoidCallback onManageCalendar;
  final VoidCallback onViewMessages;
  final VoidCallback onViewAnalytics;

  const QuickActionsWidget({
    Key? key,
    required this.onAddProperty,
    required this.onManageCalendar,
    required this.onViewMessages,
    required this.onViewAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 4.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              context,
              icon: 'add_home',
              title: 'Add Property',
              subtitle: 'List a new property',
              color: AppTheme.lightTheme.colorScheme.primary,
              onTap: onAddProperty,
            ),
            _buildActionCard(
              context,
              icon: 'calendar_today',
              title: 'Manage Calendar',
              subtitle: 'Update availability',
              color: AppTheme.lightTheme.colorScheme.secondary,
              onTap: onManageCalendar,
            ),
            _buildActionCard(
              context,
              icon: 'message',
              title: 'Messages',
              subtitle: 'Chat with guests',
              color: AppTheme.getSuccessColor(true),
              onTap: onViewMessages,
            ),
            _buildActionCard(
              context,
              icon: 'analytics',
              title: 'Analytics',
              subtitle: 'View detailed stats',
              color: AppTheme.getWarningColor(true),
              onTap: onViewAnalytics,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
              ),
              
              const Spacer(),
              
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 0.5.h),
              
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}