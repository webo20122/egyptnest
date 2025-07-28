import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingCardWidget extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onTap;
  final VoidCallback? onMessage;
  final VoidCallback? onCancel;
  final VoidCallback? onCheckIn;

  const BookingCardWidget({
    Key? key,
    required this.booking,
    this.onTap,
    this.onMessage,
    this.onCancel,
    this.onCheckIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppTheme.darkTheme.cardColor
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image and Status
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CustomImageWidget(
                    imageUrl: booking["propertyImage"] as String,
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 2.h,
                  right: 4.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking["status"] as String),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking["status"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Booking Details
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Name and Location
                  Text(
                    booking["propertyName"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isDarkMode
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          booking["location"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Dates and Duration
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check-in',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                              ),
                            ),
                            Text(
                              booking["checkInDate"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isDarkMode
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.textPrimaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        size: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Check-out',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                              ),
                            ),
                            Text(
                              booking["checkOutDate"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isDarkMode
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.textPrimaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Price and Guests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                          Text(
                            booking["totalPrice"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'people',
                            color: isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${booking["guests"]} guests',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Action Buttons
                  Row(
                    children: [
                      if (onMessage != null) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onMessage,
                            icon: CustomIconWidget(
                              iconName: 'message',
                              color: isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight,
                              size: 16,
                            ),
                            label: Text('Message'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                      ],
                      if (onCheckIn != null &&
                          booking["status"] == "Confirmed") ...[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onCheckIn,
                            icon: CustomIconWidget(
                              iconName: 'qr_code',
                              color: Colors.white,
                              size: 16,
                            ),
                            label: Text('Check-in'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                          ),
                        ),
                      ] else if (onCancel != null &&
                          booking["status"] == "Upcoming") ...[
                        Expanded(
                          child: TextButton.icon(
                            onPressed: onCancel,
                            icon: CustomIconWidget(
                              iconName: 'cancel',
                              color: AppTheme.errorLight,
                              size: 16,
                            ),
                            label: Text(
                              'Cancel',
                              style: TextStyle(color: AppTheme.errorLight),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.successLight;
      case 'upcoming':
        return AppTheme.primaryLight;
      case 'current':
        return AppTheme.warningLight;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return AppTheme.errorLight;
      default:
        return AppTheme.primaryLight;
    }
  }
}
