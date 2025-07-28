import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortBottomSheetWidget({
    Key? key,
    required this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'key': 'Price', 'label': 'Price (Low to High)', 'icon': 'trending_up'},
      {
        'key': 'Price_Desc',
        'label': 'Price (High to Low)',
        'icon': 'trending_down'
      },
      {'key': 'Rating', 'label': 'Highest Rated', 'icon': 'star'},
      {'key': 'Distance', 'label': 'Nearest First', 'icon': 'near_me'},
      {'key': 'Newest', 'label': 'Recently Added', 'icon': 'access_time'},
      {
        'key': 'Availability',
        'label': 'Available First',
        'icon': 'check_circle'
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Sort By',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          ...sortOptions.map((option) {
            final isSelected = currentSort == option['key'];
            return ListTile(
              leading: CustomIconWidget(
                iconName: option['icon'] as String,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                size: 24,
              ),
              title: Text(
                option['label'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              trailing: isSelected
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () {
                onSortChanged(option['key'] as String);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
