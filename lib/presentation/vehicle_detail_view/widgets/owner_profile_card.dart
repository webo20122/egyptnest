import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OwnerProfileCard extends StatelessWidget {
  final Map<String, dynamic> owner;
  final VoidCallback onContact;

  const OwnerProfileCard({
    Key? key,
    required this.owner,
    required this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Vehicle Owner',
              style: AppTheme.lightTheme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 2.h),
          Row(children: [
            // Owner avatar
            Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        width: 2)),
                child: ClipOval(
                    child: CustomImageWidget(
                        imageUrl: owner['profileImage'] ?? '',
                        width: 15.w, height: 15.w, fit: BoxFit.cover))),
            SizedBox(width: 4.w),
            // Owner info
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Expanded(
                        child: Text(owner['name'],
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold))),
                    if (owner['verified'] == true) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                          iconName: 'verified',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16),
                    ],
                  ]),
                  SizedBox(height: 1.h),
                  Row(children: [
                    CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.getWarningColor(true),
                        size: 16),
                    SizedBox(width: 1.w),
                    Text(owner['rating'].toString(),
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(width: 2.w),
                    Text('• Member since ${owner['memberSince']}',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6))),
                  ]),
                  SizedBox(height: 1.h),
                  Row(children: [
                    CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.getSuccessColor(true),
                        size: 16),
                    SizedBox(width: 1.w),
                    Expanded(
                        child: Text(owner['responseTime'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                                    color: AppTheme.getSuccessColor(true),
                                    fontWeight: FontWeight.w500))),
                  ]),
                ])),
          ]),
          SizedBox(height: 3.h),
          // Contact button
          SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                  onPressed: onContact,
                  icon: CustomIconWidget(
                      iconName: 'message',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18),
                  label: const Text('Contact Owner'),
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h)))),
          SizedBox(height: 2.h),
          // Owner stats
          Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Expanded(child: _buildStatItem('Vehicles', '12')),
                Container(
                    width: 1,
                    height: 5.h,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3)),
                Expanded(child: _buildStatItem('Trips', '247')),
                Container(
                    width: 1,
                    height: 5.h,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3)),
                Expanded(child: _buildStatItem('Rating', '4.9')),
              ])),
        ]));
  }

  Widget _buildStatItem(String label, String value) {
    return Column(children: [
      Text(value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.bold)),
      SizedBox(height: 0.5.h),
      Text(label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6))),
    ]);
  }
}