import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String iconName;
  final bool isHost;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onButtonPressed,
    this.iconName = 'event_note',
    this.isHost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color:
                    (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: (isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight)
                      .withValues(alpha: 0.6),
                  size: 20.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Button
            if (onButtonPressed != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  icon: CustomIconWidget(
                    iconName: isHost ? 'add_home' : 'search',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(buttonText),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 2.h),

            // Additional Tips
            if (isHost) ...[
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: (isDarkMode
                          ? AppTheme.warningDark
                          : AppTheme.warningLight)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (isDarkMode
                            ? AppTheme.warningDark
                            : AppTheme.warningLight)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: isDarkMode
                              ? AppTheme.warningDark
                              : AppTheme.warningLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Tips to get started:',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: isDarkMode
                                ? AppTheme.warningDark
                                : AppTheme.warningLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildTipItem(
                        'Add high-quality photos of your property', isDarkMode),
                    _buildTipItem(
                        'Set competitive pricing for your area', isDarkMode),
                    _buildTipItem(
                        'Write detailed property descriptions', isDarkMode),
                    _buildTipItem(
                        'Respond quickly to booking requests', isDarkMode),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: (isDarkMode
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'explore',
                          color: isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Discover amazing places:',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildTipItem(
                        'Browse properties in Cairo, Alexandria, and more',
                        isDarkMode),
                    _buildTipItem(
                        'Filter by price, location, and amenities', isDarkMode),
                    _buildTipItem(
                        'Read reviews from previous guests', isDarkMode),
                    _buildTipItem(
                        'Book instantly or send requests to hosts', isDarkMode),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
