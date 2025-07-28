import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapViewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> vehicles;
  final Function(Map<String, dynamic>) onVehicleTap;

  const MapViewWidget({
    Key? key,
    required this.vehicles,
    required this.onVehicleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Stack(
        children: [
          // Map placeholder - In a real implementation, this would be a map widget
          Container(
            width: double.infinity,
            height: double.infinity,
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            child: Stack(
              children: [
                // Map background pattern
                ...List.generate(50, (index) {
                  return Positioned(
                    left: (index % 10) * 10.w,
                    top: (index ~/ 10) * 15.h,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
                // Vehicle markers
                ...vehicles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final vehicle = entry.value;

                  // Simulate different positions based on index
                  final left = (20 + (index * 15)) % 80;
                  final top = (20 + (index * 20)) % 70;

                  return Positioned(
                    left: left.toDouble().w,
                    top: top.toDouble().h,
                    child: GestureDetector(
                      onTap: () => onVehicleTap(vehicle),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: vehicle['type'] == 'Motorcycle'
                                  ? 'motorcycle'
                                  : 'directions_car',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 16,
                            ),
                            Text(
                              vehicle['price'].split('/')[0],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          // Map controls
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: () {
                    // Zoom in functionality
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
                SizedBox(height: 1.h),
                FloatingActionButton.small(
                  onPressed: () {
                    // Zoom out functionality
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  child: CustomIconWidget(
                    iconName: 'remove',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                ),
                SizedBox(height: 1.h),
                FloatingActionButton.small(
                  onPressed: () {
                    // My location functionality
                  },
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  child: CustomIconWidget(
                    iconName: 'my_location',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          // Legend
          Positioned(
            bottom: 2.h,
            left: 4.w,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Legend',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Available',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Booked',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 2.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Tap markers to view details',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
