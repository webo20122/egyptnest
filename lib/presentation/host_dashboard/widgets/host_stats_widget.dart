import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HostStatsWidget extends StatelessWidget {
  final Map<String, dynamic> hostData;

  const HostStatsWidget({
    Key? key,
    required this.hostData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
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
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              context,
              icon: 'account_balance_wallet',
              title: 'Total Earnings',
              value: 'EGP ${_formatNumber(hostData['totalEarnings'])}',
              subtitle: 'All time',
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            _buildStatCard(
              context,
              icon: 'trending_up',
              title: 'This Month',
              value: 'EGP ${_formatNumber(hostData['monthlyEarnings'])}',
              subtitle: '+12% from last month',
              color: AppTheme.getSuccessColor(true),
            ),
            _buildStatCard(
              context,
              icon: 'event_available',
              title: 'Total Bookings',
              value: '${hostData['totalBookings']}',
              subtitle: 'Completed bookings',
              color: AppTheme.lightTheme.colorScheme.secondary,
            ),
            _buildStatCard(
              context,
              icon: 'home',
              title: 'Active Properties',
              value: '${hostData['activeProperties']}',
              subtitle: 'Currently listed',
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ],
        ),
        
        SizedBox(height: 3.h),
        
        // Performance Indicators
        Card(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Metrics',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 3.h),
                
                _buildMetricRow(
                  context,
                  icon: 'hotel',
                  title: 'Occupancy Rate',
                  value: '${hostData['occupancyRate']}%',
                  progress: hostData['occupancyRate'] / 100,
                  color: AppTheme.getSuccessColor(true),
                ),
                
                SizedBox(height: 2.h),
                
                _buildMetricRow(
                  context,
                  icon: 'star',
                  title: 'Average Rating',
                  value: '${hostData['averageRating']}/5.0',
                  progress: hostData['averageRating'] / 5,
                  color: AppTheme.getWarningColor(true),
                ),
                
                SizedBox(height: 2.h),
                
                _buildMetricRow(
                  context,
                  icon: 'speed',
                  title: 'Response Rate',
                  value: '${hostData['responseRate']}%',
                  progress: hostData['responseRate'] / 100,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
            
            const Spacer(),
            
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            
            SizedBox(height: 0.5.h),
            
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 1.h),
        
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }
}