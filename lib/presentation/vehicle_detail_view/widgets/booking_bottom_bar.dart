import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingBottomBar extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onBookNow;
  final VoidCallback onContactOwner;

  const BookingBottomBar({
    Key? key,
    required this.vehicle,
    required this.onBookNow,
    required this.onContactOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAvailable = vehicle['availability'] == 'Available';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price and availability info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle['price'],
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.lightTheme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            vehicle['availability'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isAvailable
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.lightTheme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Action buttons
            Row(
              children: [
                // Contact Owner button
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: onContactOwner,
                    icon: CustomIconWidget(
                      iconName: 'message',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    label: const Text('Contact'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                // Book Now button
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: isAvailable ? onBookNow : null,
                    icon: CustomIconWidget(
                      iconName: isAvailable ? 'event_available' : 'event_busy',
                      color: isAvailable
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                      size: 18,
                    ),
                    label: Text(isAvailable ? 'Book Now' : 'Unavailable'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      backgroundColor: isAvailable
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
            ),
            if (!isAvailable) ...[
              SizedBox(height: 1.h),
              Text(
                'This vehicle is currently booked. Check similar vehicles or contact the owner for alternative dates.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
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
