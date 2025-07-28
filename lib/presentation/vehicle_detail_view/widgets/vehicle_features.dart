import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VehicleFeatures extends StatelessWidget {
  final List<String> features;

  const VehicleFeatures({
    Key? key,
    required this.features,
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
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features & Amenities',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            children:
                features.map((feature) => _buildFeatureChip(feature)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String feature) {
    IconData iconData;

    // Assign icons based on feature type
    switch (feature.toLowerCase()) {
      case 'air conditioning':
        iconData = Icons.ac_unit;
        break;
      case 'gps navigation':
        iconData = Icons.navigation;
        break;
      case 'bluetooth':
        iconData = Icons.bluetooth;
        break;
      case 'leather seats':
        iconData = Icons.airline_seat_recline_extra;
        break;
      case 'sunroof':
        iconData = Icons.wb_sunny;
        break;
      case 'parking sensors':
        iconData = Icons.sensors;
        break;
      case 'backup camera':
        iconData = Icons.camera_rear;
        break;
      case 'heated seats':
        iconData = Icons.whatshot;
        break;
      case 'premium sound system':
        iconData = Icons.speaker;
        break;
      case 'keyless entry':
        iconData = Icons.key;
        break;
      default:
        iconData = Icons.check_circle_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            feature,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
